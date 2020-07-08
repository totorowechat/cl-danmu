
'(:type "chatmsg"
  :nn "河马"
  :id "avatar_v3/201912/b99d77251eb643b5a88bb81863afea4e"
  :cst "1592152272402"
  :brid "0"
  :lk ""
  :list #((:lev "1"
	   :num "2")
	  (:lev "1"
		:num "3")))
(ql:quickload "trivial-utf-8")
(ql:quickload :websocket-driver-client)
(ql:quickload :array-operations)

(defvar *client* (wsd:make-client "wss://danmuproxy.douyu.com:8506"))

(wsd:start-connection *client*)

;; (wsd:on :message *client*
;;         (lambda (message)
;;           (format t "~&Got: ~A~%" (trivial-utf-8:utf-8-bytes-to-string  (aops:subvec message 12)))))

(defun read-dy-bytes (bytes)

(wsd:on :message *client*
        (lambda (message)
          (format t "~&Got: ~A~%" message)))


(wsd:send-binary *client* 
		 (let ((a (concatenate 'list #(38 0 0 0 38 0 0 0 177 2 0 0) (trivial-utf-8:string-to-utf-8-bytes "type@=loginreq/roomid@=52004/") #(0) #(47 0 0 0 47 0 0 0 177 2 0 0) (trivial-utf-8:string-to-utf-8-bytes "type@=joingroup/rid@=52004/gid@=-9999/") #(0))))
		   (make-array (length a)
			       :element-type '(unsigned-byte 8)
			       :initial-contents a)))

;; read four bytes
(defun read-bytes->array (
(do* ((b (read-byte *s*) (read-byte *s*))
      (l '() (append l (list b)))
      (step 0 (1+ step)))
     ((= step 4) (concatenate 'vector (nreverse l))))

;; convert byte array to int

(intbytes:octets->int32 v)

;; read n bytes

(defun read-bytes->list (n s)
  (do* ((b (read-byte s) (read-byte s))
	(l '() (append l (list b)))
	(step 0 (1+ step)))
       ((= step n) (nreverse l))))

;; https://quickref.common-lisp.net/cl-intbytes.html

(intbytes:octets->int32 (read-n-bytes 4 (flexi-streams:make-in-memory-input-stream #(123 0 0 0 123 0 0 0))))

;; http://edicl.github.io/flexi-streams/#make-in-memory-input-stream
(read-n-bytes 4 (flexi-streams:make-in-memory-input-stream '(123 0 0 0 123 0 0 0)))

