# Decentralized Religious Educational Programs

A comprehensive blockchain-based system for managing religious educational institutions, curricula, student progress, teacher certifications, and community service integration using Clarity smart contracts on the Stacks blockchain.

## Overview

This system provides a decentralized platform for religious educational institutions to:

- Verify and validate educational institutions
- Manage religious education curricula
- Track student progress and achievements
- Certify religious education teachers
- Integrate education with community service programs

## Smart Contracts

### 1. Institution Verification Contract (\`institution-verification.clar\`)

Manages the verification and validation of religious educational institutions.

**Key Features:**
- Register new institutions with religious affiliation details
- Verify institutions through authorized personnel
- Track institution status (pending, verified, suspended, revoked)
- Store institution contact information and addresses

**Main Functions:**
- \`register-institution\`: Register a new educational institution
- \`verify-institution\`: Verify an institution (owner only)
- \`get-institution\`: Retrieve institution details
- \`is-institution-verified\`: Check verification status

### 2. Curriculum Management Contract (\`curriculum-management.clar\`)

Handles the creation and management of religious education curricula.

**Key Features:**
- Create curricula for verified institutions only
- Manage curriculum metadata (title, description, grade level, duration)
- Toggle curriculum active/inactive status
- Track curriculum creators and creation dates

**Main Functions:**
- \`create-curriculum\`: Create new curriculum for verified institutions
- \`get-curriculum\`: Retrieve curriculum details
- \`toggle-curriculum-status\`: Activate/deactivate curriculum
- \`is-curriculum-active\`: Check if curriculum is active

### 3. Student Progress Contract (\`student-progress.clar\`)

Tracks student enrollment, progress, and achievements in religious education programs.

**Key Features:**
- Enroll students in active curricula
- Track student progress and completion status
- Award achievements and certificates
- Manage final grades and course completion

**Main Functions:**
- \`enroll-student\`: Enroll student in curriculum
- \`update-progress\`: Update student progress (0-100%)
- \`complete-course\`: Mark course as completed with final grade
- \`award-achievement\`: Award achievements to students
- \`get-student-enrollment\`: Retrieve enrollment details

### 4. Teacher Certification Contract (\`teacher-certification.clar\`)

Manages teacher certifications and qualifications for religious education.

**Key Features:**
- Issue teacher certifications with expiration dates
- Track teacher specializations and certification levels
- Manage teacher qualifications and credentials
- Renew certifications for active teachers

**Main Functions:**
- \`issue-certification\`: Issue new teacher certification
- \`renew-certification\`: Renew existing certification
- \`add-qualification\`: Add teacher qualifications
- \`get-teacher-certification\`: Retrieve certification details
- \`is-teacher-certified\`: Check if teacher is currently certified

### 5. Community Integration Contract (\`community-integration.clar\`)

Integrates religious education with community service programs.

**Key Features:**
- Create community service projects
- Enroll students in service projects
- Log and verify community service hours
- Track project participation and completion

**Main Functions:**
- \`create-project\`: Create new community service project
- \`enroll-in-project\`: Enroll student in service project
- \`log-service-hours\`: Log student service hours
- \`verify-service-hours\`: Verify logged service hours
- \`get-community-project\`: Retrieve project details

## Installation and Setup

### Prerequisites

- Stacks blockchain development environment
- Clarity CLI tools
- Node.js and npm for testing

### Deployment

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd religious-education-contracts
   \`\`\`

2. Deploy contracts to Stacks blockchain:
   \`\`\`bash
   clarinet deploy --network testnet
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

## Usage Examples

### Registering an Institution

\`\`\`clarity
(contract-call? .institution-verification register-institution
"Sacred Heart Seminary"
"123 Faith Street, Religious City"
"admin@sacredheart.edu"
"Catholic")
\`\`\`

### Creating a Curriculum

\`\`\`clarity
(contract-call? .curriculum-management create-curriculum
"Introduction to Biblical Studies"
"A comprehensive course covering biblical interpretation"
u1  ;; institution-id
"Biblical Studies"
u9  ;; grade-level
u16) ;; duration-weeks
\`\`\`

### Enrolling a Student

\`\`\`clarity
(contract-call? .student-progress enroll-student
'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG  ;; student principal
u1) ;; curriculum-id
\`\`\`

## Testing

The project includes comprehensive test suites for all contracts using Vitest:

- \`tests/institution-verification.test.js\`
- \`tests/curriculum-management.test.js\`
- \`tests/student-progress.test.js\`
- \`tests/teacher-certification.test.js\`
- \`tests/community-integration.test.js\`

Run tests with:
\`\`\`bash
npm test
\`\`\`

## Contract Interactions

The contracts are designed to work together:

1. **Institution Verification** → **Curriculum Management**: Only verified institutions can create curricula
2. **Curriculum Management** → **Student Progress**: Students can only enroll in active curricula
3. **Institution Verification** → **Teacher Certification**: Teachers can only be certified by verified institutions
4. **Student Progress** → **Community Integration**: Students can participate in community service projects

## Security Features

- **Access Control**: Functions restricted to appropriate roles (owners, instructors, coordinators)
- **Validation**: Input validation for all parameters
- **Status Checks**: Verification of institution and curriculum status before operations
- **Expiration Management**: Automatic handling of certification expiration dates

## Error Handling

Each contract includes comprehensive error handling with specific error codes:

- Institution Verification: ERR_UNAUTHORIZED (100), ERR_INSTITUTION_EXISTS (101), etc.
- Curriculum Management: ERR_CURRICULUM_NOT_FOUND (202), ERR_INSTITUTION_NOT_VERIFIED (203), etc.
- Student Progress: ERR_ENROLLMENT_NOT_FOUND (302), ERR_INVALID_GRADE (303), etc.
- Teacher Certification: ERR_CERTIFICATION_EXPIRED (403), etc.
- Community Integration: ERR_INVALID_HOURS (502), ERR_STUDENT_NOT_ENROLLED (503), etc.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For questions or support, please open an issue in the GitHub repository or contact the development team.
