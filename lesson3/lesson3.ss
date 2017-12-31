(library-directories "~/thunderchez")
(import (sdl2))
(sdl-library-init)
(sdl-initialization)


(define *screen-w* 640)
(define *screen-h* 480)

(define *window* (sdl-create-window "Lesson 3"
				    0 0 ;;; x, y
				    *screen-w*
				    *screen-h*
				    0))

(define *surface* (sdl-get-window-surface *window*))


(define (make-event)
  (make-ftype-pointer sdl-event-t
		      (foreign-alloc
		       (ftype-sizeof sdl-event-t))))

;;;Load a bunch of bmps
;;;Can obviously do this in a much more
;;;sophisticated way.
(define a-blit (sdl-load-bmp "up.bmp"))
(define b-blit (sdl-load-bmp "right.bmp"))
(define c-blit (sdl-load-bmp "left.bmp"))
(define d-blit (sdl-load-bmp "down.bmp"))

(define *eve* (make-event))

;;;Helper function to tell if key matches the key that was
;;;pressed and caught in the event.
;;;event->key->keysym->scancode

(define (key-pressed? key)
  (= (ftype-ref sdl-keysym-t (scancode)
		(ftype-&ref sdl-keyboard-event-t (keysym)
			    (ftype-&ref sdl-event-t (key) *eve*)))
     (sdl-scancode key)))

;;;Change the whole screen to the passed .bmp
(define (change-blit-from-key img)
  (sdl-lower-blit img
		  (make-rect 0 0 *screen-w* *screen-h*)
		  *surface*
		  (make-rect 0 0 *screen-w* *screen-h*)))

(define (main-loop)
  (let looper ((poll (sdl-poll-event *eve*)))
    (cond
     ;;;Allows us to quit by hitting close window
     ((sdl-has-event (sdl-event-type 'quit)) (and (sdl-quit) (sdl-destroy-window *window*)))
     
     ((key-pressed? 'w)
      (change-blit-from-key a-blit)
      (looper (sdl-poll-event *eve*)))
     ((key-pressed? 'd)
      (change-blit-from-key b-blit)
      (looper (sdl-poll-event *eve*)))
     ((key-pressed? 'a)
      (change-blit-from-key c-blit)
      (looper (sdl-poll-event *eve*)))
     ((key-pressed? 's)
      (change-blit-from-key d-blit)
      (looper (sdl-poll-event *eve*)))
     (else

      (sdl-update-window-surface *window*)
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
