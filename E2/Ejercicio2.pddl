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

    (:predicates
      (conectadasN ?z1 - Zona ?z2 - Zona)
      (conectadasS ?z1 - Zona ?z2 - Zona)
      (conectadasO ?z1 - Zona ?z2 - Zona)
      (conectadasE ?z1 - Zona ?z2 - Zona)
      (orientadoN ?j - Player)
      (orientadoS ?j - Player)
      (orientadoO ?j - Player)
      (orientadoE ?j - Player)
      (estaEn ?p - Posicionable ?z - Zona)
      (tiene ?p - Persona ?o - Objeto)
      (manoLlena ?j - Player)
    )

    (:functions
      (distanciaZona ?z1 - Zona ?z2 - Zona)
      (distanciaTotal ?j - Player)
    )

    (:action girarIzquierda
      :parameters (?j - Player)
      :effect (and (when (and (orientadoN ?j))
                      (and (orientadoO ?j) (not (orientadoN ?j))))
                   (when (and (orientadoE ?J))
                      (and (orientadoN ?j) (not (orientadoE ?j))))
                   (when (and (orientadoS ?j))
                      (and (orientadoE ?j) (not (orientadoS ?j))))
                   (when (and (orientadoO ?j))
                      (and (orientadoS ?j) (not (orientadoO ?j)))))
    )

    (:action girarDerecha
      :parameters (?j - Player)
      :effect (and (when (and (orientadoN ?j))
                      (and (orientadoE ?j) (not (orientadoN ?j))))
                   (when (and (orientadoE ?J))
                      (and (orientadoS ?j) (not (orientadoE ?j))))
                   (when (and (orientadoS ?j))
                      (and (orientadoO ?j) (not (orientadoS ?j))))
                   (when (and (orientadoO ?j))
                      (and (orientadoN ?j) (not (orientadoO ?j)))))
    )

    (:action moverseA
      :parameters (?j - Player ?z1 - Zona ?z2 - Zona)
      :precondition (and (estaEn ?j ?z1)
                    (or (and (orientadoN ?j) (conectadasN ?z1 ?z2))
                        (and (orientadoE ?j) (conectadasE ?z1 ?z2))
                        (and (orientadoO ?j) (conectadasO ?z1 ?z2))
                        (and (orientadoS ?j) (conectadasS ?z1 ?z2))))
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
