(defpackage danmu/web-socket
  (:use
   :cl
   :trivial-utf-8
   :websocket-driver-client
   :cl-intbytes
   :bt-semaphore)
  (:import-from
   :danmu/stt
   :serialize
   :deserialize)
  (:import-from
   :danmu/utils
   :mkstr)
  (:export
   :ws-client
   :new))
(in-package :danmu/web-socket)

(defclass ws-client ()
  ((client :initarg :client
	   :initform (wsd:make-client "wss://danmuproxy.douyu.com:8506")
	   :accessor client)
   (roomid :initarg :roomid
	   :initform "52004"
	   :accessor roomid)))


(defun read-bytes-len (bytes start)
  (if (equalp (subseq bytes start (+ 4 start))
	      (subseq bytes (+ 4 start)  (+ 8 start)))
     (intbytes:octets->int32  (subseq bytes start (+ 4 start)))
     nil))

(defun read-msg (bytes start length)
  (trivial-utf-8:utf-8-bytes-to-string bytes :start start :end (- (+ start length) 9)))

;; (defun read-dy-bytes (bytes)
;;   (if (= 0 (length bytes))
;;       nil
;;       (progn
;; 	(analysis-msg  (read-msg bytes 12 (read-bytes-len bytes 0)))
;; 	(read-dy-bytes (subseq bytes (+ 4 (read-bytes-len bytes 0)))))))

(defun read-dy-bytes (bytes)
  (labels ((helper (bytes lst)
	     (let ((r-bytes-length (read-bytes-len bytes 0)))
	       (if (= 0 (length bytes))
		   lst
		   (progn
		     ;; here print the msg
		     (analysis-msg  (read-msg bytes 12 r-bytes-length))
		     (when (<= (+ 4 r-bytes-length)
			       (length bytes))
		       (helper (subseq bytes (+ 4 r-bytes-length) (length bytes))
			       (list lst (read-msg bytes 12 r-bytes-length)))))))))
    (helper bytes '())))

;; (defmethod new ((wsc ws-client))
;;   (wsd:start-connection (client wsc))
;;   (wsd:on :message (client wsc)
;; 	  (lambda (message)
;; 	    (read-dy-bytes message)))
;;   (wsd:send-binary (client wsc)
;; 		   (let ((a (concatenate 'list #(38 0 0 0 38 0 0 0 177 2 0 0) (trivial-utf-8:string-to-utf-8-bytes "type@=loginreq/roomid@=52004/") #(0) #(47 0 0 0 47 0 0 0 177 2 0 0) (trivial-utf-8:string-to-utf-8-bytes "type@=joingroup/rid@=52004/gid@=-9999/") #(0))))
;; 		   (make-array (length a)
;; 			       :element-type '(unsigned-byte 8)
;; 			       :initial-contents a))))



(defun dy-encode (msg)
  (let* ((msg (trivial-utf-8:string-to-utf-8-bytes msg))
	 (a  (concatenate 'vector
			 (intbytes:int32->octets (+ (length msg) 9))
			 (intbytes:int32->octets (+ (length msg) 9))
			 #(177 2 0 0)
			 msg
			 #(0))))
    (make-array (length a)
		:element-type '(unsigned-byte 8)
		:initial-contents a)))
			 
;; (dy-encode (serialize '(("type" "loginreq")( "roomid" "52004"))))

;; (dy-encode
;;  (serialize '(("type" "loginreq")
;; 	      ("roomid" (roomid (make-instance 'ws-client))))))

;; (trivial-utf-8:string-to-utf-8-bytes
;;  (serialize (list (list "type" "loginreq")
;; 	     (list "roomid" (roomid (make-instance 'ws-client))))))


;; todo Refactor three functions below.

(defun dy-login (wsc)
  (wsd:send-binary (client wsc)
		   (dy-encode
		    (serialize (list (list "type" "loginreq")
				     (list "roomid" (roomid wsc)))))))

(defun dy-join-group (wsc)
  (wsd:send-binary (client wsc)
		   (dy-encode
		    (serialize (list (list "type" "joingroup")
				     (list "rid" (roomid wsc))
				     (list "gid" "-9999"))))))
			      
(defmethod send-heartbeat((wsc ws-client))
  (wsd:send-binary (client wsc)
		   (dy-encode
		    (serialize (list (list "type" "mrkl"))))))

(defun dy-heartbeat (wsc)
  "this function will never stop, so be careful when create multiple ws-client!"
  (bt:make-thread (lambda ()
		    (progn
		      (loop
			(sleep 45)
			(send-heartbeat wsc))))
		  :name "dy-heartbeat"))

;; (defun msg-chatmsg (message)
;;   (mapcar (lambda (x) (cadr x))
;; 	  (remove-if-not (lambda (x)
;; 			   (or (string= "txt" (car x))
;; 			       (string= "nn" (car x))
;; 			       (string= "level" (car x))))
;; 			 (deserialize message))))

(defun msg-chatmsg (message)
  (let ((name nil)
	(level nil)
	(txt nil))
    (mapc (lambda (x)
	    (cond ((string= "txt" (car x))
		   (progn
		     (setf txt (cadr x))
		     t))
		  ((string= "nn" (car x))
		   (progn
		     (setf name (cadr x))
		     t))
		  ((string= "level" (car x))
		   (progn
		     (setf level (cadr x))
		     t))
		  (t nil)))
	  (deserialize message))
    (list txt name level)))

(defun analysis-msg (message)
  (let ((msg-type (cadar (deserialize message))))
    (cond ((string= "chatmsg" msg-type) (print (msg-chatmsg message)))
	  )))
	  
(defmethod new ((wsc ws-client))
  (wsd:start-connection (client wsc) :verify nil)
  ;; (wsd:on :message (client wsc)
  ;; 	  (lambda (message)
  ;; 	    (read-dy-bytes message)))
  (wsd:on :message (client wsc)
	  (lambda (message)
	    (read-dy-bytes message)))
  (dy-login wsc)
  (dy-join-group wsc)
  (dy-heartbeat wsc))


;; (intbytes:int32->octets 57)
;; (new (make-instance 'ws-client))
;; (dy-heartbeat (make-instance 'ws-client))


