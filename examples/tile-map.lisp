(glfw:def-key-callback quit-on-escape (window key scancode action mod-keys)
  (declare (ignore window scancode mod-keys))
  (when (and (eq key :escape) (eq action :press))
    (glfw:set-window-should-close)))

(glfw:def-window-size-callback update-viewport (window w h)
  (declare (ignore window))
  (mariko:set-viewport w h))	
	 
(defun set-tables (path-table path-list tile-pixel-coord-table tile-pixel-coord-list texture-table)
  (setf (gethash #\0 path-table) (car path-list))
  (setf (gethash #\0 tile-pixel-coord-table) (car tile-pixel-coord-list))
  (setf (gethash #\0 texture-table) (mariko:load-texture (car path-list))))
  ;;note use gamebox-grid::cell change to one colon when loading it again
;;Note make a function that highlights the specific tile chosen by gamebox-grid
;;note tile drawer and grid s can be two separate functions. 
;;(defun highlight-hex-tile ()
 ;; ()
;;(defun make-hex-grid (map-width map-length path)
 ;; (let ((grid (gamebox-grids:grid 'gamebox-grids:hex-rows :offset :odd :y-axis :down :size (gamebox-math:vec map-width map-length) :cell-size (gamebox-math:vec (mariko:get-image-width path) (mariko:get-image-height path)))))
   ;; (princ (gamebox-grids:cell-to-point grid (gamebox-grids::cell 1 0)))
    ;;(terpri)
    ;;(princ (gamebox-grids:cell-member-p grid (gamebox-grids::cell 5 5)))))
    
(defun map-tiles (data-file path-table tile-pixel-coord-table texture-table)
  (let* ((map-list (mariko:read-file-to-list data-file))
	 (tile-vector (make-array (length map-list) :fill-pointer 0)))
  (gl:clear :color-buffer-bit)
  (mariko:read-tile-list tile-vector map-list texture-table path-table tile-pixel-coord-table 50 40 :offset 20 :y-odd-column-offset t)
  (mariko:draw-tiles tile-vector)))

			     
(defun main ()
  (sdl2-image:init '(:png))
  (glfw:with-init-window (:title "Test Window" :width 800 :height 400)
    (let* ((grass "Tile_Grass.png")
	   (path-list (list grass))
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
	 do (map-tiles "sample-map.txt" path-table tile-pixel-coord-table texture-table)
	 do (glfw:poll-events)
	 do (glfw:swap-buffers)))))
