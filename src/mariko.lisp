;;;; mariko.lisp

(in-package #:mariko)

;;; "mariko" goes here. Hacks and glory await!

(defun set-viewport (w h)
  (gl:viewport 0 0 w h)
  (gl:matrix-mode :projection)
  (gl:load-identity) 
  (gl:ortho 0 w h 0 -10000 10000) 
  (gl:matrix-mode :modelview)
  (gl:load-identity))

(defun load-texture (path)
  (let* ((image (sdl2-image:load-image path))
	 (surface-data (sdl2:surface-pixels image))
	 (width (sdl2:surface-width image))
	 (height (sdl2:surface-height image))
	 (tex (gl:gen-texture)))
    (gl:enable :texture-2d)
    (gl:bind-texture :texture-2d tex)
    (gl:tex-parameter :texture-2d :texture-min-filter :nearest)
    (gl:tex-image-2d :texture-2d 0 :RGBA8 width height 0 :rgba :unsigned-byte surface-data)
    tex))
;;These function simple functions
;;really are to prevent me from
;;getting the conversions confused
;;if anything
(defun get-image-width (path)
  (sdl2:surface-width (sdl2-image:load-image path)))

(defun get-image-height (path)
  (sdl2:surface-height (sdl2-image:load-image path)))

(defun tile-width (spritesheet-width tile-columns)
  (/ spritesheet-width tile-columns))

(defun tile-height (spritesheet-height tile-rows)
  (/ spritesheet-height tile-rows))

(defun row-to-pixel (row tile-height)
  (* row tile-height))

(defun column-to-pixel (column tile-width)
  (* column tile-width))

(defun pixel-x-to-texcoord (x spritesheet-width)
  (/ x spritesheet-width ))

(defun pixel-y-to-texcoord (y spritesheet-height)
  (/ y spritesheet-height))

(defun draw (px0 py0 px1 py1 spritesheet-width spritesheet-height &key (xshift 0) (yshift 0))
  (gl:enable :blend)
  (gl:blend-func :src-alpha :one-minus-src-alpha)
  (let* ((tx0 (pixel-x-to-texcoord px0 spritesheet-width))
	 (tx1 (pixel-x-to-texcoord px1 spritesheet-width))
	 (ty0 (pixel-y-to-texcoord py0 spritesheet-height))
	 (ty1 (pixel-y-to-texcoord py1 spritesheet-height)))
    (gl:with-primitive :quads
      (gl:tex-coord tx0 ty0)
      (gl:vertex (+ px0 xshift) (+ py0 yshift) 0)
      (gl:tex-coord tx1 ty0)
      (gl:vertex  (+ px1 xshift) (+ py0 yshift) 0)
      (gl:tex-coord tx1 ty1)
      (gl:vertex (+ px1 xshift) (+ py1 yshift) 0)
      (gl:tex-coord  tx0 ty1)
      (gl:vertex (+ px0 xshift) (+ py1 yshift)  0)))
  (gl:flush))

(defun make-frame-list (frame-list pixel-coord-list)
  (setf frame-list (mapcar #'append frame-list pixel-coord-list)))

(defun pixel-coord-list (path num-of-columns num-of-rows
			  sprite-row sprite-column)
  (let* ((imw (get-image-width path))
	 (imh (get-image-height path))
	 (tw (tile-width imw num-of-columns))
	 (th (tile-height imh num-of-rows))
	 (px0 (column-to-pixel sprite-row tw))
	 (py0 (row-to-pixel sprite-column th))
	 (px1 (+ px0 tw))
	 (py1 (+ py0 th)))
    (list px0 py0 px1 py1)))
