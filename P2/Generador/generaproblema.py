# Imports
import sys
import itertools
import os
import random
import re

# Random seed pero siempre la misma para reproducir los resultados
random.seed(100)

# Recorta de "algo:nombre" obtieniendo nombre
def recortar(cadena):
    return cadena.split(":", 1)[1]
# Si n es un número (float)
def esNumero(n):
    try:
        float(n)
        return True
    except ValueError:
        return False
# -------------------------------------------------------------------------------------------
def parser1(sinSaltos):
    # Lista de items
    lItems = [[], [], [], [], [], [], [], [], [], [], [], []]
    # Texto del programa
    mGeneral = "(define "
    mProblem = "(problem "
    mDomain = "\t\t(:domain "
    mObjects = "\n\t\t(:objects\n"
    mInit = ["\n\t\t(:init\n", "", "", ""]
    mGoal = "\n\t\t(:goal (and"
    # Diccionarios-switch
    switchItem = {"Player": 0, "Profesor": 1, "Principe": 2, "Princesa": 3, "Bruja": 4, "Leonardo": 5, "Manzana": 6, "Oscar": 7, "Algoritmo": 8, "Oro": 9, "Rosa": 10, "Zona": 11}
    switchInver = {v: k for k, v in switchItem.items()}

    # Clasifica el item
    def clasificar(zona, item):
        # Divido entre nombre y tipo de item
        div = item.split("-")
        nombreItem = div[0]
        tipoItem = div[1]
        # Predicado de localización de item
        mInit[2] += "\t\t\t\t(estaEn " + nombreItem + " " + zona + ")\n"
        ind = switchItem[tipoItem]
        # Item añadido para :objects
        lItems[ind].append(nombreItem)
        # Si es el jugador se añade el predicado de orientación
        if tipoItem == "Player":
            mInit[1] += "\t\t\t\t(= (orientado" + " " + nombreItem + ") 0)\n"

    # Nombre del dominio
    nombreDominio = recortar(sinSaltos[0])
    mDomain += nombreDominio + ")\n"
    sinSaltos.pop(0)
    # Nombre del problema
    nombreProblema = recortar(sinSaltos[0])
    mProblem += nombreProblema + ")\n"
    sinSaltos.pop(0);
    # Nº de zonas
    nZonas = recortar(sinSaltos[0])
    sinSaltos.pop(0);

    # Por cada linea leemos las conexiones
    for linea in sinSaltos:
        # Dividimos la línea en los espacios
        divs = linea.split()
        # Guardamos las zonas conectadas y si es vertical u horizontal
        vH = divs.pop(0)
        conexion = []
        divs.pop(0)
        # Separa bien
        acc = -1
        aux = []
        for i in range(0, len(divs)):
            if acc == -1 and divs[i][-1] != "]":
                acc = i
            elif acc != -1 and divs[i][-1] == "]":
                aux.append(" ".join(divs[acc:(i+1)]))
                acc = -1
            elif acc == -1:
                aux.append(divs[i])
        divs = aux

        # Por cada zona guardamos la conexión
        for zona in divs:
            zona = zona.split("[")
            nomZona = zona[0]
            # Si no estaba incluida la zona se incluye junto a los objetos
            if nomZona not in lItems[switchItem["Zona"]]:
                # Sacamos los objetos de la zona y clasificamos
                objs = zona[1].rstrip(']')
                # Añadimos la zona
                lItems[switchItem["Zona"]].append(nomZona)
                # Los objetos
                objs = objs.split()
                for obj in objs:
                    clasificar(nomZona, obj)
            # Añadimos la zona a la conexión
            conexion.append(nomZona)
        # Añadimos la conexión de todas las zonas
        for i in range(0, len(conexion) - 1):
            o1 = o2 = "-1"
            # Si en dirección vertical u horizontal
            if vH == "V":
                o1 = "2"
                o2 = "0"
            elif vH == "H":
                o1 = "1"
                o2 = "3"
            # Si están conectadas lo están en un sentido y en el otro
            mInit[3] += "\t\t\t\t(= (conectadas " + conexion[i] + " " + conexion[i + 1] + ") " + o1 + ")\n"
            mInit[3] += "\t\t\t\t(= (conectadas " + conexion[i + 1] + " " + conexion[i] + ") " + o2 + ")\n"

    # :objects
    for i in range(0, len(lItems)):
        lItems[i].sort()
        aux = " ".join(lItems[i])
        if aux != "":
            mObjects += "\t\t\t\t" + aux + " - " + switchInver[i] + "\n"
    mObjects += "\t\t)\n"

    # :init
    mInit[3] = mInit[3].rstrip("\n")
    mAux = mInit[0]
    for linea in mInit[1:]:
        mAux += linea + "\n"
    mAux += "\t\t)\n"
    mInit = mAux

    # :goal
    gPersonajes = []
    gObjetos = []
    for lPers in lItems[1:6]:
        gPersonajes += lPers
    for lObjs in lItems[6:11]:
        gObjetos += lObjs

    if len(gPersonajes) > len(gObjetos):
        exit("Error: no hay suficientes objetos para los personajes.")
    for personaje in gPersonajes:
        j = random.randint(0, len(gObjetos) - 1)
        mGoal += " (tiene " + personaje + " " + gObjetos[j] + ")"
        gObjetos.pop(j)
    mGoal += "))"

    # Juntamos todas las partes
    mGeneral += mProblem + mDomain + mObjects + mInit + mGoal + "\n)"
    return mGeneral
# -------------------------------------------------------------------------------------------
def parser2(sinSaltos):
    # Lista de items
    lItems = [[], [], [], [], [], [], [], [], [], [], [], []]
    # Texto del programa
    mGeneral = "(define "
    mProblem = "(problem "
    mDomain = "\t\t(:domain "
    mObjects = "\n\t\t(:objects\n"
    mInit = ["\n\t\t(:init\n", "", "", "", "", ""]
    mGoal = "\n\t\t(:goal (and"
    mMetric = "\n\t\t(:metric minimize "
    # Diccionarios-switch
    switchItem = {"Player": 0, "Profesor": 1, "Principe": 2, "Princesa": 3, "Bruja": 4, "Leonardo": 5, "Manzana": 6, "Oscar": 7, "Algoritmo": 8, "Oro": 9, "Rosa": 10, "Zona": 11}
    switchInver = {v: k for k, v in switchItem.items()}

    # Clasifica el item
    def clasificar(zona, item):
        # Divido entre nombre y tipo de item
        div = item.split("-")
        nombreItem = div[0]
        tipoItem = div[1]
        # Predicado de localización de item
        mInit[2] += "\t\t\t\t(estaEn " + nombreItem + " " + zona + ")\n"
        ind = switchItem[tipoItem]
        # Item añadido para :objects
        lItems[ind].append(nombreItem)
        # Si es el jugador se añade el predicado de orientación
        if tipoItem == "Player":
            mInit[1] += "\t\t\t\t(= (orientado" + " " + nombreItem + ") 0)\n"
            mInit[4] += "\t\t\t\t(= (distanciaJugador " + nombreItem + ") 0)\n"

    # Nombre del dominio
    nombreDominio = recortar(sinSaltos[0])
    mDomain += nombreDominio + ")\n"
    sinSaltos.pop(0)
    # Nombre del problema
    nombreProblema = recortar(sinSaltos[0])
    mProblem += nombreProblema + ")\n"
    sinSaltos.pop(0);
    # Nº de zonas
    nZonas = recortar(sinSaltos[0])
    sinSaltos.pop(0);

    # Distancia total inicial
    mInit[4] += "\t\t\t\t(= (distanciaTotal) 0)\n"

    # Por cada linea leemos las conexiones
    for linea in sinSaltos:
        # Guardamos las conexiones y sus distancias
        conexion = []
        distancias = []
        # Dividimos la línea por la flecha
        divs = linea.split("->")
        # Guardamos las zonas conectadas y si es vertical u horizontal
        vH = (divs.pop(0)).rstrip()
        # Quito espacio a la izquierda
        divs[0] = divs[0].strip()
        # Separamos por los "="
        divs = divs[0].split("=")
        # Por cada zona guardamos la conexión y su distancia
        for zona in divs:
            # Si es la distancia entre zonas se añade; si no es una zona
            if esNumero(zona):
                distancias.append(zona)
            else:
                zona = zona.split("[")
                nomZona = zona[0]
                # Si no estaba incluida la zona se incluye junto a los objetos
                if nomZona not in lItems[switchItem["Zona"]]:
                    # Sacamos los objetos de la zona y clasificamos
                    objs = zona[1].rstrip(']')
                    # Añadimos la zona
                    lItems[switchItem["Zona"]].append(nomZona)
                    # Los objetos
                    objs = objs.split()
                    for obj in objs:
                        clasificar(nomZona, obj)
                # Añadimos la zona a la conexión
                conexion.append(nomZona)
        # Añadimos la conexión de todas las zonas
        for i in range(0, len(conexion) - 1):
            o1 = o2 = "-1"
            # Si en dirección vertical u horizontal
            if vH == "V":
                o1 = "2"
                o2 = "0"
            elif vH == "H":
                o1 = "1"
                o2 = "3"
            # Si están conectadas lo están en un sentido y en el otro
            mInit[3] += "\t\t\t\t(= (conectadas " + conexion[i] + " " + conexion[i + 1] + ") " + o1 + ")\n"
            mInit[3] += "\t\t\t\t(= (conectadas " + conexion[i + 1] + " " + conexion[i] + ") " + o2 + ")\n"
            # Añado las distancias
            mInit[5] += "\t\t\t\t(= (distanciaZona " + conexion[i] + " " + conexion[i + 1] + ") " + distancias[i] + ")\n"
            mInit[5] += "\t\t\t\t(= (distanciaZona " + conexion[i + 1] + " " + conexion[i] + ") " + distancias[i] + ")\n"

    # :objects
    for i in range(0, len(lItems)):
        lItems[i].sort()
        lItems[i].sort(key = len)
        aux = " ".join(lItems[i])
        if aux != "":
            mObjects += "\t\t\t\t" + aux + " - " + switchInver[i] + "\n"
    mObjects += "\t\t)\n"

    # :init
    mInit[-1] = mInit[-1].rstrip("\n")
    mAux = mInit[0]
    for linea in mInit[1:]:
        mAux += linea + "\n"
    mAux += "\t\t)\n"
    mInit = mAux

    # :goal
    gPersonajes = []
    gObjetos = []
    for lPers in lItems[1:6]:
        gPersonajes += lPers
    for lObjs in lItems[6:11]:
        gObjetos += lObjs

    # Si no hay suficientes objetos para los personajes falla
    if len(gPersonajes) > len(gObjetos):
        exit("Error: no hay suficientes objetos para los personajes.")
    # Separte objetos aleatorios como objetivos a los perosnajes
    for personaje in gPersonajes:
        j = random.randint(0, len(gObjetos) - 1)
        mGoal += " (tiene " + personaje + " " + gObjetos[j] + ")"
        gObjetos.pop(j)
    mGoal += "))\n"

    # Minizamos la distancia total recorrida
    mMetric += "(distanciaTotal))\n"

    # Juntamos todas las partes
    mGeneral += mProblem + mDomain + mObjects + mInit + mGoal + mMetric + ")"
    return mGeneral
# -------------------------------------------------------------------------------------------
def parser3(sinSaltos):
    # Set de zonas
    sZonas = set()
    # Lista de items
    lItems = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
    # Texto del programa
    mGeneral = "(define "
    mProblem = "(problem "
    mDomain = "\t\t(:domain "
    mObjects = "\n\t\t(:objects\n"
    mInit = ["\n\t\t(:init\n", "", "", "", "", "", ""]
    mGoal = "\n\t\t(:goal (and"
    mMetric = "\n\t\t(:metric minimize "
    # Diccionarios-switch
    switchItem = {"Player": 0, "Profesor": 1, "Principe": 2, "Princesa": 3, "Bruja": 4, "Leonardo": 5, "Manzana": 6, "Oscar": 7, "Algoritmo": 8, "Oro": 9, "Rosa": 10, "Zapatilla": 11, "Bikini": 12, "Bosque": 13, "Agua": 14, "Precipicio": 15, "Arena": 16, "Piedra": 17}
    switchInver = {v: k for k, v in switchItem.items()}

    # Clasifica el item
    def clasificar(zona, nombreItem, tipoItem):
        # Indice del switch
        ind = switchItem[tipoItem]
        # Item añadido para :objects
        lItems[ind].append(nombreItem)
        if tipoItem not in ["Bosque", "Agua", "Precipicio", "Arena", "Piedra"]:
            # Predicado de localización de item
            mInit[3] += "\t\t\t\t(estaEn " + nombreItem + " " + zona + ")\n"
        # Si es el jugador se añade el predicado de orientación
        if tipoItem == "Player":
            mInit[1] += "\t\t\t\t(= (orientado" + " " + nombreItem + ") 0)\n"
            mInit[5] += "\t\t\t\t(= (distanciaJugador " + nombreItem + ") 0)\n"
        # Si es un tipo especial que necesita predicado de es algo
        elif ind in range(11, 16):
            mInit[2] += "\t\t\t\t(es" + tipoItem + " " + nombreItem + ")\n"

    # Nombre del dominio
    nombreDominio = recortar(sinSaltos[0])
    mDomain += nombreDominio + ")\n"
    sinSaltos.pop(0)
    # Nombre del problema
    nombreProblema = recortar(sinSaltos[0])
    mProblem += nombreProblema + ")\n"
    sinSaltos.pop(0);
    # Nº de zonas
    nZonas = recortar(sinSaltos[0])
    sinSaltos.pop(0);
    # Distancia total inicial
    mInit[5] += "\t\t\t\t(= (distanciaTotal) 0)\n"

    # Por cada linea leemos las conexiones
    for linea in sinSaltos:
        # Guardamos las conexiones y sus distancias
        conexion = []
        distancias = []
        # Dividimos la línea por la flecha
        divs = linea.split("->")
        # Guardamos las zonas conectadas y si es vertical u horizontal
        vH = (divs.pop(0)).rstrip()
        # Quito espacio a la izquierda
        divs[0] = divs[0].strip()
        # Separamos por los "="
        divs = divs[0].split("=")
        # Por cada zona guardamos la conexión y su distancia
        for zona in divs:
            # Si es la distancia entre zonas se añade; si no es una zona
            if esNumero(zona): distancias.append(zona)
            else:
                zona = re.split("[\[\]]", zona)
                zona = list(filter(lambda x: x != "", zona))
                nomZona = zona[0]
                # Si no estaba incluida la zona se incluye junto a los objetos
                if nomZona not in sZonas:
                    # Añadimos la zona al set
                    sZonas.add(nomZona)
                    # Sacamos los objetos de la zona y clasificamos
                    if len(zona) > 2:
                        objs = zona[1]
                        # Los objetos
                        objs = objs.split()
                        for obj in objs:
                            dividido = obj.split("-")
                            clasificar(nomZona, dividido[0], dividido[1])
                    clasificar(nomZona, nomZona, zona[-1])
                # Añadimos la zona a la conexión
                conexion.append(nomZona)
        # Añadimos la conexión de todas las zonas
        for i in range(0, len(conexion) - 1):
            o1 = o2 = "-1"
            # Si en dirección vertical u horizontal
            if vH == "V":
                o1 = "2"
                o2 = "0"
            elif vH == "H":
                o1 = "1"
                o2 = "3"
            # Si están conectadas lo están en un sentido y en el otro
            mInit[4] += "\t\t\t\t(= (conectadas " + conexion[i] + " " + conexion[i + 1] + ") " + o1 + ")\n"
            mInit[4] += "\t\t\t\t(= (conectadas " + conexion[i + 1] + " " + conexion[i] + ") " + o2 + ")\n"
            # Añado las distancias
            mInit[6] += "\t\t\t\t(= (distanciaZona " + conexion[i] + " " + conexion[i + 1] + ") " + distancias[i] + ")\n"
            mInit[6] += "\t\t\t\t(= (distanciaZona " + conexion[i + 1] + " " + conexion[i] + ") " + distancias[i] + ")\n"

    # :objects
    for i in range(0, len(lItems)):
        lItems[i].sort()
        lItems[i].sort(key = len)
        aux = " ".join(lItems[i])
        if aux != "":
            mObjects += "\t\t\t\t" + aux + " - " + switchInver[i] + "\n"
    mObjects += "\t\t)\n"

    # :init
    mInit[-1] = mInit[-1].rstrip("\n")
    mAux = mInit[0]
    for linea in mInit[1:]:
        mAux += linea + "\n"
    mAux += "\t\t)\n"
    mInit = mAux

    # :goal
    gPersonajes = []
    gObjetos = []
    for lPers in lItems[1:6]:
        gPersonajes += lPers
    for lObjs in lItems[6:11]:
        gObjetos += lObjs

    # Si no hay suficientes objetos para los personajes falla
    if len(gPersonajes) > len(gObjetos):
        exit("Error: no hay suficientes objetos para los personajes.")
    # Separte objetos aleatorios como objetivos a los perosnajes
    for personaje in gPersonajes:
        j = random.randint(0, len(gObjetos) - 1)
        mGoal += " (tiene " + personaje + " " + gObjetos[j] + ")"
        gObjetos.pop(j)
    mGoal += "))\n"

    # Minimizamos la distancia total recorrida
    mMetric += "(distanciaTotal))\n"

    # Juntamos todas las partes
    mGeneral += mProblem + mDomain + mObjects + mInit + mGoal + mMetric + ")"
    return mGeneral
# -------------------------------------------------------------------------------------------
def parser4(sinSaltos):
    # Set de zonas
    sZonas = set()
    # Lista de items
    lItems = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
    # Texto del programa
    mGeneral = "(define "
    mProblem = "(problem "
    mDomain = "\t\t(:domain "
    mObjects = "\n\t\t(:objects\n"
    mInit = ["\n\t\t(:init\n", "", "", "", "", "", "", ""]
    mGoal = "\n\t\t(:goal (and "
    mMetric = "\n\t\t(:metric minimize "
    # Diccionarios-switch
    switchItem = {"Player": 0, "Profesor": 1, "Principe": 2, "Princesa": 3, "Bruja": 4, "Leonardo": 5, "Manzana": 6, "Oscar": 7, "Algoritmo": 8, "Oro": 9, "Rosa": 10, "Zapatilla": 11, "Bikini": 12, "Bosque": 13, "Agua": 14, "Precipicio": 15, "Arena": 16, "Piedra": 17}
    switchInver = {v: k for k, v in switchItem.items()}
    switchPuntos = {(0, 0): 5, (0, 1): 3, (0, 2): 10, (0, 3): 1, (0, 4): 4, (1, 0): 4, (1, 1): 1, (1, 2): 5, (1, 3): 10, (1, 4): 3, (2, 0): 1, (2, 1): 5, (2, 2): 3, (2, 3): 4, (2, 4): 10, (3, 0): 10, (3, 1): 4, (3, 2): 1, (3, 3): 3, (3, 4): 5, (4, 0): 3, (4, 1): 10, (4, 2): 4, (4, 3): 4, (4, 4): 1}

    # Clasifica el item
    def clasificar(zona, nombreItem, tipoItem):
        # Indice del switch
        ind = switchItem[tipoItem]
        # Item añadido para :objects
        lItems[ind].append(nombreItem)
        if tipoItem not in ["Bosque", "Agua", "Precipicio", "Arena", "Piedra"]:
            # Predicado de localización de item
            mInit[3] += "\t\t\t\t(estaEn " + nombreItem + " " + zona + ")\n"
        # Si es el jugador se añade el predicado de orientación
        if tipoItem == "Player":
            mInit[1] += "\t\t\t\t(= (orientado" + " " + nombreItem + ") 0)\n"
            mInit[5] += "\t\t\t\t(= (puntosJugador " + nombreItem + ") 0)\n"
            mInit[5] += "\t\t\t\t(= (distanciaJugador " + nombreItem + ") 0)\n"
        # Si es un tipo especial que necesita predicado de es algo
        elif ind in range(11, 16):
            mInit[2] += "\t\t\t\t(es" + tipoItem + " " + nombreItem + ")\n"

    # Nombre del dominio
    nombreDominio = recortar(sinSaltos[0])
    mDomain += nombreDominio + ")\n"
    sinSaltos.pop(0)
    # Nombre del problema
    nombreProblema = recortar(sinSaltos[0])
    mProblem += nombreProblema + ")\n"
    sinSaltos.pop(0)
    # Nº de zonas
    nZonas = recortar(sinSaltos[0])
    sinSaltos.pop(0)
    # Puntos totales
    pTotales = recortar(sinSaltos[0])
    sinSaltos.pop(0)
    # Distancia total inicial
    mInit[5] += "\t\t\t\t(= (distanciaTotal) 0)\n"
    mInit[5] += "\t\t\t\t(= (puntosTotales) 0)\n"

    # Por cada linea leemos las conexiones
    for linea in sinSaltos:
        # Guardamos las conexiones y sus distancias
        conexion = []
        distancias = []
        # Dividimos la línea por la flecha
        divs = linea.split("->")
        # Guardamos las zonas conectadas y si es vertical u horizontal
        vH = (divs.pop(0)).rstrip()
        # Quito espacio a la izquierda
        divs[0] = divs[0].strip()
        # Separamos por los "="
        divs = divs[0].split("=")
        # Por cada zona guardamos la conexión y su distancia
        for zona in divs:
            # Si es la distancia entre zonas se añade; si no es una zona
            if esNumero(zona): distancias.append(zona)
            else:
                zona = re.split("[\[\]]", zona)
                zona = list(filter(lambda x: x != "", zona))
                nomZona = zona[0]
                # Si no estaba incluida la zona se incluye junto a los objetos
                if nomZona not in sZonas:
                    # Añadimos la zona al set
                    sZonas.add(nomZona)
                    # Sacamos los objetos de la zona y clasificamos
                    if len(zona) > 2:
                        objs = zona[1]
                        # Los objetos
                        objs = objs.split()
                        for obj in objs:
                            dividido = obj.split("-")
                            clasificar(nomZona, dividido[0], dividido[1])
                    clasificar(nomZona, nomZona, zona[-1])
                # Añadimos la zona a la conexión
                conexion.append(nomZona)
        # Añadimos la conexión de todas las zonas
        for i in range(0, len(conexion) - 1):
            o1 = o2 = "-1"
            # Si en dirección vertical u horizontal
            if vH == "V":
                o1 = "2"
                o2 = "0"
            elif vH == "H":
                o1 = "1"
                o2 = "3"
            # Si están conectadas lo están en un sentido y en el otro
            mInit[4] += "\t\t\t\t(= (conectadas " + conexion[i] + " " + conexion[i + 1] + ") " + o1 + ")\n"
            mInit[4] += "\t\t\t\t(= (conectadas " + conexion[i + 1] + " " + conexion[i] + ") " + o2 + ")\n"
            # Añado las distancias
            mInit[6] += "\t\t\t\t(= (distanciaZona " + conexion[i] + " " + conexion[i + 1] + ") " + distancias[i] + ")\n"
            mInit[6] += "\t\t\t\t(= (distanciaZona " + conexion[i + 1] + " " + conexion[i] + ") " + distancias[i] + ")\n"

    # :objects
    for i in range(0, len(lItems)):
        lItems[i].sort()
        lItems[i].sort(key = len)
        aux = " ".join(lItems[i])
        if aux != "":
            mObjects += "\t\t\t\t" + aux + " - " + switchInver[i] + "\n"
    mObjects += "\t\t)\n"

    # :init
    # Añado los valores de recompensa
    lPersonajes = lItems[1:6]
    lObjetos = lItems[6:11]
    for i in range(0, len(lPersonajes)):
        for pers in lPersonajes[i]:
            for j in range(0, len(lObjetos)):
                for item in lObjetos[j]:
                    mInit[7] += "\t\t\t\t(= (daPuntos " + pers + " " + item + ") " + str(switchPuntos[(i, j)]) + ")\n"

    mInit[-1] = mInit[-1].rstrip("\n")
    mAux = mInit[0]
    for linea in mInit[1:]:
        mAux += linea + "\n"
    mAux += "\t\t)\n"
    mInit = mAux

    # :goal
    mGoal += "(>= (puntosTotales) " + pTotales + ")))\n"

    # :metric (minimizar distancia total)
    mMetric += "(distanciaTotal))\n"

    # Juntamos todas las partes
    mGeneral += mProblem + mDomain + mObjects + mInit + mGoal + mMetric + ")"
    return mGeneral
# -------------------------------------------------------------------------------------------
def parser5(sinSaltos):
    # Set de zonas
    sZonas = set()
    # Lista de items
    lItems = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
    # Texto del programa
    mGeneral = "(define "
    mProblem = "(problem "
    mDomain = "\t\t(:domain "
    mObjects = "\n\t\t(:objects\n"
    mInit = ["\n\t\t(:init\n", "", "", "", "", "", "", "", ""]
    mGoal = "\n\t\t(:goal (and "
    mMetric = "\n\t\t(:metric minimize "
    # Diccionarios-switch
    switchItem = {"Player": 0, "Profesor": 1, "Principe": 2, "Princesa": 3, "Bruja": 4, "Leonardo": 5, "Manzana": 6, "Oscar": 7, "Algoritmo": 8, "Oro": 9, "Rosa": 10, "Zapatilla": 11, "Bikini": 12, "Bosque": 13, "Agua": 14, "Precipicio": 15, "Arena": 16, "Piedra": 17}
    switchInver = {v: k for k, v in switchItem.items()}
    switchPuntos = {(0, 0): 5, (0, 1): 3, (0, 2): 10, (0, 3): 1, (0, 4): 4, (1, 0): 4, (1, 1): 1, (1, 2): 5, (1, 3): 10, (1, 4): 3, (2, 0): 1, (2, 1): 5, (2, 2): 3, (2, 3): 4, (2, 4): 10, (3, 0): 10, (3, 1): 4, (3, 2): 1, (3, 3): 3, (3, 4): 5, (4, 0): 3, (4, 1): 10, (4, 2): 4, (4, 3): 4, (4, 4): 1}

    # Clasifica el item
    def clasificar(zona, nombreItem, tipoItem):
        # Indice del switch
        ind = switchItem[tipoItem]
        # Item añadido para :objects
        lItems[ind].append(nombreItem)
        if tipoItem not in ["Bosque", "Agua", "Precipicio", "Arena", "Piedra"]:
            # Predicado de localización de item
            mInit[3] += "\t\t\t\t(estaEn " + nombreItem + " " + zona + ")\n"
        # Si es el jugador se añade el predicado de orientación
        if tipoItem == "Player":
            mInit[1] += "\t\t\t\t(= (orientado" + " " + nombreItem + ") 0)\n"
            mInit[5] += "\t\t\t\t(= (puntosJugador " + nombreItem + ") 0)\n"
            mInit[5] += "\t\t\t\t(= (distanciaJugador " + nombreItem + ") 0)\n"
        # Si es un tipo especial que necesita predicado de es algo
        elif ind in range(11, 16):
            mInit[2] += "\t\t\t\t(es" + tipoItem + " " + nombreItem + ")\n"

    # Nombre del dominio
    nombreDominio = recortar(sinSaltos[0])
    mDomain += nombreDominio + ")\n"
    sinSaltos.pop(0)
    # Nombre del problema
    nombreProblema = recortar(sinSaltos[0])
    mProblem += nombreProblema + ")\n"
    sinSaltos.pop(0)
    # Nº de zonas
    nZonas = recortar(sinSaltos[0])
    sinSaltos.pop(0)
    # Bolsillos
    bolsillos = recortar(sinSaltos[0]).rstrip("]").strip("[").split()
    for linea in bolsillos:
        linea = linea.split(":")
        nNpc = linea[0]
        nMaxB = linea[1]
        mInit[8] += "\t\t\t\t(= (maxBolsillo " + nNpc + ") " + nMaxB + ")\n"
        mInit[8] += "\t\t\t\t(= (nBolsillo " + nNpc + ") 0)\n"
    sinSaltos.pop(0)
    # Puntos totales
    pTotales = recortar(sinSaltos[0])
    sinSaltos.pop(0)
    # Distancia mínima inicial
    mInit[5] += "\t\t\t\t(= (distanciaTotal) 0)\n"
    mInit[5] += "\t\t\t\t(= (puntosTotales) 0)\n"

    # Por cada linea leemos las conexiones
    for linea in sinSaltos:
        # Guardamos las conexiones y sus distancias
        conexion = []
        distancias = []
        # Dividimos la línea por la flecha
        divs = linea.split("->")
        # Guardamos las zonas conectadas y si es vertical u horizontal
        vH = (divs.pop(0)).rstrip()
        # Quito espacio a la izquierda
        divs[0] = divs[0].strip()
        # Separamos por los "="
        divs = divs[0].split("=")
        # Por cada zona guardamos la conexión y su distancia
        for zona in divs:
            # Si es la distancia entre zonas se añade; si no es una zona
            if esNumero(zona): distancias.append(zona)
            else:
                zona = re.split("[\[\]]", zona)
                zona = list(filter(lambda x: x != "", zona))
                nomZona = zona[0]
                # Si no estaba incluida la zona se incluye junto a los objetos
                if nomZona not in sZonas:
                    # Añadimos la zona al set
                    sZonas.add(nomZona)
                    # Sacamos los objetos de la zona y clasificamos
                    if len(zona) > 2:
                        objs = zona[1]
                        # Los objetos
                        objs = objs.split()
                        for obj in objs:
                            dividido = obj.split("-")
                            clasificar(nomZona, dividido[0], dividido[1])
                    clasificar(nomZona, nomZona, zona[-1])
                # Añadimos la zona a la conexión
                conexion.append(nomZona)
        # Añadimos la conexión de todas las zonas
        for i in range(0, len(conexion) - 1):
            o1 = o2 = "-1"
            # Si en dirección vertical u horizontal
            if vH == "V":
                o1 = "2"
                o2 = "0"
            elif vH == "H":
                o1 = "1"
                o2 = "3"
            # Si están conectadas lo están en un sentido y en el otro
            mInit[4] += "\t\t\t\t(= (conectadas " + conexion[i] + " " + conexion[i + 1] + ") " + o1 + ")\n"
            mInit[4] += "\t\t\t\t(= (conectadas " + conexion[i + 1] + " " + conexion[i] + ") " + o2 + ")\n"
            # Añado las distancias
            mInit[6] += "\t\t\t\t(= (distanciaZona " + conexion[i] + " " + conexion[i + 1] + ") " + distancias[i] + ")\n"
            mInit[6] += "\t\t\t\t(= (distanciaZona " + conexion[i + 1] + " " + conexion[i] + ") " + distancias[i] + ")\n"

    # :objects
    for i in range(0, len(lItems)):
        lItems[i].sort()
        lItems[i].sort(key = len)
        aux = " ".join(lItems[i])
        if aux != "":
            mObjects += "\t\t\t\t" + aux + " - " + switchInver[i] + "\n"
    mObjects += "\t\t)\n"

    # :init
    # Añado los valores de recompensa
    lPersonajes = lItems[1:6]
    lObjetos = lItems[6:11]
    for i in range(0, len(lPersonajes)):
        for pers in lPersonajes[i]:
            for j in range(0, len(lObjetos)):
                for item in lObjetos[j]:
                    mInit[7] += "\t\t\t\t(= (daPuntos " + pers + " " + item + ") " + str(switchPuntos[(i, j)]) + ")\n"


    mInit[-1] = mInit[-1].rstrip("\n")
    mAux = mInit[0]
    for linea in mInit[1:]:
        mAux += linea + "\n"
    mAux += "\t\t)\n"
    mInit = mAux

    # :metric (minimizar distancia total)
    mMetric += "(distanciaTotal))\n"
    # :goal
    mGoal += "(>= (puntosTotales) " + pTotales + ")))\n"

    # Juntamos todas las partes
    mGeneral += mProblem + mDomain + mObjects + mInit + mGoal + mMetric + ")"
    return mGeneral
# -------------------------------------------------------------------------------------------
def parser6(sinSaltos):
    # Set de zonas
    sZonas = set()
    # Lista de items
    lItems = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
    # Texto del programa
    mGeneral = "(define "
    mProblem = "(problem "
    mDomain = "\t\t(:domain "
    mObjects = "\n\t\t(:objects\n"
    mInit = ["\n\t\t(:init\n", "", "", "", "", "", "", "", ""]
    mGoal = "\n\t\t(:goal (and "
    mMetric = "\n\t\t(:metric minimize "
    # Diccionarios-switch
    switchItem = {"Player": 0, "Profesor": 1, "Principe": 2, "Princesa": 3, "Bruja": 4, "Leonardo": 5, "Manzana": 6, "Oscar": 7, "Algoritmo": 8, "Oro": 9, "Rosa": 10, "Zapatilla": 11, "Bikini": 12, "Bosque": 13, "Agua": 14, "Precipicio": 15, "Arena": 16, "Piedra": 17}
    switchInver = {v: k for k, v in switchItem.items()}
    switchPuntos = {(0, 0): 5, (0, 1): 3, (0, 2): 10, (0, 3): 1, (0, 4): 4, (1, 0): 4, (1, 1): 1, (1, 2): 5, (1, 3): 10, (1, 4): 3, (2, 0): 1, (2, 1): 5, (2, 2): 3, (2, 3): 4, (2, 4): 10, (3, 0): 10, (3, 1): 4, (3, 2): 1, (3, 3): 3, (3, 4): 5, (4, 0): 3, (4, 1): 10, (4, 2): 4, (4, 3): 4, (4, 4): 1}

    # Clasifica el item
    def clasificar(zona, nombreItem, tipoItem):
        # Indice del switch
        ind = switchItem[tipoItem]
        # Item añadido para :objects
        lItems[ind].append(nombreItem)
        if tipoItem not in ["Bosque", "Agua", "Precipicio", "Arena", "Piedra"]:
            # Predicado de localización de item
            mInit[3] += "\t\t\t\t(estaEn " + nombreItem + " " + zona + ")\n"
        # Si es el jugador se añade el predicado de orientación
        if tipoItem == "Player":
            mInit[1] += "\t\t\t\t(= (orientado" + " " + nombreItem + ") 0)\n"
            mInit[5] += "\t\t\t\t(= (puntosJugador " + nombreItem + ") 0)\n"
            mInit[5] += "\t\t\t\t(= (distanciaJugador " + nombreItem + ") 0)\n"
        # Si es un tipo especial que necesita predicado de es algo
        elif ind in range(11, 16):
            mInit[2] += "\t\t\t\t(es" + tipoItem + " " + nombreItem + ")\n"

    # Nombre del dominio
    nombreDominio = recortar(sinSaltos[0])
    mDomain += nombreDominio + ")\n"
    sinSaltos.pop(0)
    # Nombre del problema
    nombreProblema = recortar(sinSaltos[0])
    mProblem += nombreProblema + ")\n"
    sinSaltos.pop(0)
    # Nº de zonas
    nZonas = recortar(sinSaltos[0])
    sinSaltos.pop(0)
    # Bolsillos
    bolsillos = recortar(sinSaltos[0]).rstrip("]").strip("[").split()
    for linea in bolsillos:
        linea = linea.split(":")
        nNpc = linea[0]
        nMaxB = linea[1]
        mInit[8] += "\t\t\t\t(= (maxBolsillo " + nNpc + ") " + nMaxB + ")\n"
        mInit[8] += "\t\t\t\t(= (nBolsillo " + nNpc + ") 0)\n"
    sinSaltos.pop(0)
    # Puntos totales
    pTotales = recortar(sinSaltos[0])
    sinSaltos.pop(0)
    # Puntos por jugador
    pJugadores = recortar(sinSaltos[0]).rstrip("]").strip("[").split()
    sinSaltos.pop(0)
    for linea in pJugadores:
        linea = linea.split(":")
        nJug = linea[0]
        pJug = linea[1]
        mGoal += "(>= (puntosJugador " + nJug + ") " + pJug + ") "
    # :goal
    mGoal += "(>= (puntosTotales) " + pTotales + ")))\n"
    mInit[5] += "\t\t\t\t(= (puntosTotales) 0)\n"
    mInit[5] += "\t\t\t\t(= (distanciaTotal) 0)\n"

    # Por cada linea leemos las conexiones
    for linea in sinSaltos:
        # Guardamos las conexiones y sus distancias
        conexion = []
        distancias = []
        # Dividimos la línea por la flecha
        divs = linea.split("->")
        # Guardamos las zonas conectadas y si es vertical u horizontal
        vH = (divs.pop(0)).rstrip()
        # Quito espacio a la izquierda
        divs[0] = divs[0].strip()
        # Separamos por los "="
        divs = divs[0].split("=")
        # Por cada zona guardamos la conexión y su distancia
        for zona in divs:
            # Si es la distancia entre zonas se añade; si no es una zona
            if esNumero(zona): distancias.append(zona)
            else:
                zona = re.split("[\[\]]", zona)
                zona = list(filter(lambda x: x != "", zona))
                nomZona = zona[0]
                # Si no estaba incluida la zona se incluye junto a los objetos
                if nomZona not in sZonas:
                    # Añadimos la zona al set
                    sZonas.add(nomZona)
                    # Sacamos los objetos de la zona y clasificamos
                    if len(zona) > 2:
                        objs = zona[1]
                        # Los objetos
                        objs = objs.split()
                        for obj in objs:
                            dividido = obj.split("-")
                            clasificar(nomZona, dividido[0], dividido[1])
                    clasificar(nomZona, nomZona, zona[-1])
                # Añadimos la zona a la conexión
                conexion.append(nomZona)
        # Añadimos la conexión de todas las zonas
        for i in range(0, len(conexion) - 1):
            o1 = o2 = "-1"
            # Si en dirección vertical u horizontal
            if vH == "V":
                o1 = "2"
                o2 = "0"
            elif vH == "H":
                o1 = "1"
                o2 = "3"
            # Si están conectadas lo están en un sentido y en el otro
            mInit[4] += "\t\t\t\t(= (conectadas " + conexion[i] + " " + conexion[i + 1] + ") " + o1 + ")\n"
            mInit[4] += "\t\t\t\t(= (conectadas " + conexion[i + 1] + " " + conexion[i] + ") " + o2 + ")\n"
            # Añado las distancias
            mInit[6] += "\t\t\t\t(= (distanciaZona " + conexion[i] + " " + conexion[i + 1] + ") " + distancias[i] + ")\n"
            mInit[6] += "\t\t\t\t(= (distanciaZona " + conexion[i + 1] + " " + conexion[i] + ") " + distancias[i] + ")\n"

    # :objects
    for i in range(0, len(lItems)):
        lItems[i].sort()
        lItems[i].sort(key = len)
        aux = " ".join(lItems[i])
        if aux != "":
            mObjects += "\t\t\t\t" + aux + " - " + switchInver[i] + "\n"
    mObjects += "\t\t)\n"

    # :init
    # Añado los valores de recompensa
    lPersonajes = lItems[1:6]
    lObjetos = lItems[6:11]
    for i in range(0, len(lPersonajes)):
        for pers in lPersonajes[i]:
            for j in range(0, len(lObjetos)):
                for item in lObjetos[j]:
                    mInit[7] += "\t\t\t\t(= (daPuntos " + pers + " " + item + ") " + str(switchPuntos[(i, j)]) + ")\n"

    mInit[-1] = mInit[-1].rstrip("\n")
    mAux = mInit[0]
    for linea in mInit[1:]:
        mAux += linea + "\n"
    mAux += "\t\t)\n"
    mInit = mAux

    # :metric (minimizar distancia total)
    mMetric += "(distanciaTotal))\n"

    # Juntamos todas las partes
    mGeneral += mProblem + mDomain + mObjects + mInit + mGoal + mMetric + ")"
    return mGeneral
# -------------------------------------------------------------------------------------------
def parser7(sinSaltos):
    # Set de zonas
    sZonas = set()
    # Lista de items
    lItems = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
    # Texto del programa
    mGeneral = "(define "
    mProblem = "(problem "
    mDomain = "\t\t(:domain "
    mObjects = "\n\t\t(:objects\n"
    mInit = ["\n\t\t(:init\n", "", "", "", "", "", "", "", ""]
    mGoal = "\n\t\t(:goal (and "
    mMetric = "\n\t\t(:metric minimize "
    # Diccionarios-switch
    switchItem = {"Picker": 0, "Dealer": 1, "Profesor": 2, "Principe": 3, "Princesa": 4, "Bruja": 5, "Leonardo": 6, "Manzana": 7, "Oscar": 8, "Algoritmo": 9, "Oro": 10, "Rosa": 11, "Zapatilla": 12, "Bikini": 13, "Bosque": 14, "Agua": 15, "Precipicio": 16, "Arena": 17, "Piedra": 18}
    switchInver = {v: k for k, v in switchItem.items()}
    switchPuntos = {(0, 0): 5, (0, 1): 3, (0, 2): 10, (0, 3): 1, (0, 4): 4, (1, 0): 4, (1, 1): 1, (1, 2): 5, (1, 3): 10, (1, 4): 3, (2, 0): 1, (2, 1): 5, (2, 2): 3, (2, 3): 4, (2, 4): 10, (3, 0): 10, (3, 1): 4, (3, 2): 1, (3, 3): 3, (3, 4): 5, (4, 0): 3, (4, 1): 10, (4, 2): 4, (4, 3): 4, (4, 4): 1}

    # Clasifica el item
    def clasificar(zona, nombreItem, tipoItem):
        # Indice del switch
        ind = switchItem[tipoItem]
        # Item añadido para :objects
        lItems[ind].append(nombreItem)
        if tipoItem not in ["Bosque", "Agua", "Precipicio", "Arena", "Piedra"]:
            # Predicado de localización de item
            mInit[3] += "\t\t\t\t(estaEn " + nombreItem + " " + zona + ")\n"
        # Si es el jugador se añade el predicado de orientación
        # TODO
        if tipoItem in ["Picker", "Dealer"]:
            mInit[1] += "\t\t\t\t(= (orientado" + " " + nombreItem + ") 0)\n"
            mInit[5] += "\t\t\t\t(= (distanciaJugador " + nombreItem + ") 0)\n"

        # Si es un tipo especial que necesita predicado de es algo
        elif ind in range(12, 17):
            mInit[2] += "\t\t\t\t(es" + tipoItem + " " + nombreItem + ")\n"

    # Nombre del dominio
    nombreDominio = recortar(sinSaltos[0])
    mDomain += nombreDominio + ")\n"
    sinSaltos.pop(0)
    # Nombre del problema
    nombreProblema = recortar(sinSaltos[0])
    mProblem += nombreProblema + ")\n"
    sinSaltos.pop(0)
    # Nº de zonas
    nZonas = recortar(sinSaltos[0])
    sinSaltos.pop(0)
    # Bolsillos
    bolsillos = recortar(sinSaltos[0]).rstrip("]").strip("[").split()
    for linea in bolsillos:
        linea = linea.split(":")
        nNpc = linea[0]
        nMaxB = linea[1]
        mInit[8] += "\t\t\t\t(= (maxBolsillo " + nNpc + ") " + nMaxB + ")\n"
        mInit[8] += "\t\t\t\t(= (nBolsillo " + nNpc + ") 0)\n"
    sinSaltos.pop(0)
    # Puntos totales
    pTotales = recortar(sinSaltos[0])
    sinSaltos.pop(0)
    # Puntos por jugador
    pJugadores = recortar(sinSaltos[0]).rstrip("]").strip("[").split()
    sinSaltos.pop(0)
    for linea in pJugadores:
        linea = linea.split(":")
        nJug = linea[0]
        pJug = linea[1]
        mGoal += "(>= (puntosJugador " + nJug + ") " + pJug + ") "
        mInit[5] += "\t\t\t\t(= (puntosJugador " + nJug + ") 0)\n"
    # :goal
    mGoal += "(>= (puntosTotales) " + pTotales + ")))\n"
    mInit[5] += "\t\t\t\t(= (puntosTotales) 0)\n"
    mInit[5] += "\t\t\t\t(= (distanciaTotal) 0)\n"

    # Por cada linea leemos las conexiones
    for linea in sinSaltos:
        # Guardamos las conexiones y sus distancias
        conexion = []
        distancias = []
        # Dividimos la línea por la flecha
        divs = linea.split("->")
        # Guardamos las zonas conectadas y si es vertical u horizontal
        vH = (divs.pop(0)).rstrip()
        # Quito espacio a la izquierda
        divs[0] = divs[0].strip()
        # Separamos por los "="
        divs = divs[0].split("=")
        # Por cada zona guardamos la conexión y su distancia
        for zona in divs:
            # Si es la distancia entre zonas se añade; si no es una zona
            if esNumero(zona): distancias.append(zona)
            else:
                zona = re.split("[\[\]]", zona)
                zona = list(filter(lambda x: x != "", zona))
                nomZona = zona[0]
                # Si no estaba incluida la zona se incluye junto a los objetos
                if nomZona not in sZonas:
                    # Añadimos la zona al set
                    sZonas.add(nomZona)
                    # Sacamos los objetos de la zona y clasificamos
                    if len(zona) > 2:
                        objs = zona[1]
                        # Los objetos
                        objs = objs.split()
                        for obj in objs:
                            dividido = obj.split("-")
                            clasificar(nomZona, dividido[0], dividido[1])
                    clasificar(nomZona, nomZona, zona[-1])
                # Añadimos la zona a la conexión
                conexion.append(nomZona)
        # Añadimos la conexión de todas las zonas
        for i in range(0, len(conexion) - 1):
            o1 = o2 = "-1"
            # Si en dirección vertical u horizontal
            if vH == "V":
                o1 = "2"
                o2 = "0"
            elif vH == "H":
                o1 = "1"
                o2 = "3"
            # Si están conectadas lo están en un sentido y en el otro
            mInit[4] += "\t\t\t\t(= (conectadas " + conexion[i] + " " + conexion[i + 1] + ") " + o1 + ")\n"
            mInit[4] += "\t\t\t\t(= (conectadas " + conexion[i + 1] + " " + conexion[i] + ") " + o2 + ")\n"
            # Añado las distancias
            mInit[6] += "\t\t\t\t(= (distanciaZona " + conexion[i] + " " + conexion[i + 1] + ") " + distancias[i] + ")\n"
            mInit[6] += "\t\t\t\t(= (distanciaZona " + conexion[i + 1] + " " + conexion[i] + ") " + distancias[i] + ")\n"

    # :objects
    for i in range(0, len(lItems)):
        lItems[i].sort()
        lItems[i].sort(key = len)
        aux = " ".join(lItems[i])
        if aux != "":
            mObjects += "\t\t\t\t" + aux + " - " + switchInver[i] + "\n"
    mObjects += "\t\t)\n"

    # :init
    # Añado los valores de recompensa
    lPersonajes = lItems[2:7]
    lObjetos = lItems[7:12]
    for i in range(0, len(lPersonajes)):
        for pers in lPersonajes[i]:
            for j in range(0, len(lObjetos)):
                for item in lObjetos[j]:
                    mInit[7] += "\t\t\t\t(= (daPuntos " + pers + " " + item + ") " + str(switchPuntos[(i, j)]) + ")\n"

    mInit[-1] = mInit[-1].rstrip("\n")
    mAux = mInit[0]
    for linea in mInit[1:]:
        mAux += linea + "\n"
    mAux += "\t\t)\n"
    mInit = mAux

    # :metric (minimizar distancia total)
    mMetric += "(distanciaTotal))\n"

    # Juntamos todas las partes
    mGeneral += mProblem + mDomain + mObjects + mInit + mGoal + mMetric + ")"
    return mGeneral
# -------------------------------------------------------------------------------------------

if len(sys.argv) == 3: nArchivo = sys.argv[2]
elif len(sys.argv) == 2: nArchivo = ""
else: sys.exit("Error: nº args no válido. Uso: py generaproblema.py rutaMapa.txt [rutaSalida.pddl]")

# Leemos el fichero
fMapa = open(sys.argv[1], "r")
contenido = fMapa.readlines()
fMapa.close()

# Escritura
mGeneral = ""

# Quitamos las líneas vacías
sinSaltos = list(filter(lambda x: x != '\n', contenido))
# Quitamos los saltos de línea al final de cada línea
sinSaltos = list(map(lambda x: x.rstrip('\n'), sinSaltos))

# Nombre del dominio
nombreDominio = recortar(sinSaltos[0])

nInd = -1
if nombreDominio == "Ejercicio1":
    mGeneral += parser1(sinSaltos)
    nInd = 1
elif nombreDominio == "Ejercicio2":
    mGeneral += parser2(sinSaltos)
    nInd = 2
elif nombreDominio == "Ejercicio3":
    mGeneral += parser3(sinSaltos)
    nInd = 3
elif nombreDominio == "Ejercicio4":
    mGeneral += parser4(sinSaltos)
    nInd = 4
elif nombreDominio == "Ejercicio5":
    mGeneral += parser5(sinSaltos)
    nInd = 5
elif nombreDominio == "Ejercicio6":
    mGeneral += parser6(sinSaltos)
    nInd = 6
elif nombreDominio == "Ejercicio7":
    mGeneral += parser7(sinSaltos)
    nInd = 7
else: sys.exit("Error: nº de dominio no válido, debe ser del tipo EjercicioX con X del 1 al 7.")

# Creamos el archivo pddl del problema y escribimos el contenido
if nArchivo == "":
    nArchivo = os.path.dirname(sys.argv[1])
    if nArchivo != "":
        nArchivo += "/"
    nArchivo += "Ej" + str(nInd) + "problema"
    i = 1
    while os.path.exists(nArchivo + str(i) + ".pddl"):
        i += 1
    nArchivo += str(i) + ".pddl"
fProblema = open(nArchivo, "w")
fProblema.write(mGeneral)
fProblema.close()

print("Finalizando con éxito.")
