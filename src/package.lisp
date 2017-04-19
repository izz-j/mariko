;;;; package.lisp

(defpackage #:mariko
  (:use #:cl)
  (:export #:load-texture
	   #:set-viewport
	   #:get-image-width
	   #:get-image-height
	   #:tile-width
	   #:tile-height
	   #:row-to-pixel
	   #:column-to-pixel
	   #:pixel-x-to-texcoord
	   #:pixel-y-to-texcoord
	   #:draw
	   #:make-frame-list
	   #:pixel-coord-list))

