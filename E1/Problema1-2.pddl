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
				(orientadoHacia jugador1 N)

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

				(estanConectadas z1 z2 E)
				(estanConectadas z2 z1 O)
				(estanConectadas z2 z3 E)
				(estanConectadas z3 z2 O)
				(estanConectadas z4 z5 E)
				(estanConectadas z5 z4 O)
				(estanConectadas z7 z8 E)
				(estanConectadas z8 z7 O)
				(estanConectadas z8 z9 E)
				(estanConectadas z9 z8 O)
				(estanConectadas z11 z12 E)
				(estanConectadas z12 z11 O)
				(estanConectadas z12 z13 E)
				(estanConectadas z13 z12 O)
				(estanConectadas z13 z14 E)
				(estanConectadas z14 z13 O)
				(estanConectadas z14 z15 E)
				(estanConectadas z15 z14 O)
				(estanConectadas z16 z17 E)
				(estanConectadas z17 z16 O)
				(estanConectadas z17 z18 E)
				(estanConectadas z18 z17 O)
				(estanConectadas z18 z19 E)
				(estanConectadas z19 z18 O)
				(estanConectadas z19 z20 E)
				(estanConectadas z20 z19 O)
				(estanConectadas z21 z22 E)
				(estanConectadas z22 z21 O)
				(estanConectadas z22 z23 E)
				(estanConectadas z23 z22 O)
				(estanConectadas z23 z24 E)
				(estanConectadas z24 z23 O)
				(estanConectadas z6 z11 S)
				(estanConectadas z11 z6 N)
				(estanConectadas z11 z16 S)
				(estanConectadas z16 z11 N)
				(estanConectadas z2 z7 S)
				(estanConectadas z7 z2 N)
				(estanConectadas z7 z12 S)
				(estanConectadas z12 z7 N)
				(estanConectadas z17 z22 S)
				(estanConectadas z22 z17 N)
				(estanConectadas z3 z8 S)
				(estanConectadas z8 z3 N)
				(estanConectadas z8 z13 S)
				(estanConectadas z13 z8 N)
				(estanConectadas z13 z18 S)
				(estanConectadas z18 z13 N)
				(estanConectadas z4 z9 S)
				(estanConectadas z9 z4 N)
				(estanConectadas z5 z10 S)
				(estanConectadas z10 z5 N)
				(estanConectadas z10 z15 S)
				(estanConectadas z15 z10 N)
				(estanConectadas z15 z20 S)
				(estanConectadas z20 z15 N)
				(estanConectadas z20 z25 S)
				(estanConectadas z25 z20 N)
		)

		(:goal (and (tiene profesor1 oscar1) (tiene principe1 rosa1) (tiene princesa1 algoritmo1) (tiene bruja1 manzana1) (tiene leonardo1 oro1)))
)