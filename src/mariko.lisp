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
  "load 2d texture"
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
  "gets pixel coordinates converts them into tex coordinates and draws them. It is recommended to leave some space between objects on a spritesheet for this function to accurately draw the specified object" 
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

(defun append-frame-list (frame-list pixel-coord-list)
  "append a single sprite coordinate to a list of sprite coordinates"
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

(defun display-sprite (path num-of-columns num-of-rows sprite-row sprite-column &key (xshift 0) (yshift 0))
  "Use if you want to use just one sprite out of a sprite sheet"
  (let ((pixel-list (mariko:pixel-coord-list path num-of-columns num-of-rows
					     sprite-row sprite-column)))
    (mariko:draw (car pixel-list) (cadr pixel-list) (caddr pixel-list) (cadddr pixel-list)
			   (mariko:get-image-width path)
			   (mariko:get-image-height path)
			   :xshift xshift :yshift yshift)))

(defun column-list (frames sprite-column-start sprite-column-end)
  "collect the sprite column coordinates on a spritesheet"
  (if (<= sprite-column-end 0)
      (loop repeat frames
	 collect sprite-column-start)
      (loop for columns from sprite-column-start to sprite-column-end
	 collect columns)))

(defun row-list (frames sprite-row-start sprite-row-end)
  "collect the sprite row coordinates on a spritesheet"
  (if (<= sprite-row-end 0)
      (loop repeat frames
	 collect sprite-row-start)
      (loop for rows from sprite-row-start to sprite-row-end
	 collect rows)))

(defun make-frame-list (path frames number-of-columns number-of-rows sprite-column-start sprite-column-end sprite-row-start sprite-row-end)
  "Makes a list of coordinates from the collected row and sprite coordinates. Use for animating a sprite is reccommended. Sprite row end is zero unless you want to collect the sprite frames vertically."
  (loop for columns in (column-list frames sprite-column-start sprite-column-end)
       for rows in (row-list frames sprite-row-start sprite-row-end)
       collect (pixel-coord-list path number-of-columns number-of-rows columns rows)))

(defun map-tile-right-horizontal (path number-of-tiles distance-apart &key (num-of-columns 1) (num-of-rows 1) (sprite-row 0) (sprite-column 0) (xshift 0) (yshift 0))
  "Draw horizontal tiles to the right. if num-of-columns or rows not specified it will assume only 1 tile is on the sprite sheet"
  (loop repeat number-of-tiles
     do (setf xshift (+ xshift distance-apart))
     do (display-sprite path num-of-columns
			num-of-rows sprite-row sprite-column :xshift xshift :yshift yshift)))

(defun map-tile-down-vertical (path number-of-tiles distance-apart &key (num-of-columns 1) (num-of-rows 1) (sprite-row 0) (sprite-column 0) (xshift 0) (yshift 0))
    "Draw horizontal tiles to the right. if num-of-columns or rows not specified it will assume only 1 tile is on the sprite sheet"
  (loop repeat number-of-tiles
     do (setf yshift (+ yshift distance-apart))
     do (display-sprite path num-of-columns
			num-of-rows sprite-row sprite-column :xshift xshift :yshift yshift)))

(defun make-sprite-list-from-singles (path-list)
  "Make a list of sprite pixel-coords from a single sprite-sheet. Order matters
if doing tile-map with draw-tile-map"
  (loop for i in path-list
     collect (pixel-coord-list i 1 1 0 0)))

(defun read-file-to-list (data-file)
  "Read data file char by char unitl eof"
  (with-open-file (map data-file)
    (loop for char = (read-char map nil 'eof)
       until (eq char 'eof)
       nconc (list char))))

(defun tile-selector (char path sprite-coord tile-pixel-coord-table path-table
		      texture-table xshift yshift)
  "Select tile in according to matching char key in hash tables. The chars read
from file must have an existing hash key. If not then there will be undesired behavior."
  (unless (or (eq char #\NewLine) (eq char #\Space) (eq char #\Tab))
      (progn
	(setf path (gethash char path-table))
	(setf sprite-coord (gethash char tile-pixel-coord-table))
	(gl:bind-texture :texture-2d (gethash char texture-table))
	(draw (car sprite-coord) (cadr sprite-coord) (caddr sprite-coord)
		       (cadddr sprite-coord) (mariko:get-image-width path) (mariko:get-image-height path) :xshift xshift :yshift yshift))))

(defun draw-tiles (map-list texture-table path-table tile-pixel-coord-table x-distance-apart y-distance-apart &key (offset 0) (xshift 0) (yshift 0))
  "read map data file and draw tiles accordingly. offset shifts the each tile in the x direction use this if tiles are not hex."
    (loop for char in map-list
       with path 
       with sprite-coord
       with count = 0
       if (eq char #\NewLine)
       do (setf count (+ count 1))
       and
       do (setf yshift (+ yshift y-distance-apart))
       and
       do (setf xshift (* count offset))
       else do (setf xshift (+ xshift x-distance-apart))
       do (tile-selector char path sprite-coord tile-pixel-coord-table path-table
			 texture-table xshift yshift)))
