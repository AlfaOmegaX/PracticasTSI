(define (problem Problema1)
    (:domain Ejercicio1)

    (:objects
        jugador1 - Player
        princesa1 - Princesa
        principe1 - Principe
        leonardo1 - Leonardo
        bruja1 - Bruja
        profesor1 - Profesor
        oscar1 - Oscar
        manzana1 - Manzana
        rosa1 - Rosa
        algoritmo1 - Algoritmo
        oro1 - Oro
        z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12 z13 z14 z15 z16 z17 z18 z19 z20 z21 z22 z23 z24 z25 - Zona
    )

    (:init
        ;; Estado inicial del jugador
        (orientadoHacia jugador1 N)
        (estaEn jugador1 z21)

        ;; Estado inicial de los npcs
        ;;(estaEn princesa1 z1)
        ;;(estaEn principe1 z5)
        ;;(estaEn leonardo1 z21)
        ;:(estaEn bruja1 z25)
        ;;(estaEn profesor1 z12)

        (estaEn princesa1 z7)
        (estaEn principe1 z8)
        (estaEn leonardo1 z9)
        (estaEn bruja1 z12)
        (estaEn profesor1 z18)

        ;; Estado inicial de los objetos
        ;;(estaEn oscar1 z6)
        ;;(estaEn manzana1 z23)
        ;;(estaEn rosa1 z16)
        ;;(estaEn algoritmo1 z7)
        ;;(estaEn oro1 z24)

        (estaEn oscar1 z9)
        (estaEn manzana1 z18)
        (estaEn rosa1 z12)
        (estaEn algoritmo1 z14)
        (estaEn oro1 z13)

        ;; Estado inicial de las zonas
        (estanConectadas z1 z2 E)
        (estanConectadas z2 z1 O)
        (estanConectadas z2 z3 E)
        (estanConectadas z2 z7 S)
        (estanConectadas z3 z2 O)
        (estanConectadas z3 z8 S)
        (estanConectadas z4 z5 E)
        (estanConectadas z4 z9 S)
        (estanConectadas z5 z4 O)
        (estanConectadas z5 z10 S)
        (estanConectadas z6 z11 S)
        (estanConectadas z7 z2 N)
        (estanConectadas z7 z8 E)
        (estanConectadas z7 z12 S)
        (estanConectadas z8 z3 N)
        (estanConectadas z8 z9 E)
        (estanConectadas z8 z7 O)
        (estanConectadas z8 z13 S)
        (estanConectadas z9 z8 O)
        (estanConectadas z9 z4 N)
        (estanConectadas z10 z5 N)
        (estanConectadas z10 z15 S)
        (estanConectadas z11 z6 N)
        (estanConectadas z11 z12 E)
        (estanConectadas z11 z16 S)
        (estanConectadas z12 z7 N)
        (estanConectadas z12 z13 E)
        (estanConectadas z12 z11 O)
        (estanConectadas z13 z8 N)
        (estanConectadas z13 z14 E)
        (estanConectadas z13 z12 O)
        (estanConectadas z13 z18 S)
        (estanConectadas z14 z13 O)
        (estanConectadas z14 z15 E)
        (estanConectadas z15 z10 N)
        (estanConectadas z15 z14 O)
        (estanConectadas z15 z20 S)
        (estanConectadas z16 z11 N)
        (estanConectadas z16 z17 E)
        (estanConectadas z17 z16 O)
        (estanConectadas z17 z22 S)
        (estanConectadas z17 z18 E)
        (estanConectadas z18 z17 O)
        (estanConectadas z18 z13 N)
        (estanConectadas z18 z19 E)
        (estanConectadas z19 z18 O)
        (estanConectadas z19 z20 E)
        (estanConectadas z20 z19 O)
        (estanConectadas z20 z15 N)
        (estanConectadas z20 z25 S)
        (estanConectadas z21 z22 E)
        (estanConectadas z22 z21 O)
        (estanConectadas z22 z17 N)
        (estanConectadas z22 z23 E)
        (estanConectadas z23 z22 O)
        (estanConectadas z23 z24 E)
        (estanConectadas z24 z23 O)
        (estanConectadas z25 z20 N)

    )

    (:goal (and (tiene princesa1 oro1) (tiene principe1 rosa1) (tiene principe1 rosa1)
              (tiene bruja1 manzana1) (tiene profesor1 algoritmo1) (tiene leonardo1 oscar1)))
)
