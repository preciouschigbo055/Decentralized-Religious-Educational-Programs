;; Community Integration Contract
;; Integrates education with community service

(define-constant ERR_UNAUTHORIZED (err u500))
(define-constant ERR_PROJECT_NOT_FOUND (err u501))
(define-constant ERR_INVALID_HOURS (err u502))
(define-constant ERR_STUDENT_NOT_ENROLLED (err u503))

(define-map community-projects
  { project-id: uint }
  {
    title: (string-ascii 100),
    description: (string-ascii 500),
    institution-id: uint,
    coordinator: principal,
    required-hours: uint,
    start-date: uint,
    end-date: uint,
    is-active: bool,
    max-participants: uint,
    current-participants: uint
  }
)

(define-map student-service-hours
  { student: principal, project-id: uint }
  {
    enrolled-at: uint,
    hours-completed: uint,
    hours-verified: uint,
    completion-status: uint, ;; 0=active, 1=completed, 2=dropped
    supervisor: principal
  }
)

(define-map service-logs
  { student: principal, log-id: uint }
  {
    project-id: uint,
    date: uint,
    hours: uint,
    activity-description: (string-ascii 300),
    verified-by: principal,
    verified: bool
  }
)

(define-data-var next-project-id uint u1)
(define-data-var next-log-id uint u1)

;; Reference to student progress contract
(define-constant STUDENT_CONTRACT .student-progress)

;; Create community service project
(define-public (create-project
  (title (string-ascii 100))
  (description (string-ascii 500))
  (institution-id uint)
  (required-hours uint)
  (start-date uint)
  (end-date uint)
  (max-participants uint))
  (let ((project-id (var-get next-project-id)))
    (map-set community-projects
      { project-id: project-id }
      {
        title: title,
        description: description,
        institution-id: institution-id,
        coordinator: tx-sender,
        required-hours: required-hours,
        start-date: start-date,
        end-date: end-date,
        is-active: true,
        max-participants: max-participants,
        current-participants: u0
      }
    )
    (var-set next-project-id (+ project-id u1))
    (ok project-id)
  )
)

;; Enroll student in community service project
(define-public (enroll-in-project (student principal) (project-id uint))
  (match (map-get? community-projects { project-id: project-id })
    project
    (begin
      (asserts! (get is-active project) ERR_PROJECT_NOT_FOUND)
      (asserts! (< (get current-participants project) (get max-participants project)) ERR_UNAUTHORIZED)

      (map-set student-service-hours
        { student: student, project-id: project-id }
        {
          enrolled-at: block-height,
          hours-completed: u0,
          hours-verified: u0,
          completion-status: u0,
          supervisor: tx-sender
        }
      )

      ;; Update participant count
      (map-set community-projects
        { project-id: project-id }
        (merge project { current-participants: (+ (get current-participants project) u1) })
      )
      (ok true)
    )
    ERR_PROJECT_NOT_FOUND
  )
)

;; Log service hours
(define-public (log-service-hours
  (student principal)
  (project-id uint)
  (hours uint)
  (activity-description (string-ascii 300)))
  (let ((log-id (var-get next-log-id)))
    (asserts! (> hours u0) ERR_INVALID_HOURS)
    (asserts! (is-some (map-get? student-service-hours { student: student, project-id: project-id })) ERR_STUDENT_NOT_ENROLLED)

    (map-set service-logs
      { student: student, log-id: log-id }
      {
        project-id: project-id,
        date: block-height,
        hours: hours,
        activity-description: activity-description,
        verified-by: tx-sender,
        verified: false
      }
    )
    (var-set next-log-id (+ log-id u1))
    (ok log-id)
  )
)

;; Verify service hours
(define-public (verify-service-hours (student principal) (log-id uint))
  (match (map-get? service-logs { student: student, log-id: log-id })
    log-entry
    (begin
      (map-set service-logs
        { student: student, log-id: log-id }
        (merge log-entry { verified: true, verified-by: tx-sender })
      )

      ;; Update student's verified hours
      (match (map-get? student-service-hours { student: student, project-id: (get project-id log-entry) })
        service-record
        (map-set student-service-hours
          { student: student, project-id: (get project-id log-entry) }
          (merge service-record {
            hours-verified: (+ (get hours-verified service-record) (get hours log-entry))
          })
        )
        false
      )
      (ok true)
    )
    ERR_PROJECT_NOT_FOUND
  )
)

;; Get community project
(define-read-only (get-community-project (project-id uint))
  (map-get? community-projects { project-id: project-id })
)

;; Get student service hours
(define-read-only (get-student-service-hours (student principal) (project-id uint))
  (map-get? student-service-hours { student: student, project-id: project-id })
)

;; Get service log
(define-read-only (get-service-log (student principal) (log-id uint))
  (map-get? service-logs { student: student, log-id: log-id })
)
