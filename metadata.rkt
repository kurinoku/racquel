#lang racket
;;;; Racquel - An ORM for Racket
;;;;
;;;; metadata - Data class metadata 
;;;;
;;;; Copyright (c) Scott Brown 2013

(provide data-class-metadata% data-join% *data-class-metadata* 
         get-class-metadata set-class-metadata!
         dynamic-get-class-metadata dynamic-set-class-metadata!
         data-class-info)

;;; Define data class metadata struct.
(define data-class-metadata% 
  (class object% 
    (field [table-name #f] 
           [column-names null] 
           [joins null]
           [primary-key #f] 
           [autoincrement-key #f]
           [external-name #f]
           [class-name #f])
    (super-new)
    (inspect #f)))

;;; Define join object.
(define data-join% (class object% (init-field column-fld foreign-key join-class join-key) (super-new)))

;;; Define a global table holding data class metadata.
(define *data-class-metadata* (make-hash))

(define-syntax-rule (get-class-metadata-object cls)  
  (begin (unless (hash-has-key? *data-class-metadata* cls) 
           (hash-set! *data-class-metadata* cls (new data-class-metadata%)))
         (hash-ref *data-class-metadata* cls)))

;;; Get a data class metadata field.
(define-syntax-rule (get-class-metadata id cls)
  (get-field id (get-class-metadata-object cls)))

;;; Set a data class metadata field.
(define-syntax-rule (set-class-metadata! id cls val)
  (set-field! id (get-class-metadata-object cls) val))

;;; Dynamically get a data class metadata field.
(define-syntax-rule (dynamic-get-class-metadata id cls)
  (dynamic-get-field id (get-class-metadata-object cls)))

;;; Dynamically set a data class metadata field.
(define-syntax-rule (dynamic-set-class-metadata! id cls val)
  (dynamic-set-field! id (get-class-metadata-object cls) val))

;;; Return info about a data class.
(define-syntax-rule (data-class-info cls)
  (let-values ([(cls-nm fld-cnt fld-nms fld-acc fld-mut sup-cls skpd?) (class-info data-class-metadata%)])
    (apply values (map (lambda (f) (dynamic-get-class-metadata f cls)) fld-nms))))