(library-directories "~/thunderchez")
(import (sdl2))
(sdl-library-init)
(sdl-initialization)

(define *screen-w* 640)
(define *screen-h* 480)

(define *window* (sdl-create-window "Lesson 4"
				    0 0 ;;; x, y
				    *screen-w*
				    *screen-h*
				    0))

(define (get-surface-format surf)
  (ftype-ref sdl-surface-t (format) surf))

(define *surface* (sdl-get-window-surface *window*))

;;;New in this lesson
;;;We use convert-surface here for optimization
;;;From the SDL reference
;;;Use this function to copy an existing surface into a new one that is
;;;optimized for blitting to a surface of a specified pixel format.

(define (optimize-bmp-from-surf bmp)
  (sdl-convert-surface bmp (get-surface-format *surface*) 0))

(define *stretchsurface* (optimize-bmp-from-surf
			  (sdl-load-bmp "stretch.bmp")))

;;;----Utilities --->


(define (place-rect-on-surface surf rect x y z)
  (sdl-fill-rect surf rect (sdl-map-rgb (get-surface-format surf)
					x y z)))

(define (make-rect x1 y1 w1 h1)
  (let ((tr (make-ftype-pointer sdl-rect-t
				(foreign-alloc
				 (ftype-sizeof sdl-rect-t)))))
    (ftype-set! sdl-rect-t (x) tr x1)
    (ftype-set! sdl-rect-t (y) tr y1)
    (ftype-set! sdl-rect-t (w) tr w1)
    (ftype-set! sdl-rect-t (h) tr h1)
    tr))

;;;----- New Functions

;;;This time we need the h and w of the surface
;;;we're trying to stretch onto the main surface's window
;;;This is how we get exact dimensions

(define (surface-width surf)
  (ftype-ref sdl-surface-t (w) surf))

(define (surface-height surf)
  (ftype-ref sdl-surface-t (h) surf))

;;;This is pretty standard blitting that has
;;;been seen before.  The only difference is we
;;;do the scaled version to make a smaller image
;;;fit the whole screen

(sdl-upper-blit-scaled
 *stretchsurface*
 (make-rect 0 0 (surface-width *stretchsurface*)
	    (surface-height *stretchsurface*))
 *surface*
 (make-rect 0 0 *screen-w* *screen-h*))

;;;Update window
(sdl-update-window-surface *window*)
