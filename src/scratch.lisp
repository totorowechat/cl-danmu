
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

(defvar *b* #(120 1 0 0 120 1 0 0 178 2 0 0 116 121 112 101 64 61 99 104 97 116 109 115 103 47 114 105 100 64 61 53 50 48 48 52 47 99 116 64 61 49 52 47 117 105 100 64 61 54 51 53 48 56 53 55 50 47 110 110 64 61 229 134 155 229 184 136 230 133 162 229 141 138 230 139 141 47 116 120 116 64 61 229 143 175 228 187 165 230 144 158 230 179 162 231 171 158 231 140 156 239 188 140 229 164 154 229 176 145 229 184 129 233 128 154 229 133 179 47 99 105 100 64 61 101 55 102 99 55 97 102 98 49 101 57 101 52 53 101 100 97 50 54 55 55 54 48 50 48 48 48 48 48 48 48 48 47 105 99 64 61 97 118 97 116 97 114 64 83 102 97 99 101 64 83 50 48 49 54 48 56 64 83 49 49 64 83 48 49 56 100 98 54 54 49 100 99 100 97 57 49 50 48 51 57 56 97 53 101 57 101 55 49 101 98 48 57 50 102 47 108 101 118 101 108 64 61 50 52 47 115 97 104 102 64 61 48 47 99 115 116 64 61 49 53 57 56 49 57 54 49 54 49 55 56 52 47 98 110 110 64 61 47 98 108 64 61 48 47 98 114 105 100 64 61 48 47 104 99 64 61 47 101 108 64 61 101 105 100 64 65 65 61 49 53 48 48 48 48 48 49 49 51 64 65 83 101 116 112 64 65 65 61 49 64 65 83 115 99 64 65 65 61 49 64 65 83 101 102 64 65 65 61 48 64 65 83 64 83 47 108 107 64 61 47 117 114 108 101 118 64 61 49 54 47 100 109 115 64 61 53 47 112 100 103 64 61 53 52 47 112 100 107 64 61 56 53 47 0))

(defun read-dy-bytes (bytes)
  (if (= 0 (length bytes))
      nil
      (progn
	(print (read-msg bytes 12 (read-bytes-len bytes 0)))
	(read-dy-bytes (subseq bytes (+ 4 (read-bytes-len bytes 0)))))))

(read-dy-bytes *b*)

(defun read-bytes-len (bytes start)
  (if (equalp (subseq bytes start (+ 4 start))
	      (subseq bytes (+ 4 start)  (+ 8 start)))
     (intbytes:octets->int32  (subseq bytes start (+ 4 start)))
     nil))

(defun read-msg (bytes start length)
  (trivial-utf-8:utf-8-bytes-to-string bytes :start start :end (- (+ start length) 9)))

(read-msg *b* 12 (read-bytes-len *b* 0))

(read-msg *b* 12 376)
(read-bytes-len #(5 5 5 5 5 5 5 5 5 5 5 5 ) 0)

(wsd:on :message *client*
        (lambda (message)
          (format t "~&Got: ~A~%" message)))


(wsd:send-binary *client* 
		 (let ((a (concatenate 'list #(38 0 0 0 38 0 0 0 177 2 0 0) (trivial-utf-8:string-to-utf-8-bytes "type@=loginreq/roomid@=52004/") #(0) #(47 0 0 0 47 0 0 0 177 2 0 0) (trivial-utf-8:string-to-utf-8-bytes "type@=joingroup/rid@=52004/gid@=-9999/") #(0))))
		   (make-array (length a)
			       :element-type '(unsigned-byte 8)
			       :initial-contents a)))

;; read four bytes
(defun read-bytes->array ())
(do* ((b (read-byte *s*) (read-byte *s*))
      (l '() (append l (list b)))
      (step 0 (1+ step)))
     ((= step 4) (concatenate 'vector (nreverse l))))

;; convert byte array to int

(intbytes:octets->int32 #(47 0 0 0))

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

(progn
  (ql:quickload "trivial-utf-8")
  (ql:quickload :websocket-driver-client)
  (ql:quickload :array-operations))

  (defvar *client* (wsd:make-client "wss://danmuproxy.douyu.com:8506"))
  (wsd:start-connection *client*)
  (wsd:on :message *client*
	  (lambda (message)
	    (format t "~&Got: ~A~%" message)))
(progn
  (wsd:send-binary *client* 
		   (let ((a (concatenate 'list #(38 0 0 0 38 0 0 0 177 2 0 0) (trivial-utf-8:string-to-utf-8-bytes "type@=loginreq/roomid@=52004/") #(0) #(47 0 0 0 47 0 0 0 177 2 0 0) (trivial-utf-8:string-to-utf-8-bytes "type@=joingroup/rid@=52004/gid@=-9999/") #(0))))
		     (make-array (length a)
				 :element-type '(unsigned-byte 8)
				 :initial-contents a))))


;; #(249 0 0 0 249 0 0 0 178 2 0 0 116 121 112 101 64 61 117 101 110 116 101 114 47 114 105 100 64 61 53 50 48 48 52 47 117 105 100 64 61 51 49 52 53 56 52 57 52 47 110 110 64 61 230 176 184 232 191 156 230 152 175 228 189 160 231 154 132 229 176 143 232 130 165 47 108 101 118 101 108 64 61 51 54 47 105 99 64 61 97 118 97 116 97 114 64 83 102 97 99 101 64 83 50 48 49 54 48 51 64 83 99 50 51 52 53 50 49 50 55 51 55 98 99 56 98 99 99 97 51 53 101 53 56 50 98 97 48 54 97 100 48 54 47 110 108 64 61 55 47 114 110 105 64 61 48 47 101 108 64 61 101 105 100 64 65 65 61 49 53 48 48 48 48 48 49 49 51 64 65 83 101 116 112 64 65 65 61 49 64 65 83 115 99 64 65 65 61 49 64 65 83 101 102 64 65 65 61 48 64 65 83 64 83 47 115 97 104 102 64 61 48 47 119 103 101 105 64 61 48 47 99 98 105 100 64 61 49 57 52 50 51 53 47 102 108 64 61 49 55 47 0)
