#!/bin/sh

# @package  Docker Run Actividad Tema 3
# @version  : 1.0
# @date     : 03 04 2023
# @
# @author   fabiosan75 <fabiosan75@gmail.com>
# @license  http://www.gnu.org/copyleft/gpl.html GNU General Public License
# @link     https://github.com/fabiosan75

<<COMMENT
____________________________________________________________________________________________
 DEFINICION DE PARAMETROS PARA LOS SERIVCIOS [imagenes, contenedores, volumen, red, puertos]

 APP_SERVICE_NAME          : Nombre contenedor Aplicación
 DB_SERVICE_NAME           : Nombre contenedor para la instancia de la BD
 DB_DATA_DIR               : Directorio de datos BD para persistencia
 VOLUME_WEBNAME            : Volumen webApp para persistencia de datos 
 NET_MAME                  : Nombre para la subred 
 NODE_TAG                  : Imagen node a utilizar para el contenedor del sericio de BD
 MONGO_TAG                 : Imagen Mongo database

___________________________________________________________________________________________
COMMENT

    APP_SERVICE_NAME='node_webApp'
    DB_SERVICE_NAME='mongoDB'
    DB_DATA_DIR='database-data'
    VOLUME_WEBNAME='volumeApp'
    NET_NAME='my_local_network'
    MONGO_TAG='fabiosan75/mongoimage:1.0'
    NODE_TAG='fabiosan75/nodeappimg:1.0'

# ____________________________________________________________________________________________
# Funciones basicas para mensajes por consola 
# print_head : mensajes con linea para encabezado
# print_m    : mensaje 

    print_head () {
        echo "----------------------------------------------------------------"
        echo "* $1         "
    }

    print_m () {
        echo "$1"
    }

    print_var () {
        printf " %-30s : %-30s \n" "$1" "$2"
    }

# ____________________________________________________________________________________________
# Eliminar los contenedores y red si existen 

    if docker ps -qa --filter "name=$APP_SERVICE_NAME" | grep -q .; then 
        print_var "Eliminar Contenedor " "$APP_SERVICE_NAME"
        docker rm -fv $APP_SERVICE_NAME 1> /dev/null; 
    fi

    if docker ps -qa --filter "name=$DB_SERVICE_NAME" | grep -q .; then 
        print_var "Eliminar contenedor servicio" "$DB_SERVICE_NAME "
        docker rm -fv $DB_SERVICE_NAME 1> /dev/null; 
    fi

    if [ "$(docker network ls | grep -w $NET_NAME)" ]; then
        print_var "Eliminar SubNet" "$NET_NAME"
        docker network rm $NET_NAME 1> /dev/null; 
    fi

# ____________________________________________________________________________________________
# Eliminar volumen [$VOLUME_WEBNAME] para persistencia de datos

   print_head "Eliminando Volume [$VOLUME_WEBNAME]"

   docker volume create $VOLUME_WEBNAME 1> /dev/null

# ____________________________________________________________________________________________
# Eliminar Directorio si existe usado para persistencia datos de BD

    if [ -d "$DB_DATA_DIR" ]; then 
        print_head "Eliminando Directorio [$DB_DATA_DIR]"
        rm -rf $DB_DATA_DIR 
    else
        print_head "Directorio [$DB_DATA_DIR] NO EXISTE"
    fi

# ____________________________________________________________________________________________
# Eliminar Imagenes 

    print_head "Eliminando Imagenes  [$NODE_TAG] [$MONGO_TAG]"

    docker rmi $NODE_TAG

    docker rmi $MONGO_TAG

    docker rmi harbor.tallerdevops.com/actividad3fabioandressanchezbernal/$MONGO_TAG
    docker rmi harbor.tallerdevops.com/actividad3fabioandressanchezbernal/$NODE_TAG
