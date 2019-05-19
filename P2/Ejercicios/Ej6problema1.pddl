(define (problem Problema6)
		(:domain Ejercicio6)

		(:objects
				player1 player2 - Player
				princesa1 - Princesa
				bruja1 - Bruja
				manzana1 manzana2 - Manzana
				oscar1 oscar2 - Oscar
				algoritmo1 - Algoritmo
				oro1 oro2 - Oro
				rosa2 - Rosa
				zapatilla1 - Zapatilla
				bikini1 - Bikini
				z1 z2 z5 - Bosque
				z7 - Agua
				z3 - Arena
				z4 z6 - Piedra
		)

		(:init
				(= (orientado player1) 0)
				(= (orientado player2) 0)

				(esBosque z1)
				(esZapatilla zapatilla1)
				(esBikini bikini1)
				(esBosque z2)
				(esBosque z5)
				(esAgua z7)

				(estaEn bruja1 z1)
				(estaEn zapatilla1 z3)
				(estaEn bikini1 z3)
				(estaEn algoritmo1 z6)
				(estaEn oro2 z6)
				(estaEn rosa2 z6)
				(estaEn player1 z2)
				(estaEn player2 z2)
				(estaEn manzana1 z4)
				(estaEn oscar1 z5)
				(estaEn manzana2 z5)
				(estaEn princesa1 z7)
				(estaEn oro1 z7)
				(estaEn oscar2 z7)

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

				(= (puntosTotales) 0)
				(= (distanciaTotal) 0)
				(= (puntosJugador player1) 0)
				(= (distanciaJugador player1) 0)
				(= (puntosJugador player2) 0)
				(= (distanciaJugador player2) 0)

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
				(= (daPuntos princesa1 oscar1) 5)
				(= (daPuntos princesa1 oscar2) 5)
				(= (daPuntos princesa1 algoritmo1) 3)
				(= (daPuntos princesa1 oro1) 4)
				(= (daPuntos princesa1 oro2) 4)
				(= (daPuntos princesa1 rosa2) 10)
				(= (daPuntos bruja1 manzana1) 10)
				(= (daPuntos bruja1 manzana2) 10)
				(= (daPuntos bruja1 oscar1) 4)
				(= (daPuntos bruja1 oscar2) 4)
				(= (daPuntos bruja1 algoritmo1) 1)
				(= (daPuntos bruja1 oro1) 3)
				(= (daPuntos bruja1 oro2) 3)
				(= (daPuntos bruja1 rosa2) 5)

				(= (maxBolsillo bruja1) 4)
				(= (nBolsillo bruja1) 0)
				(= (maxBolsillo princesa1) 5)
				(= (nBolsillo princesa1) 0)
		)

		(:goal (and (>= (puntosJugador player1) 20) (>= (puntosJugador player2) 20) (>= (puntosTotales) 40)))

		(:metric minimize (distanciaTotal))
)