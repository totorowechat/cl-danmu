(defpackage danmu/tests/utils
  (:use :cl
        :danmu/utils
        :rove))
(in-package :danmu/tests/utils)

;; NOTE: To run this test file, execute `(asdf:test-system :danmu)' in your Lisp.

(deftest utils-group
  (testing "(group '(1 2 3 4 5 6 7) 3) -> '((1 2 3) (4 5 6) (7))"
    (ok (equal (group '(1 2 3 4 5 6 7) 3) '((1 2 3) (4 5 6) (7))))))
