(defpackage danmu/web-socket
  (:use
   :cl
   :trivial-utf-8
   :websocket-driver-client
   :cl-intbytes)
  (:export
   :ws-client
   :new))
(in-package :danmu/web-socket)

(defclass ws-client ()
  ((client :initarg :client
	   :initform (wsd:make-client "wss://danmuproxy.douyu.com:8506")
	   :accessor client)
   (roomid :initarg :roomid
	   :initform 52004
	   :accessor roomid)))

(defun read-dy-bytes (bytes)
  (if (= 0 (length bytes))
      nil
      (progn
	(print (read-msg bytes 12 (read-bytes-len bytes 0)))
	(read-dy-bytes (subseq bytes (+ 4 (read-bytes-len bytes 0)))))))

(defun read-bytes-len (bytes start)
  (if (equalp (subseq bytes start (+ 4 start))
	      (subseq bytes (+ 4 start)  (+ 8 start)))
     (intbytes:octets->int32  (subseq bytes start (+ 4 start)))
     nil))

(defun read-msg (bytes start length)
  (trivial-utf-8:utf-8-bytes-to-string bytes :start start :end (- (+ start length) 9)))

(defmethod new ((wsc ws-client))
  (wsd:start-connection (client wsc))
  (wsd:on :message (client wsc)
	  (lambda (message)
	    (read-dy-bytes message)))
  (wsd:send-binary (client wsc)
		   (let ((a (concatenate 'list #(38 0 0 0 38 0 0 0 177 2 0 0) (trivial-utf-8:string-to-utf-8-bytes "type@=loginreq/roomid@=52004/") #(0) #(47 0 0 0 47 0 0 0 177 2 0 0) (trivial-utf-8:string-to-utf-8-bytes "type@=joingroup/rid@=52004/gid@=-9999/") #(0))))
		   (make-array (length a)
			       :element-type '(unsigned-byte 8)
			       :initial-contents a))))

;; (new (make-instance 'ws-client))
