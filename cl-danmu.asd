(defsystem "cl-danmu"
  :version "0.1.1"
  :author "Lingao Jin"
  :license "MIT"
  :depends-on ("bt-semaphore" ;; todo replace with Bordeaux-Threads
	       "drakma"
               "cl-ppcre"
               "cl-json"
	       "cl-arrows"
	       "cl-intbytes"
	       "trivial-utf-8"
	       "ironclad"
	       "websocket-driver-client")
  :components ((:module "src"
                :serial t
                :components
                ((:file "utils")
		 (:file "stt")
		 (:file "msg")
		 (:file "web-socket")
		 (:file "main"))))
  :description ""
  :build-operation "program-op" ;; leave as is
  :build-pathname "danmu"
  :entry-point "danmu:main"
  :in-order-to ((test-op (test-op "cl-danmu/tests"))))

(defsystem "cl-danmu/tests"
  :author "Lingao Jin"
  :license "MIT"
  :depends-on ("cl-danmu"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "utils")
		 (:file "stt")
		 (:file "msg")
		 (:file "web-socket")
		 (:file "main"))))
  :description "Test system for danmu"
  :perform (test-op (op c) (symbol-call :rove :run c)))
