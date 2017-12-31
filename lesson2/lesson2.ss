(library-directories "~/thunderchez")
(import (sdl2))
(sdl-library-init)
(sdl-initialization)

;;;Constants to help remove magic numbers
(define *screen-w* 640)
(define *screen-h* 480)

(define *window* (sdl-create-window "Lesson 2"
				    0 0 ;;; x, y
				    *screen-w*
				    *screen-h*
				    0))

(define *surface* (sdl-get-window-surface *window*))

;;;Load a bmp,  *image* is now an
;;;sdl-surface-t type pointer
(define *image* (sdl-load-bmp "x.bmp"))

;;;helper function; returns a pointer to an
;;;event structure
;;;this will automatically get updated
;;;look at sdl reference for details
(define (make-event)
  (make-ftype-pointer sdl-event-t
		      (foreign-alloc
		       (ftype-sizeof sdl-event-t))))

;;;our event struct
(define *eve* (make-event))

(define (main-loop)
  ;;;Event loop basic
  (let looper ((poll (sdl-poll-event *eve*)))
    (cond
     ((sdl-has-event 256) (and (sdl-quit) (sdl-destroy-window *window*)))
     ;;;From what I can tell so far, you use (sdl-poll-event) to tell if
     ;;;an event occured or not.  It will return a 0 or 1
     ;;;Then you can use (sdl-has-event event-num) which returns
     ;;;true or false if the event occured
     ;;;There is probably a better way to do this but more experimenting
     ;;;reqired.  256 is the sdl_quit code
     ;;;We destroy the window to clean up afterwards
     (else
      ;;;This functions pretty easy all we do is take an *image*
      ;;;in this case our bmp, and give it a src rect.
      ;;;In this case our rectangles are both just the full screen size
      ;;;We also give it *surface* to tell it what to draw onto
      (sdl-lower-blit *image*
		      (make-rect 0 0 *screen-w* *screen-h*)
		      *surface*
		      (make-rect 0 0 *screen-w* *screen-h*))
      ;;;And then update the window with what we've done
      (sdl-update-window-surface *window*)
      ;;;Poll a new event and loop
      (looper (sdl-poll-event *eve*))))))

;;;----- Utility from previous lessons

(define (place-rect-on-surface surf rect x y z)
  (sdl-fill-rect surf rect (sdl-map-rgb (get-surface-format surf)
					x y z)))

(define (get-surface-format surf)
  (ftype-ref sdl-surface-t (format) surf))

(define (make-rect x1 y1 w1 h1)
  (let ((tr (make-ftype-pointer sdl-rect-t
		      (foreign-alloc
		       (ftype-sizeof sdl-rect-t)))))
    (ftype-set! sdl-rect-t (x) tr x1)
    (ftype-set! sdl-rect-t (y) tr y1)
    (ftype-set! sdl-rect-t (w) tr w1)
    (ftype-set! sdl-rect-t (h) tr h1)
    tr))


(main-loop)
