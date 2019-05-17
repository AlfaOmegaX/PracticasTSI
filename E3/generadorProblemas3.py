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
mGoal = "\n\t\t(:goal (and"
mMetric = "\n\t\t(:metric minimize "
# Diccionarios-switch
switchItem = {"Player": 0, "Profesor": 1, "Principe": 2, "Princesa": 3, "Bruja": 4, "Leonardo": 5, "Manzana": 6, "Oscar": 7, "Algoritmo": 8, "Oro": 9, "Rosa": 10, "Zapatilla": 11, "Bikini": 12, "Bosque": 13, "Agua": 14, "Precipicio": 15, "Arena": 16, "Piedra": 17}
switchInver = {v: k for k, v in switchItem.items()}

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
        mInit[4] += "\t\t\t\t(estaEn " + nombreItem + " " + zona + ")\n"
    # Si es el jugador se añade el predicado de orientación
    if tipoItem == "Player":
        mInit[1] += "\t\t\t\t(orientadoHacia " + nombreItem + " N)\n"
        mInit[6] += "\t\t\t\t(= (distanciaTotal " + nombreItem + ") 0)\n"
    # Si es un tipo especial que necesita predicado de es algo
    elif tipoItem in ["Agua", "Bosque", "Bikini", "Zapatilla"]:
        k = -1
        if tipoItem in ["Agua", "Bosque"]: k = 3
        elif tipoItem in ["Bikini", "Zapatilla"]: k = 2
        mInit[k] += "\t\t\t\t(es" + tipoItem + " " + nombreItem + ")\n"

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
sinSaltos.pop(0);
# Nº de zonas
nZonas = recortar(sinSaltos[0])
sinSaltos.pop(0);

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
        o1 = o2 = ""
        # Si en dirección vertical u horizontal
        if vH == "V":
            o1 = "S"
            o2 = "N"
        elif vH == "H":
            o1 = "E"
            o2 = "O"
        # Si están conectadas lo están en un sentido y en el otro
        mInit[5] += "\t\t\t\t(estanConectadas " + conexion[i] + " " + conexion[i + 1] + " " + o1 + ")\n"
        mInit[5] += "\t\t\t\t(estanConectadas " + conexion[i + 1] + " " + conexion[i] + " " + o2 + ")\n"
        # Añado las distancias
        mInit[7] += "\t\t\t\t(= (distanciaZona " + conexion[i] + " " + conexion[i + 1] + ") " + distancias[i] + ")\n"
        mInit[7] += "\t\t\t\t(= (distanciaZona " + conexion[i + 1] + " " + conexion[i] + ") " + distancias[i] + ")\n"

# :objects
for i in range(0, len(lItems)):
    lItems[i].sort()
    lItems[i].sort(key = len)
    aux = " ".join(lItems[i])
    if aux != "":
        mObjects += "\t\t\t\t" + aux + " - " + switchInver[i] + "\n"
mObjects += "\t\t)\n"

# :init
mInit[7] = mInit[7].rstrip("\n")
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

# Si no hay ni un jugador falla
if lItems[0] == []:
    exit("Error: no hay un jugador en el mapa.")
# Minizamos la métrica del primer jugador
mMetric += "(distanciaTotal " + lItems[0][0] + "))\n"

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
