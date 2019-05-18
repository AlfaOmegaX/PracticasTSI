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
				(= (orientado jugador1) 0)

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

				(= (conectadas z1 z2) 1)
				(= (conectadas z2 z1) 3)
				(= (conectadas z2 z3) 1)
				(= (conectadas z3 z2) 3)
				(= (conectadas z4 z5) 1)
				(= (conectadas z5 z4) 3)
				(= (conectadas z7 z8) 1)
				(= (conectadas z8 z7) 3)
				(= (conectadas z8 z9) 1)
				(= (conectadas z9 z8) 3)
				(= (conectadas z11 z12) 1)
				(= (conectadas z12 z11) 3)
				(= (conectadas z12 z13) 1)
				(= (conectadas z13 z12) 3)
				(= (conectadas z13 z14) 1)
				(= (conectadas z14 z13) 3)
				(= (conectadas z14 z15) 1)
				(= (conectadas z15 z14) 3)
				(= (conectadas z16 z17) 1)
				(= (conectadas z17 z16) 3)
				(= (conectadas z17 z18) 1)
				(= (conectadas z18 z17) 3)
				(= (conectadas z18 z19) 1)
				(= (conectadas z19 z18) 3)
				(= (conectadas z19 z20) 1)
				(= (conectadas z20 z19) 3)
				(= (conectadas z21 z22) 1)
				(= (conectadas z22 z21) 3)
				(= (conectadas z22 z23) 1)
				(= (conectadas z23 z22) 3)
				(= (conectadas z23 z24) 1)
				(= (conectadas z24 z23) 3)
				(= (conectadas z6 z11) 2)
				(= (conectadas z11 z6) 0)
				(= (conectadas z11 z16) 2)
				(= (conectadas z16 z11) 0)
				(= (conectadas z2 z7) 2)
				(= (conectadas z7 z2) 0)
				(= (conectadas z7 z12) 2)
				(= (conectadas z12 z7) 0)
				(= (conectadas z17 z22) 2)
				(= (conectadas z22 z17) 0)
				(= (conectadas z3 z8) 2)
				(= (conectadas z8 z3) 0)
				(= (conectadas z8 z13) 2)
				(= (conectadas z13 z8) 0)
				(= (conectadas z13 z18) 2)
				(= (conectadas z18 z13) 0)
				(= (conectadas z4 z9) 2)
				(= (conectadas z9 z4) 0)
				(= (conectadas z5 z10) 2)
				(= (conectadas z10 z5) 0)
				(= (conectadas z10 z15) 2)
				(= (conectadas z15 z10) 0)
				(= (conectadas z15 z20) 2)
				(= (conectadas z20 z15) 0)
				(= (conectadas z20 z25) 2)
				(= (conectadas z25 z20) 0)
		)

		(:goal (and (tiene profesor1 oscar1) (tiene principe1 rosa1) (tiene princesa1 algoritmo1) (tiene bruja1 manzana1) (tiene leonardo1 oro1)))
)