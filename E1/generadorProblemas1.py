import sys
import itertools
import os
import random

# Random seed pero siempre la misma
random.seed(100)
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

# Recorta de "algo:nombre" obtieniendo nombre
def recortar(cadena):
    return cadena.split(":")[1]

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
        mInit[1] += "\t\t\t\t(orientadoN" + " " + nombreItem + ")\n"

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
        o1 = o2 = ""
        # Si en dirección vertical u horizontal
        if vH == "V":
            o1 = "S"
            o2 = "N"
        elif vH == "H":
            o1 = "E"
            o2 = "O"
        # Si están conectadas lo están en un sentido y en el otro
        mInit[3] += "\t\t\t\t(conectadas" + o1 + " " + conexion[i] + " " + conexion[i + 1] + ")\n"
        mInit[3] += "\t\t\t\t(conectadas" + o2 + " " + conexion[i + 1] + " " + conexion[i] + ")\n"

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
