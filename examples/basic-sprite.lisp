(in-package #:mariko-examples)

(glfw:def-key-callback quit-on-escape (window key scancode action mod-keys)
  (declare (ignore window scancode mod-keys))
  (when (and (eq key :escape) (eq action :press))
    (glfw:set-window-should-close)))


(glfw:def-window-size-callback update-viewport (window w h)
  (declare (ignore window))
  (mariko:set-viewport w h))

(defun display-sprite (path num-of-columns num-of-rows sprite-row sprite-column &key (xshift 0) (yshift 0))
  (let ((pixel-list (mariko:pixel-coord-list path num-of-columns num-of-rows
					     sprite-row sprite-column)))
    (mariko:draw (car pixel-list) (cadr pixel-list) (caddr pixel-list) (cadddr pixel-list)
			   (mariko:get-image-width path)
			   (mariko:get-image-height path)
			   :xshift xshift :yshift yshift)))

(defun basic-sprite-test ()
  (sdl2-image:init '(:png))
  (glfw:with-init-window (:title "Test Window" :width 800 :height 400)
    (let ((path "walkcyclevarious.png")) 
      (mariko:load-texture path)
	(glfw:set-window-size-callback 'update-viewport)
	(glfw:set-key-callback 'quit-on-escape)
	(mariko:set-viewport 800 400)
	(gl:clear-color 0 0 0 0)
	(loop until (glfw:window-should-close-p)
	   do (display-sprite path 12 8 0 0)
	   do (glfw:poll-events)
	   do (glfw:swap-buffers)))))
