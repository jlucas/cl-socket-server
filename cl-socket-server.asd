(defsystem cl-socket-server
  :name       "cl-socket-server"
  :version    "1.0.0"
  :serial     t
  :depends-on (:bordeaux-threads
               :usocket)
  :components ((:module :src
                :components
                ((:file "package")
                 (:file "socket-server")))))

(defsystem cl-socket-server/tests
  :depends-on (:cl-socket-server
               :fiveam)
  :serial t
  :components ((:module :t
                :components
                ((:file "package")
                 (:file "socket-server")))))

