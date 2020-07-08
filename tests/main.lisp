(defpackage danmu/tests/main
  (:use :cl
        :danmu
        :rove))
(in-package :danmu/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :danmu)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
