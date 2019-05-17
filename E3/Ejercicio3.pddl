(define (domain Ejercicio3)
    (:requirements :strips :adl :equality :typing :fluents)

    (:types
        Bosque Agua Precipicio Arena Piedra - Zona
        Orientacion
        Zapatilla Bikini - ObjetoUsable
        Oscar Manzana Rosa Algoritmo Oro - ObjetoEntregable
        ObjetoUsable ObjetoEntregable - Objeto
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
        (esBosque ?z - Zona)
        (esAgua ?z - Zona)
        (estaEn ?p - Posicionable ?z - Zona)
        (tiene ?p - Persona ?o - Objeto)
        (enMochila ?j - Player ?o - Objeto)
        (mochilaLlena ?j - Player)
        (manoLlena ?j - Player)
        (esZapatilla ?o - Objeto)
        (esBikini ?o - Objeto)
        (tieneZapatilla ?j - Player)
        (tieneBikini ?j - Player)
        (tieneZapatillaM ?j - Player)
        (tieneBikiniM ?j - Player)
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
        :precondition (and (orientadoHacia ?j ?oJ) (estanConectadas ?z1 ?z2 ?oZ) (estaEn ?j ?z1) (= ?oZ ?oJ)
                           (or (not (esBosque ?z2)) (tieneZapatilla ?j) (tieneZapatillaM ?j))
                           (or (not (esAgua ?z2)) (tieneBikini ?j) (tieneBikiniM ?j)))
        :effect (and (estaEn ?j ?z2) (not (estaEn ?j ?z1)) (increase (distanciaTotal ?j) (distanciaZona ?z1 ?z2)))
    )

    (:action cogerObjeto
        :parameters (?j - Player ?o - Objeto ?z - Zona)
        :precondition (and (estaEn ?j ?z) (estaEn ?o ?z) (not (manoLlena ?j)))
        :effect (and (tiene ?j ?o) (manoLlena ?j) (not (estaEn ?o ?z))
                     (when (and (esZapatilla ?o))
                        (and (tieneZapatilla ?j)))
                     (when (and (esBikini ?o))
                        (and (tieneBikini ?j))))
    )

    (:action dejarObjeto
        :parameters (?j - Player ?o - Objeto ?z - Zona)
        :precondition (and (tiene ?j ?o) (estaEn ?j ?z))
        :effect (and (estaEn ?o ?z) (not (tiene ?j ?o)) (not (manoLlena ?j))
                     (when (and (esZapatilla ?o))
                        (and (not (tieneZapatilla ?j))))
                     (when (and (esBikini ?o))
                        (and (not (tieneBikini ?j)))))
    )

    (:action entregarObjeto
        :parameters (?j - Player ?p - Npc ?o - ObjetoEntregable ?z - Zona)
        :precondition (and (estaEn ?j ?z) (estaEn ?p ?z) (tiene ?j ?o))
        :effect (and (tiene ?p ?o) (not (tiene ?j ?o)) (not (manoLlena ?j)))
    )

    (:action meterEnMochila
      :parameters (?j - Player ?o - Objeto)
      :precondition (and (not (mochilaLlena ?j)) (tiene ?j ?o))
      :effect (and (mochilaLlena ?j) (enMochila ?j ?o) (not (tiene ?j ?o)) (not (manoLlena ?j))
                   (when (and (esZapatilla ?o))
                      (and (tieneZapatillaM ?j) (not (tieneZapatilla ?j))))
                   (when (and (esBikini ?o))
                      (and (tieneBikiniM ?j) (not (tieneBikini ?j)))))
    )

    (:action sacarDeMochila
      :parameters (?j - Player ?o - Objeto)
      :precondition (and (enMochila ?j ?o) (not (manoLlena ?j)))
      :effect (and (tiene ?j ?o) (manoLlena ?j) (not (mochilaLlena ?j)) (not (enMochila ?j ?o))
                   (when (and (esZapatilla ?o))
                      (and (tieneZapatilla ?j) (not (tieneZapatillaM ?j))))
                   (when (and (esBikini ?o))
                      (and (tieneBikini ?j) (not (tieneBikiniM ?j)))))
    )
)
