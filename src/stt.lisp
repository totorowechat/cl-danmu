(defpackage danmu/stt
  (:use :cl :cl-ppcre)
  (:import-from
   :cl-arrows
   :->>)
  (:import-from
   :danmu/utils
   :mkstr)
  (:export :serialize :deserialize))

(in-package :danmu/stt)

(defun join (separator list)
  (with-output-to-string (out)
    (loop for (element . more) on list do (princ element out)
             when more
               do (princ separator out))))


;; (join "@=:" '("This" "is" "it"))

(defun serialize (l)
  (mkstr
   (->>
    l
    (map 'list #'(lambda (x) (funcall #'join "@=" x)))
    (join #\/))
   "/"))

(defun deserialize (s)
  "s -> input string "
  (map 'list (lambda (i) (ppcre:split "@=" i)) (ppcre:split "/" s)))

;; (defparameter *s* "type@=uenter/rid@=52004/uid@=31458494/nn@=永远是你的小肥/level@=36/ic@=avatar@Sface@S201603@Sc2345212737bc8bcca35e582ba06ad06/nl@=7/rni@=0/el@=eid@AA=1500000113@ASetp@AA=1@ASsc@AA=1@ASef@AA=0@AS@S/sahf@=0/wgei@=0/cbid@=194235/fl@=17/")
;; (ppcre:split "/" *s*)
;; (ppcre:split "@=" "type@=uenter")
;; (map 'list (lambda (i) (ppcre:split "@=" i)) (ppcre:split "/" *s*))

;; (serialize (map 'list (lambda (i) (ppcre:split "@=" i)) (ppcre:split "/" *s*)))
;; (char "三扽撒扽" 1)

;; (string-trim "type" *s*)
;; (deserialize *s*)
;; (serialize '(("type" "loginreq")( "roomid" "52004")))
