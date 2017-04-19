;;;; mariko.asd

(asdf:defsystem #:mariko
  :description "sprite tools"
  :author "Iseman Johnson"
  :license "MIT"
  :serial t
  :pathname "src"
  :depends-on (:cl-opengl :sdl2 :sdl2-image)
  :components ((:file "package")
               (:file "mariko")))

