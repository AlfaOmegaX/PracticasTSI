(define (problem Problema2)
		(:domain Ejercicio2)

		(:objects
				player1 - Player
				princesa1 - Princesa
				bruja1 - Bruja
				manzana1 - Manzana
				oscar1 - Oscar
				z1 z2 z3 z4 z5 z6 z7 - Zona
		)

		(:init
				(orientadoHacia player1 N)

				(estaEn bruja1 z1)
				(estaEn player1 z2)
				(estaEn manzana1 z4)
				(estaEn oscar1 z5)
				(estaEn princesa1 z7)

				(estanConectadas z1 z3 S)
				(estanConectadas z3 z1 N)
				(estanConectadas z3 z6 S)
				(estanConectadas z6 z3 N)
				(estanConectadas z2 z3 E)
				(estanConectadas z3 z2 O)
				(estanConectadas z3 z4 E)
				(estanConectadas z4 z3 O)
				(estanConectadas z5 z6 E)
				(estanConectadas z6 z5 O)
				(estanConectadas z6 z7 E)
				(estanConectadas z7 z6 O)

				(= (distanciaTotal player1) 0)

				(= (distanciaZona z1 z3) 10)
				(= (distanciaZona z3 z1) 10)
				(= (distanciaZona z3 z6) 5)
				(= (distanciaZona z6 z3) 5)
				(= (distanciaZona z2 z3) 10)
				(= (distanciaZona z3 z2) 10)
				(= (distanciaZona z3 z4) 5)
				(= (distanciaZona z4 z3) 5)
				(= (distanciaZona z5 z6) 10)
				(= (distanciaZona z6 z5) 10)
				(= (distanciaZona z6 z7) 5)
				(= (distanciaZona z7 z6) 5)
		)

		(:goal (and (tiene princesa1 manzana1) (tiene bruja1 oscar1)))

		(:metric minimize (distanciaTotal player1))
)