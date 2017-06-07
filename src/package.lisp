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
	   #:append-frame-list
	   #:pixel-coord-list
	   #:make-frame-list
	   #:display-sprite
	   #:map-tile-right-horizontal
	   #:map-tile-down-vertical
	   #:make-sprite-list-from-singles
	   #:read-file-to-list
	   #:read-tile-list
	   #:draw-tiles))

