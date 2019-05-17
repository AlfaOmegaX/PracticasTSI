import sys
import itertools
import os
import random
import re

# Random seed pero siempre la misma
random.seed(100)
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

# Recorta de "algo:nombre" obtieniendo nombre
def recortar(cadena):
    return cadena.split(":")[1]

# Si n es un número (float)
def esNumero(n):
    try:
        float(n)
        return True
    except ValueError:
        return False

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


if len(sys.argv) != 2:
    sys.exit("Error: argumentos no válidos. Uso: python crearProblema.py nombreArchivoMapa.txt")

# Leemos el fichero
fMapa = open(sys.argv[1], "r")
contenido = fMapa.readlines()
fMapa.close()
# Quitamos las líneas vacías
sinSaltos = list(filter(lambda x: x != '\n', contenido))
# Quitamos los saltos de línea al final de cada línea
sinSaltos = list(map(lambda x: x.rstrip('\n'), sinSaltos))
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

# Si no hay ni un jugador falla
if lItems[0] == []:
    exit("Error: no hay un jugador en el mapa.")
jugPrimero = lItems[0][0]
# :goal
mGoal += "(>= (puntosJugador " + jugPrimero + ") " + pTotales + ")))\n"

# :metric (minimizar distancia total)
mMetric += "(distanciaTotal))\n"

# Juntamos todas las partes
mGeneral += mProblem + mDomain + mObjects + mInit + mGoal + mMetric + ")"

# Creamos el archivo pddl del problema y escribimos el contenido
nArchivo = os.path.dirname(sys.argv[1])
if nArchivo != "":
    nArchivo += "/"
nArchivo += nombreProblema + "-"
i = 1
while os.path.exists(nArchivo + str(i) + ".pddl"):
    i += 1
fProblema = open(nArchivo + str(i) + ".pddl", "w")
fProblema.write(mGeneral)
fProblema.close()

print("Finalizando con éxito.")
