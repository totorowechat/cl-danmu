(defpackage danmu/utils
  (:use :cl)
  (:export :mkstr :md5 :group))

(in-package :danmu/utils)

(defun mkstr (&rest args)
  (with-output-to-string (s)
			 (dolist (a args) (princ a s))))

(defun md5 (str)
  (ironclad:byte-array-to-hex-string
    (ironclad:digest-sequence :md5 
                              (ironclad:ascii-string-to-byte-array str))))

(defun group (source n)
  (if (zerop n) (error "zero length"))
  (labels ((rec (source acc)
	     (let ((rest (nthcdr n source)))
	       (if (consp rest)
		   (rec rest (cons (subseq source 0 n) acc))
		   (nreverse (cons source acc))))))
    (if source (rec source nil) nil)))

;;;;;;;;;;;;;;;;;;;;
;;
;; little byte to int




