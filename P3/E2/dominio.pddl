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
    (different ?x - city ?y - city)
    (igual ?x - city ?y - city)
    (falta-fuel ?a - aircraft)
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
  )

  (:derived (igual ?x - city ?y - city) (= ?x ?y))

  (:derived (different ?x - city ?y - city) (not (= ?x ?y)))

  (:derived (falta-fuel ?a - aircraft) (> (capacity ?a) (fuel ?a)))

  ; Lleva a la persona ?p a ?c
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
	    :tasks ((board ?p ?a ?c1) (mover-avion ?a ?c1 ?c) (debark ?p ?a ?c))
    )

    ; Si la persona no está en ciudad destino y el avión no está en la ciudad de la persona
    (:method Case3
      :precondition (and (at ?p - person ?c1 - city) (at ?a - aircraft ?c2 - city) (different ?c1 - city ?c2 - city))
      :tasks ((mover-avion ?a ?c2 ?c1) (transport-person ?p ?c))
    )
  )

  ; Mueve el avión ?a de ?c1 a ?c2
  (:task mover-avion
   :parameters (?a - aircraft ?c1 - city ?c2 - city)

   ; Comprueba el fuel y vuela
   (:method mover
      :precondition ()
      :tasks ((comprobar-fuel ?a ?c1 ?c2) (fly ?a ?c1 ?c2))
   )
  )

  ; Comprueba la gasolina del avion ?a
  (:task comprobar-fuel
    :parameters (?a - aircraft ?c1 - city ?c2 - city)

    ; Si no tiene el depósito lleno recarga
    (:method fuel-no-lleno
      :precondition (falta-fuel ?a)
      :tasks (refuel ?a ?c1)
    )

    ; Si tiene el depósito lleno no hace nada
    (:method fuel-lleno
      :precondition ()
      :tasks ()
    )
  )

  (:import "Primitivas-Zenotravel.pddl")
)
