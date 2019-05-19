(define (problem Problema1)
		(:domain Ejercicio1)

		(:objects
				player1 - Player
				princesa1 - Princesa
				bruja1 - Bruja
				manzana1 - Manzana
				oscar1 - Oscar
				z1 z2 z3 z4 z5 z6 z7 - Zona
		)

		(:init
				(= (orientado player1) 0)

				(estaEn bruja1 z1)
				(estaEn player1 z2)
				(estaEn manzana1 z4)
				(estaEn oscar1 z5)
				(estaEn princesa1 z7)

				(= (conectadas z1 z3) 2)
				(= (conectadas z3 z1) 0)
				(= (conectadas z3 z6) 2)
				(= (conectadas z6 z3) 0)
				(= (conectadas z2 z3) 1)
				(= (conectadas z3 z2) 3)
				(= (conectadas z3 z4) 1)
				(= (conectadas z4 z3) 3)
				(= (conectadas z5 z6) 1)
				(= (conectadas z6 z5) 3)
				(= (conectadas z6 z7) 1)
				(= (conectadas z7 z6) 3)
		)

		(:goal (and (tiene princesa1 manzana1) (tiene bruja1 oscar1)))
)