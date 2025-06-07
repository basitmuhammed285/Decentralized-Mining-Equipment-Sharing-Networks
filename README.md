# Decentralized Mining Equipment Sharing Network

A blockchain-based platform for sharing mining equipment, coordinating maintenance, and optimizing costs among cryptocurrency miners.

## Overview

This system enables miners to:
- Share expensive mining equipment to reduce individual costs
- Coordinate maintenance schedules efficiently
- Optimize equipment utilization across the network
- Distribute operational costs fairly among participants

## Smart Contracts

### 1. Equipment Registry (`equipment-registry.clar`)
- **Purpose**: Validates and manages mining equipment owners
- **Key Features**:
    - Equipment registration and verification
    - Owner verification system
    - Equipment metadata storage (hash rate, power consumption, location)

### 2. Equipment Rental (`equipment-rental.clar`)
- **Purpose**: Manages mining equipment rental agreements
- **Key Features**:
    - Rental agreement creation and management
    - Equipment availability tracking
    - Rate-per-block pricing model

### 3. Maintenance Coordinator (`maintenance-coordinator.clar`)
- **Purpose**: Coordinates equipment maintenance scheduling
- **Key Features**:
    - Maintenance request creation
    - Technician assignment
    - Maintenance history tracking

### 4. Utilization Optimizer (`utilization-optimizer.clar`)
- **Purpose**: Optimizes equipment utilization across the network
- **Key Features**:
    - Runtime and downtime tracking
    - Efficiency score calculation
    - Network-wide statistics
    - Optimization recommendations

### 5. Cost Sharing (`cost-sharing.clar`)
- **Purpose**: Manages cost sharing among network participants
- **Key Features**:
    - Cost sharing pool creation
    - Member contribution tracking
    - Proportional cost distribution

## Getting Started

### Prerequisites
- Clarity development environment
- Stacks blockchain testnet access

### Installation

1. Clone the repository
2. Deploy contracts to Stacks testnet
3. Verify contract deployment

### Usage Examples

#### Register Equipment
\`\`\`clarity
(contract-call? .equipment-registry register-equipment "ASIC Miner S19" u95000000 u3250 "Mining Farm A")
\`\`\`

#### Create Rental Agreement
\`\`\`clarity
(contract-call? .equipment-rental create-rental u1 u1000)
\`\`\`

#### Schedule Maintenance
\`\`\`clarity
(contract-call? .maintenance-coordinator create-maintenance-request u1 "Routine Cleaning" u3 u500 u1500)
\`\`\`

#### Join Cost Sharing Pool
\`\`\`clarity
(contract-call? .cost-sharing join-pool u1 u10000)
\`\`\`

## Contract Architecture

\`\`\`
┌─────────────────────┐    ┌─────────────────────┐
│ Equipment Registry  │────│ Equipment Rental    │
└─────────────────────┘    └─────────────────────┘
│                          │
│                          │
┌─────────────────────┐    ┌─────────────────────┐
│ Maintenance Coord.  │    │ Utilization Optim.  │
└─────────────────────┘    └─────────────────────┘
│                          │
└──────────┬─────────────────┘
│
┌─────────────────────┐
│   Cost Sharing      │
└─────────────────────┘
\`\`\`

## Key Benefits

1. **Cost Reduction**: Share expensive mining equipment costs
2. **Efficiency**: Optimize equipment utilization across the network
3. **Maintenance**: Coordinate maintenance to minimize downtime
4. **Transparency**: All transactions recorded on blockchain
5. **Fairness**: Proportional cost sharing based on usage

## Security Features

- Owner verification for equipment registration
- Authorization checks for all operations
- Immutable maintenance and utilization records
- Transparent cost distribution mechanisms

## Future Enhancements

- Integration with IoT sensors for real-time monitoring
- Advanced optimization algorithms
- Cross-chain compatibility
- Mobile application interface
- Automated maintenance scheduling

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For support and questions, please open an issue in the GitHub repository.

