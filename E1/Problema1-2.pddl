(define (problem Problema1)
		(:domain Ejercicio1)

		(:objects
				jugador1 - Player
				profesor1 - Profesor
				principe1 - Principe
				princesa1 - Princesa
				bruja1 - Bruja
				leonardo1 - Leonardo
				manzana1 - Manzana
				oscar1 - Oscar
				algoritmo1 - Algoritmo
				oro1 - Oro
				rosa1 - Rosa
				z1 z10 z11 z12 z13 z14 z15 z16 z17 z18 z19 z2 z20 z21 z22 z23 z24 z25 z3 z4 z5 z6 z7 z8 z9 - Zona
		)

		(:init
				(orientadoN jugador1)

				(estaEn princesa1 z7)
				(estaEn principe1 z8)
				(estaEn leonardo1 z9)
				(estaEn oscar1 z9)
				(estaEn rosa1 z12)
				(estaEn bruja1 z12)
				(estaEn oro1 z13)
				(estaEn jugador1 z13)
				(estaEn algoritmo1 z14)
				(estaEn profesor1 z18)
				(estaEn manzana1 z18)

				(conectadasE z1 z2)
				(conectadasO z2 z1)
				(conectadasE z2 z3)
				(conectadasO z3 z2)
				(conectadasE z4 z5)
				(conectadasO z5 z4)
				(conectadasE z7 z8)
				(conectadasO z8 z7)
				(conectadasE z8 z9)
				(conectadasO z9 z8)
				(conectadasE z11 z12)
				(conectadasO z12 z11)
				(conectadasE z12 z13)
				(conectadasO z13 z12)
				(conectadasE z13 z14)
				(conectadasO z14 z13)
				(conectadasE z14 z15)
				(conectadasO z15 z14)
				(conectadasE z16 z17)
				(conectadasO z17 z16)
				(conectadasE z17 z18)
				(conectadasO z18 z17)
				(conectadasE z18 z19)
				(conectadasO z19 z18)
				(conectadasE z19 z20)
				(conectadasO z20 z19)
				(conectadasE z21 z22)
				(conectadasO z22 z21)
				(conectadasE z22 z23)
				(conectadasO z23 z22)
				(conectadasE z23 z24)
				(conectadasO z24 z23)
				(conectadasS z6 z11)
				(conectadasN z11 z6)
				(conectadasS z11 z16)
				(conectadasN z16 z11)
				(conectadasS z2 z7)
				(conectadasN z7 z2)
				(conectadasS z7 z12)
				(conectadasN z12 z7)
				(conectadasS z17 z22)
				(conectadasN z22 z17)
				(conectadasS z3 z8)
				(conectadasN z8 z3)
				(conectadasS z8 z13)
				(conectadasN z13 z8)
				(conectadasS z13 z18)
				(conectadasN z18 z13)
				(conectadasS z4 z9)
				(conectadasN z9 z4)
				(conectadasS z5 z10)
				(conectadasN z10 z5)
				(conectadasS z10 z15)
				(conectadasN z15 z10)
				(conectadasS z15 z20)
				(conectadasN z20 z15)
				(conectadasS z20 z25)
				(conectadasN z25 z20)
		)

		(:goal (and (tiene profesor1 oscar1) (tiene principe1 rosa1) (tiene princesa1 algoritmo1) (tiene bruja1 manzana1) (tiene leonardo1 oro1)))
)