(defpackage danmu/tests/stt
  (:use :cl
        :danmu
        :rove))
(in-package :danmu/tests/stt)

;; NOTE: To run this test file, execute `(asdf:test-system :danmu)' in your Lisp.

(deftest test-stt-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
