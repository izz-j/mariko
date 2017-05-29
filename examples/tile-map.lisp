(glfw:def-key-callback quit-on-escape (window key scancode action mod-keys)
  (declare (ignore window scancode mod-keys))
  (when (and (eq key :escape) (eq action :press))
    (glfw:set-window-should-close)))

(glfw:def-window-size-callback update-viewport (window w h)
  (declare (ignore window))
  (mariko:set-viewport w h))

(defun make-sprite-list-from-singles (path-list)
  "Make a list of sprite pixel-coords from a single sprite-sheet. Order matters
if doing tile-map with draw-tile-map"
  (loop for i in path-list
     collect (mariko:pixel-coord-list i 1 1 0 0)))

(defun read-file-to-list (data-file)
  "Read data file char by char unitl eof"
  (with-open-file (map data-file)
    (loop for char = (read-char map nil 'eof)
       until (eq char 'eof)
	 nconc (list char))))

(defun tile-selector (char path sprite-coord tile-pixel-coord-list path-list
		      texture-table xshift yshift)
  "Select tile in list. In this ex 0 is grass and 1 is dirt"
  (if (eq char #\0)
      (progn
	(setf path (car path-list))
	(setf sprite-coord (car tile-pixel-coord-list))
	(gl:bind-texture :texture-2d (gethash char texture-table))))
  (if (eq char #\1)
      (progn
	(setf path (cadr path-list))
	(setf sprite-coord (cadr tile-pixel-coord-list))
	(gl:bind-texture :texture-2d (gethash char texture-table))))
  (unless (eq path nil)
    (mariko:draw (car sprite-coord) (cadr sprite-coord) (caddr sprite-coord)
		  (cadddr sprite-coord) (mariko:get-image-width path) (mariko:get-image-height path) :xshift xshift :yshift yshift)))


(defun draw-tiles (texture-table data-file path-list tile-pixel-coord-list x-distance-apart y-distance-apart &key (offset 0) (xshift 0) (yshift 0))
  "read map data file and draw tiles accordingly. offset shifts the each tile in the x direction use this if tiles are not hex."
  (let ((map-list (read-file-to-list data-file)))
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
       do (tile-selector char path sprite-coord tile-pixel-coord-list path-list
			 texture-table xshift yshift))))	
	 

(defun map-tiles (path-list coord-list texture-table)
  (gl:clear :color-buffer-bit)
  (draw-tiles texture-table "sample-map.txt" path-list coord-list 65 50 :offset 30))
			     
(defun main ()
  (sdl2-image:init '(:png))
  (glfw:with-init-window (:title "Test Window" :width 800 :height 400)
    (let* ((grass "tileGrass.png")
	   (dirt "tileDirt_full.png")
	   (path-list (list grass dirt))
	   (texture-table (make-hash-table))
	   (tile-pixel-coord-list (make-sprite-list-from-singles path-list)))
      (setf (gethash #\0 texture-table) (mariko:load-texture grass))
      (setf (gethash #\1 texture-table) (mariko:load-texture dirt))
      (glfw:set-window-size-callback 'update-viewport)
      (glfw:set-key-callback 'quit-on-escape)
      (mariko:set-viewport 800 400)
      (gl:clear-color 1 1 1 1)
      (gl:clear :color-buffer)
      (loop until (glfw:window-should-close-p)
	 do (map-tiles path-list tile-pixel-coord-list texture-table)
	 do (glfw:poll-events)
	 do (glfw:swap-buffers)))))
