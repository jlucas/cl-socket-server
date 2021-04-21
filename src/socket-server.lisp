(in-package #:cl-socket-server)

;;; Based on
;;; http://mihai.bazon.net/blog/howto-multi-threaded-tcp-server-in-common-lisp

(defparameter *port* 9001)

(defparameter *server-socket-name* "SOCKET-PROCESSOR")

(define-condition shutting-down (condition) ())

(defun socket-processor ()
  (usocket:with-socket-listener (master-socket usocket:*wildcard-host*
                                               *port*
                                               :reuse-address t)
    (let ((sockets (list master-socket)))
      (handler-case
          (loop
            (mapcar (lambda (s)
                      (if (eq s master-socket)
                          ;; then: handle new connection
                          (let* ((new (usocket:socket-accept s)))
                            (setf sockets (push new sockets)))
                          ;; else: handle client socket
                          (if (listen (usocket:socket-stream s))
                              ;; process client input
                              (let ((input (read-line (usocket:socket-stream s))))
                                (mapcar (lambda (sock)
                                          (format (usocket:socket-stream sock) "~a~%" input)
                                          (usocket::force-output (usocket:socket-stream sock)))
                                        (remove s (remove master-socket sockets))))
                              ;; handle EOF, lost connection
                              (progn
                                (setf sockets (delete s sockets))
                                (usocket:socket-close s)))))
                    ;; This is a blocking call as long as there is no
                    ;; input on any socket
                    (usocket:wait-for-input sockets :ready-only t)))
        (shutting-down ()
          (mapcar #'usocket:socket-close sockets))))))

(defun start-server ()
  (bt:make-thread #'socket-processor :name *server-socket-name*))

(defun stop-server ()
  (let ((server-thread (find *server-socket-name* (bt:all-threads)
                             :key #'bt:thread-name :test #'equal)))
    (bt:interrupt-thread server-thread
                         (lambda ()
                           (signal 'shutting-down)))
    (bt:destroy-thread server-thread)))
