;;; artdb.scm -- A web-based tool for cataloging visual art collections.
;;;
;;;   Copyright © 2013 by Matthew C. Gushee <matt@gushee.net>
;;;   This program is open-source software, released under the
;;;   BSD license. See the accompanying LICENSE file for details.

(use (prefix sql-de-lite sd:))
(use (prefix autoschema as:))
(use (prefix htmlform hf:))
(use (prefix json js:))
(use (prefix fastcgi fc:))


;;; IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
;;; --  DATABASE MAINTENANCE  ----------------------------------------------

(define (setup-db filename #!optional (force #f))
  (when (file-exists? filename)
    (if force
      (delete-file filename)
      (web-error "Database already exists."))
  (let ((conn (open-database filename)))
    (as:setup-db
      conn
      '((default-type: text)
        (artists
          ((first-name required: #t)
           (middle-name)
           (last-name required: #t)
           (email)
           (phone)
           (statement)))
        (artist-photos
          ((artist type: (ref (artists id)) required: #t)
           (file required: #t)
           (primary type: boolean default: #f)))
        (works
          ((catalog-id required: #t)
           (title default: "Untitled")
           (description)
           (price type: float)
           (active type: boolean default: #f)
           (location)))
        (works_x_artists
          ((work type: (ref (works id)) required: #t)
           (artist type: (ref (artists id)) required: #t)))
        (work-photos
          ((work type: (ref (works id)) required: #t)
           (file required: #t)
           (primary type: boolean default: #f))))))))


;;; OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO



;;; IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
;;; --  WEB INTERFACE  ----------------------------------------------------- 

(define (report-error message)
  #f)

;;; OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO


;;; IIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIIII
;;; ------------------------------------------------------------------------

;;; OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO

;;; ========================================================================
;;; ------------------------------------------------------------------------

; vim:et:ai:ts=2 sw=2
