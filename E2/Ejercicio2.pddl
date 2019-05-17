(define (domain Ejercicio2)
    (:requirements :strips :adl :equality :typing :fluents)

    (:types
      Zona
      Oscar Manzana Rosa Algoritmo Oro - Objeto
      Princesa Principe Bruja Profesor Leonardo - Npc
      Npc Player - Persona
      Persona Objeto - Posicionable
    )

    (:predicates
      (estaEn ?p - Posicionable ?z - Zona)
      (tiene ?p - Persona ?o - Objeto)
      (manoLlena ?j - Player)
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
      :parameters (?j - Player ?z1 - Zona ?z2 - Zona)
      :precondition (and (estaEn ?j ?z1) (= (orientado ?j) (conectadas ?z1 ?z2)))
      :effect (and (estaEn ?j ?z2) (not (estaEn ?j ?z1)) (increase (distanciaTotal ?j) (distanciaZona ?z1 ?z2)))
    )

    (:action cogerObjeto
      :parameters (?j - Player ?o - Objeto ?z - Zona)
      :precondition (and (estaEn ?j ?z) (estaEn ?o ?z) (not (manoLlena ?j)))
      :effect (and (tiene ?j ?o) (not (estaEn ?o ?z)) (manoLlena ?j))
    )

    (:action entregarObjeto
      :parameters (?j - Player ?p - Npc ?o - Objeto ?z - Zona)
      :precondition (and (estaEn ?j ?z) (estaEn ?p ?z) (tiene ?j ?o))
      :effect (and (tiene ?p ?o) (not (tiene ?j ?o)) (not (manoLlena ?j)))
    )

    (:action dejarObjeto
      :parameters (?j - Player ?o - Objeto ?z - Zona)
      :precondition (and (tiene ?j ?o) (estaEn ?j ?z))
      :effect (and (estaEn ?o ?z) (not (tiene ?j ?o)) (not (manoLlena ?j)))
    )
)
