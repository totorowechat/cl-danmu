(defpackage danmu/msg
  (:use :cl)
  (:export
   :get-element))

(in-package :danmu/msg)

(defun get-element (l e &optional fn)
  "l -> list, e -> element, fn -> function"
  (if (null fn)
      (setf fn (lambda (a b) (string= a b))))
  (labels ((rec (item lst found)
	     (if found
		 found
		 (if (null lst)
		     nil
		     (rec (car lst) (cdr lst) (if (funcall fn (car item) e)
						   (cdr item)
						   nil)
			  )))))
    (rec (car l) (cdr l) nil)))
