(define (problem Problema7)
		(:domain Ejercicio7)

		(:objects
				player2 - Picker
				player1 - Dealer
				princesa1 - Princesa
				bruja1 bruja2 - Bruja
				manzana1 manzana2 manzana3 manzana4 - Manzana
				oscar1 oscar2 - Oscar
				algoritmo1 - Algoritmo
				oro1 oro2 - Oro
				rosa2 rosa3 rosa4 - Rosa
				zapatilla1 zapatilla2 zapatilla2 zapatilla3 - Zapatilla
				bikini1 bikini2 bikini3 - Bikini
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
				(esZapatilla zapatilla2)
				(esZapatilla zapatilla3)
				(esBikini bikini2)
				(esZapatilla zapatilla2)
				(esBosque z2)
				(esBosque z5)
				(esBikini bikini3)
				(esAgua z7)

				(estaEn bruja1 z1)
				(estaEn zapatilla1 z3)
				(estaEn bikini1 z3)
				(estaEn zapatilla2 z3)
				(estaEn algoritmo1 z6)
				(estaEn oro2 z6)
				(estaEn rosa2 z6)
				(estaEn rosa3 z6)
				(estaEn rosa4 z6)
				(estaEn zapatilla3 z6)
				(estaEn player1 z2)
				(estaEn player2 z2)
				(estaEn bikini2 z2)
				(estaEn zapatilla2 z2)
				(estaEn bruja2 z2)
				(estaEn manzana1 z4)
				(estaEn manzana3 z4)
				(estaEn manzana4 z4)
				(estaEn oscar1 z5)
				(estaEn manzana2 z5)
				(estaEn bikini3 z7)
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

				(= (puntosJugador player1) 0)
				(= (puntosTotales) 0)
				(= (distanciaJugador player1) 0)
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
				(= (daPuntos princesa1 manzana3) 1)
				(= (daPuntos princesa1 manzana4) 1)
				(= (daPuntos princesa1 oscar1) 5)
				(= (daPuntos princesa1 oscar2) 5)
				(= (daPuntos princesa1 algoritmo1) 3)
				(= (daPuntos princesa1 oro1) 4)
				(= (daPuntos princesa1 oro2) 4)
				(= (daPuntos princesa1 rosa2) 10)
				(= (daPuntos princesa1 rosa3) 10)
				(= (daPuntos princesa1 rosa4) 10)
				(= (daPuntos bruja1 manzana1) 10)
				(= (daPuntos bruja1 manzana2) 10)
				(= (daPuntos bruja1 manzana3) 10)
				(= (daPuntos bruja1 manzana4) 10)
				(= (daPuntos bruja1 oscar1) 4)
				(= (daPuntos bruja1 oscar2) 4)
				(= (daPuntos bruja1 algoritmo1) 1)
				(= (daPuntos bruja1 oro1) 3)
				(= (daPuntos bruja1 oro2) 3)
				(= (daPuntos bruja1 rosa2) 5)
				(= (daPuntos bruja1 rosa3) 5)
				(= (daPuntos bruja1 rosa4) 5)
				(= (daPuntos bruja2 manzana1) 10)
				(= (daPuntos bruja2 manzana2) 10)
				(= (daPuntos bruja2 manzana3) 10)
				(= (daPuntos bruja2 manzana4) 10)
				(= (daPuntos bruja2 oscar1) 4)
				(= (daPuntos bruja2 oscar2) 4)
				(= (daPuntos bruja2 algoritmo1) 1)
				(= (daPuntos bruja2 oro1) 3)
				(= (daPuntos bruja2 oro2) 3)
				(= (daPuntos bruja2 rosa2) 5)
				(= (daPuntos bruja2 rosa3) 5)
				(= (daPuntos bruja2 rosa4) 5)

				(= (maxBolsillo bruja1) 4)
				(= (nBolsillo bruja1) 0)
				(= (maxBolsillo princesa1) 5)
				(= (nBolsillo princesa1) 0)
				(= (maxBolsillo bruja2) 10)
				(= (nBolsillo bruja2) 0)
		)

		(:goal (and (>= (puntosJugador player1) 20) (>= (puntosTotales) 20)))

		(:metric minimize (distanciaTotal))
)