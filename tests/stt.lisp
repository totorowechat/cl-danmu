(defpackage danmu/tests/stt
  (:use
   :cl
   :danmu/stt
   :rove))
(in-package :danmu/tests/stt)

;; NOTE: To run this test file, execute `(asdf:test-system :danmu)' in your Lisp.

(deftest stt-deserialize-1
    (testing "should deserialize"
	     (ok (equal '(("type" "chatmsg") ("rid" "48699") ("ct" "1") ("uid" "64233236")
			  ("nn" "梦卡比之誓言") ("txt" "为主播点了个赞") ("cid" "ac0fa61ffb65404691a8050000000000")
			  ("ic" "avanew@Sface@S201701@S28@S22@Saef13ed5e612d8f13e325074955ff85c")
			  ("level" "12") ("sahf" "0") ("cst" "1598260731363") ("bnn" "Wx") ("bl" "7")
			  ("brid" "16101") ("hc" "82e926ced615da6a1558d884b43c368f") ("el" "") ("lk" "")
			  ("dat" "16") ("urlev" "1") ("dms" "3") ("pdg" "27") ("pdk" "9"))
			(deserialize "type@=chatmsg/rid@=48699/ct@=1/uid@=64233236/nn@=梦卡比之誓言/txt@=为主播点了个赞/cid@=ac0fa61ffb65404691a8050000000000/ic@=avanew@Sface@S201701@S28@S22@Saef13ed5e612d8f13e325074955ff85c/level@=12/sahf@=0/cst@=1598260731363/bnn@=Wx/bl@=7/brid@=16101/hc@=82e926ced615da6a1558d884b43c368f/el@=/lk@=/dat@=16/urlev@=1/dms@=3/pdg@=27/pdk@=9/")))))

(deftest stt-serialize-1
    (testing "should serialize"
	     (ok (string= "type@=chatmsg/rid@=48699/ct@=1/uid@=64233236/nn@=梦卡比之誓言/txt@=为主播点了个赞/cid@=ac0fa61ffb65404691a8050000000000/ic@=avanew@Sface@S201701@S28@S22@Saef13ed5e612d8f13e325074955ff85c/level@=12/sahf@=0/cst@=1598260731363/bnn@=Wx/bl@=7/brid@=16101/hc@=82e926ced615da6a1558d884b43c368f/el@=/lk@=/dat@=16/urlev@=1/dms@=3/pdg@=27/pdk@=9/"
			  (serialize '(("type" "chatmsg") ("rid" "48699") ("ct" "1") ("uid" "64233236")
				       ("nn" "梦卡比之誓言") ("txt" "为主播点了个赞") ("cid" "ac0fa61ffb65404691a8050000000000")
				       ("ic" "avanew@Sface@S201701@S28@S22@Saef13ed5e612d8f13e325074955ff85c")
				       ("level" "12") ("sahf" "0") ("cst" "1598260731363") ("bnn" "Wx") ("bl" "7")
				       ("brid" "16101") ("hc" "82e926ced615da6a1558d884b43c368f") ("el" "") ("lk" "")
				       ("dat" "16") ("urlev" "1") ("dms" "3") ("pdg" "27") ("pdk" "9")))))))

