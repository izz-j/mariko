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

;;;Mariko examples
(asdf:defsystem #:mariko/mariko-examples
  :description "sprite examples"
  :license "MIT"
  :serial t
  :pathname "examples"
  :depends-on (:mariko :cl-glfw3)
  :components ((:file "package")
	       (:file "tile-map")
	       (:file "anim")
	       (:file "basic-sprite")))

