; This piece of software is free; you can redistribute it and/or modify as you
; want and/or need. It's up to you, have fun.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
;
; This scripts is expected export an CSS file containing rules to use the current image
; as a web sprite, where each layer is an element/selector.
; @autor hudson@hmagalhaes.eti.br
; @ver 12/12/2011
(script-fu-register "script-fu-hmagalhaes-layers-export-css"
	"<Image>/Image/Web Sprites/Exportar arquivo CSS"
    "Exporta um arquivo CSS contendo as regras CSS para usar a imagem atual como um web sprite, onde cada layer é um elemento/seletor."
    "hudson@hmagalhaes.eti.br"
    "Hudson Pena Magalhães"
    "Dec 12th, 2011"
    "INDEXED* RGB* GRAY*"
	SF-IMAGE "Image to use" 0
	SF-STRING "Arquivo CSS (arquivo a salvar)" "sprites.css"
	SF-DIRNAME "Diretório do arquivo CSS" "~"
	SF-STRING "Arquivo de imagem (bkg-image)" "sprites.png"
	SF-STRING "Prefixo dos seletores" ""
	SF-STRING "Sufixo dos seletores" ""
	SF-OPTION "Repetição do Background" '("no-repeat" "Deixe Vazio!" "repeat" "repeat-x" "repeat-y")
	SF-STRING "Seletor de abstração" ""
	SF-TOGGLE "Agrupar seletores" 1
	SF-TOGGLE "Incluir largura do layer" 1
	SF-TOGGLE "Incluir altura do layer" 1
	SF-TOGGLE "Definir tamanho no grupo/abstração" 0
	SF-TOGGLE "Manter espaços em branco" 1
	SF-TOGGLE "Manter quebras de linha" 1
	SF-TOGGLE "Remover extensão de arquivo" 1
)
(define (getSelectorName layer remExtension)
	(let* ((layerName ""))
		(set! layerName (car (gimp-layer-get-name layer)))

		(if remExtension ;
			(begin
				(let*
					(
						(i (- (string-length layerName) 1))
						(j -1)
					)

					; let's check if there is any extension
					; omg, is there any string search function which returns the key index?
					(while (> i -1)  ;searches extension dot
						(if (equal? (string-ref layerName i) #\.)
							(begin
								(set! j i)
								(set! i -1)
							)
						)
						(set! i (- i 1))
					)
					(if (> j -1)
						(begin (set! layerName (substring layerName 0 j)))
					)
				)
			)
		)

		(string-append layerName "")  ;return
	)
)

(define (getScale scale)
	(if (> scale 0)
		(string-append (number->string scale) "px")
		"0"
	)
)

(define (getWidth w ws)
	(string-append "width:" ws (getScale w))
)

(define (getHeight h ws)
	(string-append "height:" ws (getScale h))
)

(define (getPosition pos)
	(if (> pos 0)
		(string-append "-" (number->string pos) "px")
		"0"
	)
)

(define (script-fu-hmagalhaes-layers-export-css
		img
		cssName
		dirName
		imgFile
		prefix
		postfix
		bkgRepeat
		abstraction
		group
		inWidth
		inHeight
		scaleInGrp
		keepWS
		keepLB
		remExtension)
	(let *
		(
			(i 0)
			(layer 0)
			(layerPos 0)
			(layerCount 0)
			(layerList 0)
			(path "")
			(fileStr "")
			(bkgPrefix "")
			(bkgShorthand "")
			(groupedScale "")
			(tmp 0)
			(bkgSemicolon "")
			(widthSemicolon "")
			(lb "")
			(ws "")
		)

		; get layers
		(set! layerList (gimp-image-get-layers img)) ;[layersCount], [(list of layers)]
		(set! layerCount (car layerList))
		(set! layerList (cadr layerList))

		; white space & line break
		(set! lb (if (= keepLB TRUE) "\n" lb))
		(set! ws (if (= keepWS TRUE) " " ""))

		; full path
		(set! path (string-append dirName
				(if (re-match "/$" dirName) "" "/")
				cssName))

		; semicolons for css rules
		(set! tmp (string-append ";" ws))
		(set! bkgSemicolon (if (= inWidth TRUE) tmp bkgSemicolon))  ;if we have width or height
		(set! bkgSemicolon (if (= inHeight TRUE) tmp bkgSemicolon))
		(if (= inHeight TRUE) (begin
			(if (= inWidth TRUE) (begin
				(set! widthSemicolon tmp) ;if we have both scales
			))
		))

		; scale in group/abstraction
		(set! layer (aref layerList 0)) ;the first layer
		(if (equal? (= scaleInGrp TRUE) (> layerCount 0)) (begin
			(set! groupedScale bkgSemicolon)  ;will go after background rule
			(if (= inWidth TRUE) (begin
				(set! groupedScale (string-append
						groupedScale
						(getWidth (car (gimp-drawable-width layer)) ws)
						widthSemicolon
						))
			))
			(if (= inHeight TRUE) (begin
				(set! groupedScale (string-append
						groupedScale
						(getHeight (car (gimp-drawable-height layer)) ws)
						;no semicolon, will be the last rule
						))
			))
		))

		; bkg repeat
		(set! bkgRepeat (cond
				((= bkgRepeat 0) " no-repeat")
				((= bkgRepeat 2) " repeat")
				((= bkgRepeat 3) " repeat-x")
				((= bkgRepeat 4) " repeat-y")
				(else "")
				))

		; bkg shorthand
		(set! bkgShorthand (string-append
				ws "{background:" ws "url(" imgFile ")"
				bkgRepeat
				groupedScale
				"}"
				lb
				))

		; sprites abstraction
		(if (> (string-length abstraction) 0) (begin
			(set! fileStr (string-append abstraction bkgShorthand))
		))

		; sprites grouping
		(while (< i layerCount)
			(set! layer (aref layerList i)) ;the layer

			; css selectors
			(set! fileStr (if (= group TRUE)
					(string-append
							fileStr
							(if (> i 0)
									(string-append "," ws)
									""
									)
							prefix
							(getSelectorName layer remExtension)
							postfix)
					fileStr
					))

			(set! i (+ i 1))
		)
		(set! fileStr (if (= group TRUE)
				(string-append fileStr bkgShorthand)
				fileStr
				))

		; bkg prefix
		(let* ((tmp 0))
				(if (re-match "." abstraction)
						(begin (set! tmp 1))
						)
				(if (= group TRUE)
						(begin (set! tmp 1))
						)
				(set! bkgPrefix (if (= tmp 1)
						(string-append "background-position:" ws)
						(string-append "background:" ws "url(" imgFile ")" bkgRepeat " ") ;this last ws is between repeat and position
						))
				)

		; layers
		(set! i 0)
		(while (< i layerCount)
			(set! layer (aref layerList i)) ;the layer

			;layer offset
			(set! layerPos (gimp-drawable-offsets layer))

			; css rule
			(set! fileStr (string-append fileStr
					prefix
					(getSelectorName layer remExtension)
					postfix
					ws
					"{"
					bkgPrefix
					(getPosition (car layerPos))
					" " (getPosition (cadr layerPos))
					(if (= scaleInGrp TRUE)
							""
							(string-append
									bkgSemicolon
									(if (= inWidth TRUE)
											(getWidth (car (gimp-drawable-width layer)) ws)
											""
											)
									widthSemicolon
									(if (= inHeight TRUE)
											(getHeight (car (gimp-drawable-height layer)) ws)
											""
											)
									)
							)
					"}"
					lb
					))

			(set! i (+ i 1))
		)

		;(gimp-message fileStr)

		(call-with-output-file path
				(lambda (output-port)
				(display fileStr output-port)))
	)
)