;;;This lesson covers creating a window
;;;putting a few squares on screen
;;;and a couple of translation details

;;;Assuming you have installed chez, and thunderchez

(library-directories "~/thunderchez")
;;;Here we tell Chez where the thunderchez libraries are
;;;If you have them in a place other than the home folder
;;;than change this

(import (sdl2))
;;;Load SDL2 into Chez

(sdl-library-init)
(sdl-initialization)
;;;These two functions initialize the SDL library
;;;which we must do before we can use it

(define *window* (sdl-create-window "Hello World" 0 0 640 480 0))
;;;Create a new window, this will pop up once it's evaluated.

;;;First argument is the window title, followed by
;;;the x and y position of the window when it's created
;;;and the width and height of the window.

;;;The last number (in this case 0) is flags you can set
;;;0 is useful right now because it's simple and thats all
;;;we want

(define *surface* (sdl-get-window-surface *window*))
;;;Define a surface
;;;We will end up using this surface to draw onto the screen

;;;So now we have a window and would like to draw something onto
;;;the screen.  In this case we'll try a square.

;;;But how do we do that?

;;;What we need to use in this case is a function called
;;;(sdl-fill-rect) but we'll need to provide, a rect
;;;a surface to draw to, and the color we want the rect to be

(define (place-rect-on-surface surf rect x y z)
  (sdl-fill-rect surf rect (sdl-map-rgb (get-surface-format surf)
					x y z)))

(define (get-surface-format surf)
  (ftype-ref sdl-surface-t (format) surf))

;;;The first function's only real complexity is that the
;;;surface we have *surface* is a data structure that contains
;;;a format variable.  We need this format variable to express
;;;what format the colors need to be in.

;;;With Chez we can use (ftype-ref *pointer-type* (*var*) *obj*)
;;;This is equivalent to if we asked *surface*->format
;;;We are using the pointer we have to a surface to
;;;reference the format variable it contains in it's
;;;data structure.

(define (make-rect x1 y1 w1 h1)
  (let ((tr (make-ftype-pointer sdl-rect-t
		      (foreign-alloc
		       (ftype-sizeof sdl-rect-t)))))
    (ftype-set! sdl-rect-t (x) tr x1)
    (ftype-set! sdl-rect-t (y) tr y1)
    (ftype-set! sdl-rect-t (w) tr w1)
    (ftype-set! sdl-rect-t (h) tr h1)
    tr))

;;;Next we need a way to generate rectangles in a lispy way
;;;This function takes the location (x, y) and the dimensions
;;;(w, h) and returns a pointer to an sdl-rect-t that has
;;;this data set in it's structure

;;;At this point if we wanted to place a rect on the screen
;;;all we would have to do is say...

(place-rect-on-surface (make-rect 0 0 150 150) *surface*
		       0 128 128)
(sdl-update-window-surface *window*)
;;;But we could also have more fun with this and place a bunch
;;;of rectangles recursively.  Since we are using scheme after all...

(define (collage w y)
  (let looper ((x1 w)
	       (y1 y))
    (cond
     ((<= x1 -30) '())
     ((<= y1 -30) (looper (- x1 30) y))
     (else
      (place-rect-on-surface
       (make-rect x1 y1 30 30) *surface* (random 255) (random 255) 15)
      (sdl-update-window-surface *window*)
      (looper x1 (- y1 30))))))

;;;We can make this function more general but for now it will
;;;fill the whole screen with greenish and reddish blocks

;;;The last note we have to understand is when we use
;;;FillRect we are basically just putting that drawing
;;;into a buffer.

;;;For the window to actually update with what we've drawn;
;;;we have to tell it to do so.

;;;This is done with
(sdl-update-window-surface *window*)

;;;In the next lesson we'll learn how to load BMP's
