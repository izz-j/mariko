(glfw:def-key-callback quit-on-escape (window key scancode action mod-keys)
  (declare (ignore window scancode mod-keys))
  (when (and (eq key :escape) (eq action :press))
    (glfw:set-window-should-close)))

(glfw:def-window-size-callback update-viewport (window w h)
  (declare (ignore window))
  (mariko:set-viewport w h))


(defparameter count-max 6)
(defparameter counter count-max)
(defparameter current-frame 0)
(defparameter xshift 0)
(defparameter yshift 0)

(defstruct human
  walk-right
  count-max
  counter
  position)

(defun play-anim (path frame-list)
  (let ((current-pixel-list (make-list 1)))
    (terpri)
    (when (= current-frame 0)
      (progn
	(setf current-pixel-list (car frame-list))
	(setf xshift 130)))
    (when (or (= current-frame 1) (= current-frame 3))
      (progn
	(setf current-pixel-list (cadr frame-list))
	(setf xshift 60)))
    (when (= current-frame 2)
      (setf current-pixel-list (caddr frame-list)))
    (when (= counter 0)
      (progn
	 (gl:clear :color-buffer-bit)
	 (mariko:draw (car current-pixel-list) (cadr current-pixel-list) (caddr current-pixel-list) (cadddr current-pixel-list) (mariko:get-image-width path) (mariko:get-image-height path) :xshift xshift)
	(princ current-pixel-list) 
	(setf xshift 0)
	(setf counter count-max)
	(setf current-frame (+ current-frame 1))
	(when (> current-frame 3)
	  (setf current-frame 0))))
    (setf counter (- counter 1))))


(defun main ()
  (sdl2-image:init '(:png))
  (glfw:with-init-window (:title "Test Window" :width 800 :height 400)
    (let ((path "walkcyclevarious.png")) 
      (mariko:load-texture path)
      (princ (mariko:make-frame-list path 3 12 8 3 5 1 0))
	(glfw:set-window-size-callback 'update-viewport)
	(glfw:set-key-callback 'quit-on-escape)
	(mariko:set-viewport 800 400)
	(gl:clear-color 1 1 1 1)
	(gl:clear :color-buffer)
	(loop until (glfw:window-should-close-p)
	   do (play-anim path (mariko:make-frame-list path 3 12 8 3 5 1 0))
	   do (glfw:poll-events)
	   do (glfw:swap-buffers))))))
