
From "variouswalkcycle.png"
![](https://github.com/izz-j/mariko/raw/master/sprites-preview.png)

Tiles by artofsully
![](https://github.com/izz-j/mariko/raw/master/hex4.gif)

closed source project character "The Sorceress" by artofsully
![](https://github.com/izz-j/mariko/raw/master/sample_sorceress.gif)

From "variouswalkcycle.png"
![](https://github.com/izz-j/mariko/raw/master/sample-anim.gif)

My experimental sprite renderer.
The characters on the "variouswalkcycle.png" are open and are from [opengameart](https://opengameart.org/)


Instructions

Clone or extract mariko to your local projects directory "~/quicklisp/local-projects/"

then quickload mariko

(ql:quickload 'mariko)

To run mariko's examples, first load the system

(asdf:load-system 'mariko/mariko-examples)

then run an example

(mariko-examples:basic-sprite-test)

(mariko-examples:anim-test)

(mariko-examples:tile-map-test)
