(define (problem Problema5)
		(:domain Ejercicio5)

		(:objects
				player1 - Player
				princesa1 - Princesa
				bruja1 bruja2 - Bruja
				manzana1 manzana2 - Manzana
				rosa1 - Rosa
				zapatilla1 - Zapatilla
				bikini1 - Bikini
				z1 z2 z5 - Bosque
				z7 - Agua
				z3 - Arena
				z4 z6 - Piedra
		)

		(:init
				(= (orientado player1) 0)

				(esBosque z1)
				(esZapatilla zapatilla1)
				(esBosque z2)
				(esBikini bikini1)
				(esBosque z5)
				(esAgua z7)

				(estaEn bruja1 z1)
				(estaEn zapatilla1 z3)
				(estaEn manzana1 z6)
				(estaEn manzana2 z6)
				(estaEn bruja2 z6)
				(estaEn player1 z2)
				(estaEn rosa1 z5)
				(estaEn bikini1 z5)
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

				(= (distanciaTotal) 0)
				(= (puntosTotales) 0)
				(= (puntosJugador player1) 0)
				(= (distanciaJugador player1) 0)

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

				(= (daPuntos princesa1 manzana1) 1)
				(= (daPuntos princesa1 manzana2) 1)
				(= (daPuntos princesa1 rosa1) 10)
				(= (daPuntos bruja1 manzana1) 10)
				(= (daPuntos bruja1 manzana2) 10)
				(= (daPuntos bruja1 rosa1) 5)
				(= (daPuntos bruja2 manzana1) 10)
				(= (daPuntos bruja2 manzana2) 10)
				(= (daPuntos bruja2 rosa1) 5)

				(= (maxBolsillo bruja1) 1)
				(= (nBolsillo bruja1) 0)
				(= (maxBolsillo princesa1) 1)
				(= (nBolsillo princesa1) 0)
				(= (maxBolsillo bruja2) 1)
				(= (nBolsillo bruja2) 0)
		)

		(:goal (and (>= (puntosTotales) 30)))

		(:metric minimize (distanciaTotal))
)