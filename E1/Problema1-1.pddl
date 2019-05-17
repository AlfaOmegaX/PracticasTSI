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
				(orientadoN player1)

				(estaEn bruja1 z1)
				(estaEn player1 z2)
				(estaEn manzana1 z4)
				(estaEn oscar1 z5)
				(estaEn princesa1 z7)

				(conectadasS z1 z3)
				(conectadasN z3 z1)
				(conectadasS z3 z6)
				(conectadasN z6 z3)
				(conectadasE z2 z3)
				(conectadasO z3 z2)
				(conectadasE z3 z4)
				(conectadasO z4 z3)
				(conectadasE z5 z6)
				(conectadasO z6 z5)
				(conectadasE z6 z7)
				(conectadasO z7 z6)
		)

		(:goal (and (tiene princesa1 manzana1) (tiene bruja1 oscar1)))
)