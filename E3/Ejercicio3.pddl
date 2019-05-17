(define (domain Ejercicio3)
    (:requirements :strips :adl :equality :typing :fluents)

    (:types
      Bosque Agua Precipicio Arena Piedra - Zona
      Zapatilla Bikini - ObjetoUsable
      Oscar Manzana Rosa Algoritmo Oro - ObjetoEntregable
      ObjetoUsable ObjetoEntregable - Objeto
      Princesa Principe Bruja Profesor Leonardo - Npc
      Npc Player - Persona
      Persona Objeto - Posicionable
    )

    (:predicates
      (estaEn ?p - Posicionable ?z - Zona)
      (tiene ?p - Persona ?o - Objeto)
      (manoLlena ?j - Player)
      (esBosque ?z - Zona)
      (esAgua ?z - Zona)
      (esPrecipicio ?z - Zona)
      (esZapatilla ?o - Objeto)
      (esBikini ?o - Objeto)
      (enMochila ?j - Player ?o - Objeto)
      (mochilaLlena ?j - Player)
    )

    (:functions
      (conectadas ?z1 - Zona ?z2 - Zona)
      (orientado ?j - Player)
      (distanciaZona ?z1 - Zona ?z2 - Zona)
      (distanciaTotal ?j - Player)
    )

    (:action girarIzquierda
      :parameters (?j - Player)
      :effect (and (when (and (= (orientado ?j) 0))
                      (and (increase (orientado ?j) 3)))
                   (when (and (= (orientado ?j) 1))
                      (and (decrease (orientado ?j) 1)))
                   (when (and (= (orientado ?j) 2))
                      (and (decrease (orientado ?j) 1)))
                   (when (and (= (orientado ?j) 3))
                      (and (decrease (orientado ?j) 1))))
    )

    (:action girarDerecha
      :parameters (?j - Player)
      :effect (and (when (and (= (orientado ?j) 0))
                      (and (increase (orientado ?j) 1)))
                   (when (and (= (orientado ?j) 1))
                      (and (increase (orientado ?j) 1)))
                   (when (and (= (orientado ?j) 2))
                      (and (increase (orientado ?j) 1)))
                   (when (and (= (orientado ?j) 3))
                      (and (decrease (orientado ?j) 3))))
    )

    (:action moverseA
      :parameters (?j - Player ?z1 - Zona ?z2 - Zona ?o - ObjetoUsable)
      :precondition (and (estaEn ?j ?z1) (= (orientado ?j) (conectadas ?z1 ?z2)) (not (esPrecipicio ?z2))
                         (or (not (esBosque ?z2)) (and (esZapatilla ?o) (or (tiene ?j ?o) (enMochila ?j ?o))))
                         (or (not (esAgua ?z2)) (and (esBikini ?o) (or (tiene ?j ?o) (enMochila ?j ?o)))))
      :effect (and (estaEn ?j ?z2) (not (estaEn ?j ?z1)) (increase (distanciaTotal ?j) (distanciaZona ?z1 ?z2)))
    )

    (:action cogerObjeto
      :parameters (?j - Player ?o - Objeto ?z - Zona)
      :precondition (and (estaEn ?j ?z) (estaEn ?o ?z) (not (manoLlena ?j)))
      :effect (and (tiene ?j ?o) (manoLlena ?j) (not (estaEn ?o ?z)))
    )

    (:action dejarObjeto
      :parameters (?j - Player ?o - Objeto ?z - Zona)
      :precondition (and (tiene ?j ?o) (estaEn ?j ?z))
      :effect (and (estaEn ?o ?z) (not (tiene ?j ?o)) (not (manoLlena ?j)))
    )

    (:action entregarObjeto
      :parameters (?j - Player ?p - Npc ?o - ObjetoEntregable ?z - Zona)
      :precondition (and (estaEn ?j ?z) (estaEn ?p ?z) (tiene ?j ?o))
      :effect (and (tiene ?p ?o) (not (tiene ?j ?o)) (not (manoLlena ?j)))
    )

    (:action meterEnMochila
      :parameters (?j - Player ?o - Objeto)
      :precondition (and (not (mochilaLlena ?j)) (tiene ?j ?o))
      :effect (and (mochilaLlena ?j) (enMochila ?j ?o) (not (tiene ?j ?o)) (not (manoLlena ?j)))
    )

    (:action sacarDeMochila
      :parameters (?j - Player ?o - Objeto)
      :precondition (and (enMochila ?j ?o) (not (manoLlena ?j)))
      :effect (and (tiene ?j ?o) (manoLlena ?j) (not (mochilaLlena ?j)) (not (enMochila ?j ?o)))
    )
)
