(in-package #:cl-socket-server/tests)

(def-suite all-tests
  :description "The master suite of cl-socket-server tests")

(in-suite all-tests)

(defun test-socket-server ()
  (run! 'all-tests))

(def-fixture socket-server-running ()
  "Set up and tear down socket-server for testing"
  (cl-socket-server::start-server)
  (&body)
  (cl-socket-server::stop-server))

(test socket-server-thread ()
  "Test that we get a thread with the correct name"
  (with-fixture socket-server-running ()
    (is (find cl-socket-server::*server-socket-name* (bt:all-threads)
              :key #'bt:thread-name :test #'equal))))

(test dummy-tests
  "Example placeholder"
  (is (listp (list 1 2)))
  (is (= 5 (+ 2 3))))
