(define (domain Ejercicio2)
    (:requirements :strips :adl :equality :typing :fluents)

    (:types
        Zona
        Orientacion
        Oscar Manzana Rosa Algoritmo Oro - Objeto
        Princesa Principe Bruja Profesor Leonardo - Npc
        Npc Player - Persona
        Persona Objeto - Posicionable
    )

    (:constants
        N S O E - Orientacion
    )

    (:predicates
        (estanConectadas ?z1 - Zona ?z2 - Zona ?o - Orientacion)
        (orientadoHacia ?j - Player ?o - Orientacion)
        (estaEn ?p - Posicionable ?z - Zona)
        (tiene ?p - Persona ?o - Objeto)
    )

    (:functions
      (distanciaZona ?z1 - Zona ?z2 - Zona)
      (distanciaTotal ?j - Player)
    )


    (:action girarIzquierda
        :parameters (?j - Player ?o - Orientacion)
        :precondition (and (orientadoHacia ?j ?o))
        :effect (and (when (and (= ?o N))
                        (and (orientadoHacia ?j O)))
                     (when (and (= ?o E))
                        (and (orientadoHacia ?j N)))
                     (when (and (= ?o S))
                        (and (orientadoHacia ?j E)))
                     (when (and (= ?o O))
                        (and (orientadoHacia ?j S)))
                     (not (orientadoHacia ?j ?o)))
    )

    (:action girarDerecha
        :parameters (?j - Player ?o - Orientacion)
        :precondition (and (orientadoHacia ?j ?o))
        :effect (and (when (and (= ?o N))
                        (and (orientadoHacia ?j E)))
                     (when (and (= ?o E))
                        (and (orientadoHacia ?j S)))
                     (when (and (= ?o S))
                        (and (orientadoHacia ?j O)))
                     (when (and (= ?o O))
                        (and (orientadoHacia ?j N)))
                     (not (orientadoHacia ?j ?o)))
    )

    (:action moverseA
        :parameters (?j - Player ?oJ - Orientacion ?z1 - Zona ?z2 - Zona ?oZ - Orientacion)
        :precondition (and (orientadoHacia ?j ?oJ) (estanConectadas ?z1 ?z2 ?oZ) (estaEn ?j ?z1) (= ?oZ ?oJ))
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
