# cl-socket-server

This package implements a very simple chat server based on example
socket processing code from Mihai Bazon in his blog post
[Howto: multi-threaded TCP server in Common Lisp](http://mihai.bazon.net/blog/howto-multi-threaded-tcp-server-in-common-lisp).

Mihai's code was instrumental in helping me understand how to
implement a socket server in Common Lisp but he left actually getting
the code working as an exercise to the reader.

I have dropped the multi-threaded client handling aspect of the server
in order to simplify the example.  Following in the spirit of Mihai's
original post, I hope that this example will help someone.

Load the system with ASDF and run...

    (start-server)

This will create a thread "SOCKET-PROCESSOR".  It should show up in
the list from...

    (bt:all-threads)

If the thread exists, you should be able connect to port 9001 on your
local machine from any number of telnet clients.  For example by
running...

    telnet localhost 9001

...in a terminal.  After typing some text and pressing enter in a
connected telnet session you should see your message printed in all
other connected sessions.

