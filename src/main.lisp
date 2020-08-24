(defpackage danmu
  (:use :cl)
  (:import-from :cl-arrows :->> :-<>>)
  (:import-from :danmu/utils :mkstr)
  (:import-from
   :danmu/web-socket
   :new
   :ws-client)
  (:export
   :main
   :run))
(in-package :danmu)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; get stream url

(defun get-tt ()
  (- (get-universal-time)
     (encode-universal-time 0 0 0 1 1 1970 0)))

(defun get-roomlist (p)
  "p is a pathname"
  (with-open-file (s (pathname p))
    (json:json-bind (douyu)
		    s
      douyu)))

(defun get-dy-json (p)
  (with-open-file (s (pathname p))
    (json:decode-json s)))

(defun get-streamer (rid)
  (cdr (assoc rid
	      (json:json-bind (streamer)
			      (json:encode-json-to-string (get-dy-json "~/Documents/douyu.json"))
		streamer)
	      :test #'(lambda (l r) (string= l (mkstr r))))))

(defun find-streamer (rid p)
  (with-open-file (s (pathname p))
    (json:json-bind (stream)
		    s
      douyu)))
   
(defun get-url (tt md5 rid)
  (let ((request-url (mkstr "https://playweb.douyucdn.cn/lapi/live/hlsH5Preview/" rid))
	(parameters `(("rid" . ,rid)
		      ("did" . "10000000000000000000000000001501")))
	;; (headers `((:rid . ,rid)
	;; 	   (:time . ,tt)
	;; 	   (:auth . ,md5))))
	(headers (pairlis '(:rid :time :auth)
			  `(,rid ,tt ,md5))))
    (drakma:http-request request-url
			 :method :post
			 :parameters parameters
			 :additional-headers headers)))


(defun byte-to-str (b)
  (json:json-bind (data.rtmp--live)
		   (trivial-utf-8:utf-8-bytes-to-string b)
    data.rtmp--live))

(defun build-url (rid)
  (let* ((ct (mkstr (get-tt) "956"))
         (md5 (danmu/utils:md5 (mkstr rid ct))))
    (-<>> (get-url ct md5 rid)
	  (nth-value 0) 
          (byte-to-str)
	  (cl-ppcre:split "_.*m3u8")
	  (car)
	  (mkstr "http://tx2play1.douyucdn.cn/live/" <> ".flv?uuid="))))

(defun main ()
  (let* ((p (pathname "~/Documents/douyu.json"))
	 (rlst (->> (get-roomlist p)
		    (mapcar #'mkstr))))
    (pairlis (mapcar #'get-streamer rlst) (mapcar #'build-url rlst))))

(defun run (roomid)
  (new (make-instance 'ws-client :roomid roomid)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; danmu

;; (defun header-encode (msg)
;;   (let ((data-len (+ 9 (length msg)))
;; 	(msg-byte (trivial-utf-8:string-to-utf-8-bytes msg))
;; 	(len-byte (
