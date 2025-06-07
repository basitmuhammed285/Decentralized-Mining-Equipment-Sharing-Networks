;; Cost Sharing Contract
;; Manages cost sharing among miners in the network

(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_INSUFFICIENT_FUNDS (err u501))
(define-constant ERR_POOL_NOT_FOUND (err u502))
(define-constant ERR_ALREADY_MEMBER (err u503))

;; Cost sharing pools
(define-map cost-pools
  { pool-id: uint }
  {
    name: (string-ascii 50),
    creator: principal,
    total-members: uint,
    total-contributions: uint,
    pool-type: (string-ascii 30),
    created-block: uint,
    active: bool
  }
)

;; Pool memberships
(define-map pool-memberships
  { pool-id: uint, member: principal }
  {
    contribution-amount: uint,
    join-block: uint,
    share-percentage: uint
  }
)

;; Cost distributions
(define-map cost-distributions
  { pool-id: uint, distribution-id: uint }
  {
    total-cost: uint,
    cost-type: (string-ascii 50),
    distribution-block: uint,
    completed: bool
  }
)

;; Pool counter
(define-data-var pool-counter uint u0)
(define-data-var distribution-counter uint u0)

;; Create cost sharing pool
(define-public (create-cost-pool (name (string-ascii 50)) (pool-type (string-ascii 30)))
  (let ((pool-id (+ (var-get pool-counter) u1)))
    (map-set cost-pools
      { pool-id: pool-id }
      {
        name: name,
        creator: tx-sender,
        total-members: u1,
        total-contributions: u0,
        pool-type: pool-type,
        created-block: block-height,
        active: true
      }
    )

    (map-set pool-memberships
      { pool-id: pool-id, member: tx-sender }
      {
        contribution-amount: u0,
        join-block: block-height,
        share-percentage: u100
      }
    )

    (var-set pool-counter pool-id)
    (ok pool-id)
  )
)

;; Join cost sharing pool
(define-public (join-pool (pool-id uint) (contribution-amount uint))
  (let ((pool (unwrap! (map-get? cost-pools { pool-id: pool-id }) ERR_POOL_NOT_FOUND)))
    (asserts! (get active pool) ERR_UNAUTHORIZED)
    (asserts! (is-none (map-get? pool-memberships { pool-id: pool-id, member: tx-sender })) ERR_ALREADY_MEMBER)

    (let (
      (new-total-members (+ (get total-members pool) u1))
      (new-total-contributions (+ (get total-contributions pool) contribution-amount))
      (share-percentage (if (> new-total-contributions u0)
        (/ (* contribution-amount u100) new-total-contributions)
        u0))
    )
      (map-set cost-pools
        { pool-id: pool-id }
        (merge pool {
          total-members: new-total-members,
          total-contributions: new-total-contributions
        })
      )

      (map-set pool-memberships
        { pool-id: pool-id, member: tx-sender }
        {
          contribution-amount: contribution-amount,
          join-block: block-height,
          share-percentage: share-percentage
        }
      )

      (ok true)
    )
  )
)

;; Distribute costs
(define-public (distribute-costs (pool-id uint) (total-cost uint) (cost-type (string-ascii 50)))
  (let (
    (pool (unwrap! (map-get? cost-pools { pool-id: pool-id }) ERR_POOL_NOT_FOUND))
    (distribution-id (+ (var-get distribution-counter) u1))
  )
    (asserts! (is-eq tx-sender (get creator pool)) ERR_UNAUTHORIZED)

    (map-set cost-distributions
      { pool-id: pool-id, distribution-id: distribution-id }
      {
        total-cost: total-cost,
        cost-type: cost-type,
        distribution-block: block-height,
        completed: true
      }
    )

    (var-set distribution-counter distribution-id)
    (ok distribution-id)
  )
)

;; Get pool details
(define-read-only (get-pool (pool-id uint))
  (map-get? cost-pools { pool-id: pool-id })
)

;; Get membership details
(define-read-only (get-membership (pool-id uint) (member principal))
  (map-get? pool-memberships { pool-id: pool-id, member: member })
)

;; Calculate member cost share
(define-read-only (calculate-cost-share (pool-id uint) (member principal) (total-cost uint))
  (let ((membership (map-get? pool-memberships { pool-id: pool-id, member: member })))
    (match membership
      member-data (/ (* total-cost (get share-percentage member-data)) u100)
      u0
    )
  )
)

;; Get pool counter
(define-read-only (get-pool-counter)
  (var-get pool-counter)
)
