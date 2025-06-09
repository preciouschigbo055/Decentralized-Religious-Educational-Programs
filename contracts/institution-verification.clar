;; Institution Verification Contract
;; Validates and manages religious educational institutions

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_INSTITUTION_EXISTS (err u101))
(define-constant ERR_INSTITUTION_NOT_FOUND (err u102))
(define-constant ERR_INVALID_STATUS (err u103))

;; Institution status: 0=pending, 1=verified, 2=suspended, 3=revoked
(define-map institutions
  { institution-id: uint }
  {
    name: (string-ascii 100),
    address: (string-ascii 200),
    contact-email: (string-ascii 100),
    religious-affiliation: (string-ascii 50),
    status: uint,
    verified-at: uint,
    verifier: principal
  }
)

(define-data-var next-institution-id uint u1)

;; Register a new institution
(define-public (register-institution
  (name (string-ascii 100))
  (address (string-ascii 200))
  (contact-email (string-ascii 100))
  (religious-affiliation (string-ascii 50)))
  (let ((institution-id (var-get next-institution-id)))
    (asserts! (is-none (map-get? institutions { institution-id: institution-id })) ERR_INSTITUTION_EXISTS)
    (map-set institutions
      { institution-id: institution-id }
      {
        name: name,
        address: address,
        contact-email: contact-email,
        religious-affiliation: religious-affiliation,
        status: u0,
        verified-at: u0,
        verifier: tx-sender
      }
    )
    (var-set next-institution-id (+ institution-id u1))
    (ok institution-id)
  )
)

;; Verify an institution (only contract owner)
(define-public (verify-institution (institution-id uint))
  (begin
    (asserts! (is-eq tx-sender CONTRACT_OWNER) ERR_UNAUTHORIZED)
    (match (map-get? institutions { institution-id: institution-id })
      institution
      (begin
        (map-set institutions
          { institution-id: institution-id }
          (merge institution { status: u1, verified-at: block-height, verifier: tx-sender })
        )
        (ok true)
      )
      ERR_INSTITUTION_NOT_FOUND
    )
  )
)

;; Get institution details
(define-read-only (get-institution (institution-id uint))
  (map-get? institutions { institution-id: institution-id })
)

;; Check if institution is verified
(define-read-only (is-institution-verified (institution-id uint))
  (match (map-get? institutions { institution-id: institution-id })
    institution (is-eq (get status institution) u1)
    false
  )
)
