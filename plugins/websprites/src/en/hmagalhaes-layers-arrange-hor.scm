; This piece of software is free; you can redistribute it and/or modify as you
; want and/or need. It's up to you, have fun.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
;
; This scripts is expected to arrange all layers horizontally, it means, side by side.
; @autor hudson@hmagalhaes.eti.br
; @ver 12/12/2011
(script-fu-register "script-fu-hmagalhaes-layers-arrange-hor"
	"<Image>/Image/Web Sprites/Arrange layers horizontally"
    "Arrange layers horizontally, side by side, and then resizes the image to fit the layers."
    "hudson@hmagalhaes.eti.br"
    "Hudson Pena Magalhães"
    "Dec 12th, 2011"
    "INDEXED* RGB* GRAY*"
	SF-IMAGE "Image to use" 0
	SF-DRAWABLE "Layer to use" 0
)
(define (script-fu-hmagalhaes-layers-arrange-hor img drawable)
	(let *
		(
			(i 0)
			(layer 0)
			(layerX 0)
			(layerY 0)
			(layerCount 0)
			(layerList 0)
		)

		(set! layerList (gimp-image-get-layers img)) ;[layersCount], [(list of layers)]
		(set! layerCount (car layerList))
		(set! layerList (cadr layerList))

		(while (< i layerCount)
			(set! layer (aref layerList i)) ;the layer

			(gimp-layer-set-offsets layer layerX layerY) ;moves the layer
			(set! layerX
				(+ layerX
					(car
						(gimp-drawable-width layer)))) ;increases position

			(set! i (+ i 1))
		)
		(gimp-image-resize-to-layers img) ;fit image to layers
	)
)