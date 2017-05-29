(glfw:def-key-callback quit-on-escape (window key scancode action mod-keys)
  (declare (ignore window scancode mod-keys))
  (when (and (eq key :escape) (eq action :press))
    (glfw:set-window-should-close)))

(glfw:def-window-size-callback update-viewport (window w h)
  (declare (ignore window))
  (mariko:set-viewport w h))	
	 
(defun set-tables (path-table path-list tile-pixel-coord-table tile-pixel-coord-list texture-table)
  (setf (gethash #\0 path-table) (car path-list))
  (setf (gethash #\1 path-table) (cadr path-list))
  (setf (gethash #\0 tile-pixel-coord-table) (car tile-pixel-coord-list))
  (setf (gethash #\1 tile-pixel-coord-table) (cadr tile-pixel-coord-list))
  (setf (gethash #\0 texture-table) (mariko:load-texture (car path-list)))
  (setf (gethash #\1 texture-table) (mariko:load-texture (cadr path-list))))

(defun map-tiles (path-table tile-pixel-coord-table texture-table)
  (gl:clear :color-buffer-bit)
  (mariko:draw-tiles texture-table "sample-map.txt" path-table tile-pixel-coord-table 65 50 :offset 30))
			     
(defun main ()
  (sdl2-image:init '(:png))
  (glfw:with-init-window (:title "Test Window" :width 800 :height 400)
    (let* ((grass "tileGrass.png")
	   (dirt "tileDirt_full.png")
	   (path-list (list grass dirt))
	   (path-table (make-hash-table))
	   (texture-table (make-hash-table))
	   (tile-pixel-coord-list (mariko:make-sprite-list-from-singles path-list))
	   (tile-pixel-coord-table (make-hash-table)))
      (set-tables path-table path-list tile-pixel-coord-table tile-pixel-coord-list texture-table)
      (glfw:set-window-size-callback 'update-viewport)
      (glfw:set-key-callback 'quit-on-escape)
      (mariko:set-viewport 800 400)
      (gl:clear-color 1 1 1 1)
      (gl:clear :color-buffer)
      (loop until (glfw:window-should-close-p)
	 do (map-tiles path-table tile-pixel-coord-table texture-table)
	 do (glfw:poll-events)
	 do (glfw:swap-buffers)))))
