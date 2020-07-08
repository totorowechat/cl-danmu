(defsystem "cl-danmu"
  :version "0.1.0"
  :author "Lingao Jin"
  :license "MIT"
  :depends-on ("drakma"
               "cl-ppcre"
               "cl-json"
	       "cl-arrows"
	       "trivial-utf-8"
	       "ironclad")
  :components ((:module "src"
                :serial t
                :components
                ((:file "utils")
                 (:file "stt")
		 (:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "cl-danmu/tests"))))

(defsystem "cl-danmu/tests"
  :author "Lingao Jin"
  :license "MIT"
  :depends-on ("cl-danmu"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for danmu"
  :perform (test-op (op c) (symbol-call :rove :run c)))
