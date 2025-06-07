;; Equipment Owner Verification Contract
;; Validates and manages mining equipment owners

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_EQUIPMENT_EXISTS (err u101))
(define-constant ERR_EQUIPMENT_NOT_FOUND (err u102))
(define-constant ERR_INVALID_OWNER (err u103))

;; Equipment data structure
(define-map equipment-registry
  { equipment-id: uint }
  {
    owner: principal,
    equipment-type: (string-ascii 50),
    hash-rate: uint,
    power-consumption: uint,
    location: (string-ascii 100),
    verified: bool,
    registration-block: uint
  }
)

;; Verified owners
(define-map verified-owners
  { owner: principal }
  { verified: bool, verification-block: uint }
)

;; Equipment counter
(define-data-var equipment-counter uint u0)

;; Register new equipment
(define-public (register-equipment (equipment-type (string-ascii 50)) (hash-rate uint) (power-consumption uint) (location (string-ascii 100)))
  (let ((equipment-id (+ (var-get equipment-counter) u1)))
    (asserts! (is-verified-owner tx-sender) ERR_UNAUTHORIZED)
    (asserts! (is-none (map-get? equipment-registry { equipment-id: equipment-id })) ERR_EQUIPMENT_EXISTS)

    (map-set equipment-registry
      { equipment-id: equipment-id }
      {
        owner: tx-sender,
        equipment-type: equipment-type,
        hash-rate: hash-rate,
        power-consumption: power-consumption,
        location: location,
        verified: false,
        registration-block: block-height
      }
    )
    (var-set equipment-counter equipment-id)
    (ok equipment-id)
  )
)

;; Verify owner
(define-public (verify-owner (owner principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (map-set verified-owners
      { owner: owner }
      { verified: true, verification-block: block-height }
    )
    (ok true)
  )
)

;; Verify equipment
(define-public (verify-equipment (equipment-id uint))
  (let ((equipment (unwrap! (map-get? equipment-registry { equipment-id: equipment-id }) ERR_EQUIPMENT_NOT_FOUND)))
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (map-set equipment-registry
      { equipment-id: equipment-id }
      (merge equipment { verified: true })
    )
    (ok true)
  )
)

;; Check if owner is verified
(define-read-only (is-verified-owner (owner principal))
  (default-to false (get verified (map-get? verified-owners { owner: owner })))
)

;; Get equipment details
(define-read-only (get-equipment (equipment-id uint))
  (map-get? equipment-registry { equipment-id: equipment-id })
)

;; Get equipment counter
(define-read-only (get-equipment-counter)
  (var-get equipment-counter)
)
