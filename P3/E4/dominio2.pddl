(define (domain zeno-travel)

  (:requirements
    :typing
    :fluents
    :derived-predicates
    :negative-preconditions
    :universal-preconditions
    :disjuntive-preconditions
    :conditional-effects
    :htn-expansion
    :durative-actions
    :metatags
   )

  (:types aircraft person city - object)

  (:constants slow fast - object)

  (:predicates
    (at ?x - (either person aircraft) ?c - city)
    (in ?p - person ?a - aircraft)
    (different ?x ?y)
    (igual ?x ?y)
    (hay-fuel ?a ?c1 ?c2)
    (viaje-rapido-posible ?a ?c1 ?c2)
    (viaje-lento-posible ?a ?c1 ?c2)
    (destino ?x - person ?y - city)
  )

  (:functions
    (fuel ?a - aircraft)
    (distance ?c1 - city ?c2 - city)
    (slow-speed ?a - aircraft)
    (fast-speed ?a - aircraft)
    (slow-burn ?a - aircraft)
    (fast-burn ?a - aircraft)
    (capacity ?a - aircraft)
    (refuel-rate ?a - aircraft)
    (total-fuel-used)
    (boarding-time)
    (debarking-time)
    (fuel-limit)
    (max-people-capacity ?a - aircraft)
    (current-people-capacity ?a - aircraft)

  )

  (:derived (igual ?x ?x) ())

  (:derived (different ?x ?y) (not (igual ?x ?y)))

  (:derived (hay-fuel ?a - aircraft ?c1 - city ?c2 - city) (> (fuel ?a) 1))

  (:derived (viaje-rapido-posible ?a - aircraft ?c1 - city ?c2 - city) (>= (fuel-limit) (+ (total-fuel-used) (* (distance ?c1 ?c2) (fast-burn ?a)))))

  (:derived (viaje-lento-posible ?a - aircraft ?c1 - city ?c2 - city) (>= (fuel-limit) (+ (total-fuel-used) (* (distance ?c1 ?c2) (slow-burn ?a)))))

  (:task transport-person
	  :parameters (?p - person ?c - city)

    ; Si la persona está en la ciudad no hace nada
    (:method Case1
  	  :precondition (at ?p ?c)
  	  :tasks ()
    )

    ; Si la persona no está ciudad destino pero avión y persona están en la misma ciudad
    (:method Case2
	    :precondition (and (at ?p - person ?c1 - city) (at ?a - aircraft ?c1 - city))
	    :tasks (volar ?a ?c1 ?c)
    )

    ; Si la persona no está en ciudad destino y el avión no está en la ciudad de la persona
    (:method Case3
      :precondition (and (at ?p - person ?c1 - city) (at ?a - aircraft ?c2 - city) (different ?c1 - city ?c2 - city))
      :tasks ((volar ?a ?c2 ?c1) (volar ?a ?c1 ?c2))
    )
  )

  ; Un avión ?a vuela de ?c1 a ?c2 metiendo la gente, volando y descargando la gente
  (:task volar
    :parameters (?a - aircraft ?c1 - city ?c2 - city)

    (:method base
      :precondtion ()
      :tasks ((entrar-avion ?a ?c1 ?c2) (mover-avion ?a ?c1 ?c2) (salida-avion ?a ?c2))
    )
  )

  ; Entrada de los pasajeros en el avión
  (:task entrar-avion
    :parameters (?a - aircraft ?c1 - city ?c2 - city)

    ; Si hay gente en la ciudad ?c1 que quiere ir a ?c2 y hay espacio entran en el avión
    (:method queda-gente
      :precondition (and (at ?p - person ?c1 - city) (destino ?p - person ?c2 - city) (> (max-people-capacity ?a - aircraft) (current-people-capacity ?a)))
      :tasks ((board ?p ?a ?c1) (entrar-avion ?a ?c1))
    )

    ; Cuando ya no hay más gente que quiera ir, paras
    (:method sin-gente
      :precondtion ()
      :tasks ()
    )
  )

  ; Salida de los pasajeros del avión
  (:task salida-avion
    :parameters (?a - aircarft ?c - city)

    ; Mientras queda gente en el avión salen
    (:method queda-gente
      :precondtion (in ?p - person ?a - aircraft)
      :tasks ((debark ?p ?a ?c) (salida-avion ?a ?c))
    )

    ; Cuando ya no hay más gente paro
    (:method sin-gente
      :precondtion ()
      :tasks ()
    )
  )

  ; Mueve el avión ?a de ?c1 a ?c2
  (:task mover-avion
   :parameters (?a - aircraft ?c1 - city ?c2 - city)

   ; Comprueba la gasolina y elige el modo de vuelo
   (:method vuela
     :precondition ()
     :tasks ((comprobar-fuel ?a ?c1 ?c2) (modo-vuelo ?a ?c1 ?c2))
   )
  )

  ; Comprueba la gasolina del avion ?a
  (:task comprobar-fuel
    :parameters (?a - aircraft ?c1 - city ?c2 - city)

    ; Si hay fuel suficiente no hace nada
    (:method fuel-suficiente
      :precondition (hay-fuel ?a ?c1 ?c2)
      :tasks ()
    )

    ; Si no hay fuel recarga
    (:method sin-fuel
      :precondition (not (hay-fuel ?a ?c1 ?c2))
      :tasks (refuel ?a ?c1)
    )
  )

  ; Elige el modo de vuelo (si se puede rápido se elige este)
  (:task modo-vuelo
    :parameters (?a - aircraft ?c1 - city ?c2 - city)

    ; Si se puede volar en modo rápido
    (:method vuelo-rapido
      :precondition (viaje-rapido-posible ?a ?c1 ?c2)
      :tasks (zoom ?a ?c1 ?c2)
    )

    ; Si no es posible el viaje rápido comprueba el modo lento
    (:method vuelo-lento
      :precondition (viaje-lento-posible ?a ?c1 ?c2)
      :tasks (fly ?a ?c1 ?c2)
    )
  )

  (:import "Primitivas-Zenotravel2.pddl")
)
