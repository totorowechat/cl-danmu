(defpackage danmu/web-socket
  (:use
   :cl
   :trivial-utf-8
   :websocket-driver-client
   :cl-intbytes
   :bt-semaphore)
  (:import-from
   :danmu/stt
   :serialize)
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

(defun read-dy-bytes (bytes)
  (if (= 0 (length bytes))
      nil
      (progn
	(print (read-msg bytes 12 (read-bytes-len bytes 0)))
	(read-dy-bytes (subseq bytes (+ 4 (read-bytes-len bytes 0)))))))

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
  (bt:make-thread (lambda ()
		    (progn
		      (loop
			(sleep 45)
			(send-heartbeat wsc)))) nil))
		  :name "dy-heartbeat"))

(defmethod new ((wsc ws-client))
  (wsd:start-connection (client wsc))
  (wsd:on :message (client wsc)
	  (lambda (message)
	    (read-dy-bytes message)))
  (dy-login wsc)
  (dy-join-group wsc)
  (dy-heartbeat wsc))

;; (intbytes:int32->octets 57)
;; (new (make-instance 'ws-client))
;; (dy-heartbeat (make-instance 'ws-client))


