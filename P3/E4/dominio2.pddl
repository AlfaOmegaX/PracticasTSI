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

  (:types constantes city - comparables
          aircraft person comparables - object
  )

  (:constants slow fast - constantes)

  (:predicates
    (igual ?x - comparables ?y - comparables)
    (different ?x - comparables ?y - comparables)
    (at ?x - (either person aircraft) ?c - city)
    (in ?p - person ?a - aircraft)
    (falta-fuel-rapido ?a - aircraft ?c1 - city ?c2 - city)
    (falta-fuel-lento ?a - aircraft ?c1 - city ?c2 - city)
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

  (:derived (igual ?x - comparables ?y - comparables) (= ?x ?y))

  (:derived (different ?x - comparables ?y - comparables) (not (= ?x ?y)))

  (:derived (falta-fuel-rapido ?a - aircraft ?c1 - city ?c2 - city) (< (fuel ?a) (* (distance ?c1 ?c2) (fast-burn ?a))))

  (:derived (falta-fuel-lento ?a - aircraft ?c1 - city ?c2 - city) (< (fuel ?a) (* (distance ?c1 ?c2) (slow-burn ?a))))

  (:derived (viaje-rapido-posible ?a - aircraft ?c1 - city ?c2 - city) (>= (fuel-limit) (+ (total-fuel-used) (* (distance ?c1 ?c2) (fast-burn ?a)))))

  (:derived (viaje-lento-posible ?a - aircraft ?c1 - city ?c2 - city) (>= (fuel-limit) (+ (total-fuel-used) (* (distance ?c1 ?c2) (slow-burn ?a)))))

  (:derived (hay-hueco ?a - aircraft) (> (max-people-capacity ?a) (current-people-capacity ?a)))

  (:derived (aircraft-has-time-slow ?a - aircraft ?c1 - city ?c2 - city) (>= (fly-time-max ?a) (+ (fly-time ?a) (/ (distance ?c1 ?c2) (slow-speed ?a)))))

  (:derived (aircraft-has-time-fast ?a - aircraft ?c1 - city ?c2 - city) (>= (fly-time-max ?a) (+ (fly-time ?a) (/ (distance ?c1 ?c2) (fast-speed ?a)))))

  ; Transporta la persona ?p a ?c
  (:task transport-person
	  :parameters (?p - person ?c - city)

    ; Si la persona está en la ciudad no hace nada
    (:method yaEnCiudad
  	  :precondition (at ?p - person ?c - city)
  	  :tasks ()
    )

    ; Si la persona no está ciudad destino pero avión y persona están en la misma ciudad
    ; Hacemos board para que entre seguro
    (:method avionDondeYo
	    :precondition (and (at ?p - person ?c1 - city) (at ?a - aircraft ?c1 - city))
	    :tasks ((board ?p ?a ?c1) (hacer-vuelo ?a ?c1 ?c))
    )

    ; Si la persona no está en ciudad destino y el avión no está en la ciudad de la persona
    (:method avionOtroLado
      :precondition (and (at ?p - person ?c1 - city) (at ?a - aircraft ?c2 - city) (different ?c1 - city ?c2 - city))
      :tasks ((traer-avion ?c ?c1 ?a ?c2) (transport-person ?p ?c))
    )
  )

  ; Intentamos traer el avión ?a de ?c2 a ?c1 donde está ?p con destino ?c
  (:task traer-avion
    :parameters (?c - city ?c1 - city ?a - aircraft ?c2 - city)

    ; Si hay una persona ?p1 donde está el avión ?a (ciudad ?c2) y va a ?c o a ?c1
    (:method avion-con-persona
      :precondition (and (at ?p1 - person ?c2 - city) (destino ?p1 - person ?c3 - city) (different ?c3 - city ?c2 - city))
      :tasks ((otra-persona ?p1 ?c2 ?a ?c ?c1))
    )

    ; Si no hay personas en la ciudad directamente volamos y ya podemos mover ?p
    (:method mueve-aviones
      :precondition ()
      :tasks ((modo-vuelo ?a ?c2 ?c1))
    )
  )

  ; Que hacer cuando queremos traer el avión ?a en la ciudad ?c2 a la ciudad ?c1
  ; si después se va a ?c, y en ?c2 hay una persona ?p1
  (:task otra-persona
    :parameters (?p1 - person ?c2 - city ?a - aircraft ?c - city ?c1 - city)

    ; Preferencia de ?p1 si va a ?c1 y después ?p1 si va a ?c
    (:method mismo-destino
      :precondition (or (destino ?p1 - person ?c - city) (destino ?p1 - person ?c1 - city))
      :tasks ((entrar-avion ?a ?c2 ?c1) (entrar-avion ?a ?c2 ?c) (hacer-vuelo ?a ?c2 ?c1))
    )

    ; Si ?p1 va a ?c3 (distinto de ?c2 para evitar los q ya están en su ciudad) lo llevamos primero
    (:method diferente-destino
      :precondition (and (destino ?p1 - person ?c3 - city) (different ?c3 - city ?c2 - city))
      :tasks ((transport-person ?p1 ?c3))
    )
  )
  ; Un avión ?a vuela de ?c1 a ?c2 metiendo la gente, volando y descargando la gente
  (:task hacer-vuelo
    :parameters (?a - aircraft ?c1 - city ?c2 - city)

    (:method base
      :precondition ()
      :tasks ((entrar-avion ?a ?c1 ?c2) (modo-vuelo ?a ?c1 ?c2) (salida-avion ?a ?c2))
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
    :parameters (?a - aircraft ?c1 - city ?c2 - city ?o - constantes)

    ; Si le falta gasolina para viajar rápido
    (:method fuel-no-lleno-rapido
      :precondition (and (igual ?o fast) (falta-fuel-rapido ?a ?c1 ?c2))
      :tasks (refuel ?a ?c1)
    )

    ; Si le falta gasolina para viajar lento
    (:method fuel-no-lleno-lento
      :precondition (and (igual ?o slow) (falta-fuel-lento ?a ?c1 ?c2))
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
      :tasks ((comprobar-fuel ?a ?c1 ?c2 fast) (zoom ?a ?c1 ?c2))
    )

    ; Si no es posible el viaje rápido comprueba el modo lento
    (:method vuelo-lento
      :precondition (and (viaje-lento-posible ?a ?c1 ?c2) (aircraft-has-time-slow ?a ?c1 ?c2))
      :tasks ((comprobar-fuel ?a ?c1 ?c2 slow) (fly ?a ?c1 ?c2))
    )
  )

  (:import "Primitivas-Zenotravel2.pddl")
)
