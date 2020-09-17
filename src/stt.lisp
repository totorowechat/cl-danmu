(defpackage danmu/stt
  (:use :cl :cl-ppcre)
  (:import-from
   :cl-arrows
   :->>)
  (:import-from
   :danmu/utils
   :mkstr)
  (:export
   :serialize
   :deserialize))

(in-package :danmu/stt)

(defun join (separator list)
  (with-output-to-string (out)
    (loop for (element . more) on list do (princ element out)
             when more
               do (princ separator out))))

;; (join "@=:" '("This"))

(defun serialize (l)
  (mkstr
   (->>
    l
    (map 'list #'(lambda (x) (funcall #'join "@=" x)))
    (join #\/))
   "/"))

(defun deserialize (s)
  "s -> input string "
  (map 'list (lambda (i)
	       ;; if i = "el@=" then append "" to '("el") 
	       (if (cdr (ppcre:split "@=" i))
		   (ppcre:split "@=" i)
		   (append (ppcre:split "@=" i) '("")))) (ppcre:split "/" s)))
;; (serialize (deserialize "type@=chatmsg/rid@=48699/ct@=1/uid@=64233236/nn@=梦卡比之誓言/txt@=为主播点了个赞/cid@=ac0fa61ffb65404691a8050000000000/ic@=avanew@Sface@S201701@S28@S22@Saef13ed5e612d8f13e325074955ff85c/level@=12/sahf@=0/cst@=1598260731363/bnn@=Wx/bl@=7/brid@=16101/hc@=82e926ced615da6a1558d884b43c368f/el@=/lk@=/dat@=16/urlev@=1/dms@=3/pdg@=27/pdk@=9/"))
