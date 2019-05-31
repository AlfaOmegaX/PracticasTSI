(define (domain zeno-travel)

  (:requirements
    :typing
    :fluents
    :adl
    :strips
    :equality
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
    (igual ?x ?y)
    (different ?x ?y)
    (at ?x - (either person aircraft) ?c - city)
    (in ?p - person ?a - aircraft)
    (falta-fuel ?a - aircraft)
    (viaje-rapido-posible ?a - aircraft ?c1 - city ?c2 - city)
    (viaje-lento-posible ?a - aircraft ?c1 - city ?c2 - city)
    (destino ?x - person ?y - city)
    (hay-hueco ?a - aircraft)
    (aircraft-has-time-slow ?a - aircraft ?c1 - city ?c2 - city)
    (aircraft-has-time-fast ?a - aircraft ?c1 - city ?c2 - city)
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
    (fly-time-max ?a - aircraft)
    (fly-time ?a - aircraft)
  )

  (:derived (igual ?x - city ?y - city) (= ?x ?y))

  (:derived (different ?x - city ?y - city) (not (= ?x ?y)))

  (:derived (falta-fuel ?a - aircraft) (> (capacity ?a) (fuel ?a)))

  (:derived (viaje-rapido-posible ?a - aircraft ?c1 - city ?c2 - city) (>= (fuel-limit) (+ (total-fuel-used) (* (distance ?c1 ?c2) (fast-burn ?a)))))

  (:derived (viaje-lento-posible ?a - aircraft ?c1 - city ?c2 - city) (>= (fuel-limit) (+ (total-fuel-used) (* (distance ?c1 ?c2) (slow-burn ?a)))))

  (:derived (hay-hueco ?a - aircraft) (> (max-people-capacity ?a) (current-people-capacity ?a)))

  (:derived (aircraft-has-time-slow ?a - aircraft ?c1 - city ?c2 - city) (>= (fly-time-max ?a) (+ (fly-time ?a) (/ (distance ?c1 ?c2) (slow-speed ?a)))))

  (:derived (aircraft-has-time-fast ?a - aircraft ?c1 - city ?c2 - city) (>= (fly-time-max ?a) (+ (fly-time ?a) (/ (distance ?c1 ?c2) (fast-speed ?a)))))

  ; Transporta la persona ?p a ?c
  (:task transport-person
	  :parameters (?p - person ?c - city)

    ; Si la persona está en la ciudad no hace nada
    (:method Case1
  	  :precondition (at ?p ?c)
  	  :tasks ()
    )

    ; Si la persona no está ciudad destino pero avión y persona están en la misma ciudad
    ; Hacemos board para que entre seguro
    (:method Case2
	    :precondition (and (at ?p - person ?c1 - city) (at ?a - aircraft ?c1 - city))
	    :tasks ((board ?p ?a ?c1) (hacer-vuelo ?a ?c1 ?c))
    )

    ; Si la persona no está en ciudad destino y el avión no está en la ciudad de la persona
    ; Hacemos board para que entre seguro
    (:method Case3
      :precondition (and (at ?p - person ?c1 - city) (at ?a - aircraft ?c2 - city) (different ?c1 - city ?c2 - city))
      :tasks ((hacer-vuelo ?a ?c2 ?c1) (transport-person ?p ?c))
    )
  )

  ; Un avión ?a vuela de ?c1 a ?c2 metiendo la gente, volando y descargando la gente
  (:task hacer-vuelo
    :parameters (?a - aircraft ?c1 - city ?c2 - city)

    (:method base
      :precondition (different ?c1 ?c2)
      :tasks ((comprobar-fuel ?a ?c1 ?c2) (entrar-avion ?a ?c1 ?c2) (modo-vuelo ?a ?c1 ?c2) (salida-avion ?a ?c2))
    )
  )

  ; Entrada de los pasajeros en el avión
  (:task entrar-avion
    :parameters (?a - aircraft ?c1 - city ?c2 - city)

    ; Si hay gente en la ciudad ?c1 que quiere ir a ?c2 y hay espacio entran en el avión
    (:method queda-gente
      :precondition (and (at ?p - person ?c1 - city) (destino ?p - person ?c2 - city) (hay-hueco ?a - aircraft))
      :tasks ((board ?p ?a ?c1) (entrar-avion ?a ?c1 ?c2))
    )

    ; Cuando ya no hay más gente que quiera ir, paras
    (:method sin-gente
      :precondition ()
      :tasks ()
    )
  )

  ; Salida de los pasajeros del avión
  (:task salida-avion
    :parameters (?a - aircraft ?c - city)

    ; Mientras queda gente en el avión salen
    (:method queda-gente
      :precondition (in ?p - person ?a)
      :tasks ((debark ?p ?a ?c) (salida-avion ?a ?c))
    )

    ; Cuando ya no hay más gente paro
    (:method sin-gente
      :precondition ()
      :tasks ()
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

  ; Elige el modo de vuelo (por defecto rápido)
  (:task modo-vuelo
    :parameters (?a - aircraft ?c1 - city ?c2 - city)

    ; Si se puede volar en modo rápido
    (:method vuelo-rapido
      :precondition (and (viaje-rapido-posible ?a ?c1 ?c2) (aircraft-has-time-fast ?a ?c1 ?c2))
      :tasks (zoom ?a ?c1 ?c2)
    )

    ; Si no es posible el viaje rápido comprueba el modo lento
    (:method vuelo-lento
      :precondition (and (viaje-lento-posible ?a ?c1 ?c2) (aircraft-has-time-slow ?a ?c1 ?c2))
      :tasks (fly ?a ?c1 ?c2)
    )
  )

  (:import "Primitivas-Zenotravel2.pddl")
)
