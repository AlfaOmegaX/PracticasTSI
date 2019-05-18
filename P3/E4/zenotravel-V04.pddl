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
	    :tasks ((board ?p ?a ?c1) (mover-avion ?a ?c1 ?c) (debark ?p ?a ?c))
    )

    ; Si la persona no está en ciudad destino y el avión no está en la ciudad de la persona
    (:method Case3
      :precondition (and (at ?p - person ?c1 - city) (at ?a - aircraft ?c2 - city) (different ?c1 - city ?c2 - city))
      :tasks ((mover-avion ?a ?c2 ?c1) (board ?p ?a ?c1) (mover-avion ?a ?c1 ?c) (debark ?p ?a ?c))
    )
  )

  (:task mover-avion
   :parameters (?a - aircraft ?c1 - city ?c2 - city)

   ; Si no nos pasamos del límite volamos rápido
   (:method vuelo-rapido
      :precondition (viaje-rapido-posible ?a ?c1 ?c2)
      :tasks ((comprobar-fuel ?a ?c1 ?c2) (zoom ?a ?c1 ?c2))
   )

   ; Si no es posible el vuelo rápido se intenta lento si no sobrepasamos el límite
   (:method vuelo-lento
      :precondition (viaje-lento-posible ?a ?c1 ?c2)
      :tasks ((comprobar-fuel ?a ?c1 ?c2) (fly ?a ?c1 ?c2))
   )
  )

  (:task comprobar-fuel
    :parameters (?a -aircraft ?c1 - city ?c2 - city)

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

  (:import "Primitivas-Zenotravel.pddl")
)
