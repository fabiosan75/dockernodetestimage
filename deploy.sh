#!/bin/sh

# Denificion de TAGS para IMAGENES app y BD

    MONGO_TAG='fabiosan75/mongoimage:1.0'
    NODE_TAG='fabiosan75/nodeappimg:1.0'

# Creamos readme para el proyecto a partir de los comentarios del SHELL actual.
cat > README.md <<COMMENT
____________________________________________________________________________________________

$0
# @package  Docker Run Actividad Tema 3
# @version  : 1.0
# @date     : 2023-04-17
# @author   fabiosan75 <fabiosan75@gmail.com>
# @license  http://www.gnu.org/copyleft/gpl.html GNU General Public License
# @link     https://github.com/fabiosan75

- Este script genera dos IMAGENES una para webApp nodejs y otra para BD mongo.
- Partiendo de las imagenes se generan dos contenedores para poner en operaci€on la APP, 
uno para webApp y uno para BD mongo, crea volumen, crea Red, conecta los contenedores a 
la red, publica puerto para  servicio webApp 8081, pasa por variables de entorno al contenedor 
webApp los parametros de conexiob a MONGO para conectar servicio webApp con BD Mongo. 
- El contenedor de BD para persistencia se mapea con el directorio
del host [dababase-data] y para el almacenamiento de objetos de aplicacion webApp se montan
con el volumeApp. Lo demas parametros de los contenedores se describen en su creacion. La APP
es un CRUD para almacenamiento de datos de Usuario, adaptacion propia.

- Se actualiza el registro en harbor 

   docker push harbor.tallerdevops.com/actividad3fabioandressanchezbernal/$MONGO_TAG
   docker push harbor.tallerdevops.com/actividad3fabioandressanchezbernal/$NODE_TAG

    Se ejecuta en Harbor SCAN con la herramienta para validar vulnerabilidades


 DEFINICION DE PARAMETROS PARA LOS SERVICIOS [imagenes, contenedores, volumen, red, puertos]

 APP_SERVICE_NAME          : Nombre contenedor Aplicación
 NODE_TAG                  : Imagen node a utilizar para el contenedor del sericio de BD
 APP_PUBLIC_DOMAIN         : Dominio enterno App localhost 
 APP_SERVICE_PORT          : Definicion Pto interno APP Server Node : Default 3000 
 APP_SERVICE_PUBLIC_PORT   : Puerto a publicar la aplicación para acceso WEB - Acceso Publico 
 DB_SERVICE_NAME           : Nombre contenedor para la instancia de la BD
 MONGO_TAG                 : Imagen Mongo database
 DB_DATA_DIR               : Directorio de datos BD para persistencia
 VOLUME_WEBNAME            : Volumen webApp para persistencia de datos 
 DB_SERVICE_PORT           : Puerto para publicar el servicio BD Mongo 
 DB_NAME                   : Nombre de la BD
 NET_MAME                  : Nombre para la subred 
URL_REGISTRY               : URL Repositorio Registro de Imagenes 'harbor.tallerdevops.com'
USER_REGISTRY              : Credenciales - Usuario Login Repositorio
PW_REGISTRY                : Credenciales - Password Login Repositorio
____________________________________________________________________________________________
COMMENT


    # Parametros APP
    APP_SERVICE_NAME='node_webApp'
    APP_PUBLIC_DOMAIN='localhost'
    APP_SERVICE_PORT=3000
    APP_SERVICE_PUBLIC_PORT=8081
    DB_SERVICE_NAME='mongoDB'

    # Parametros BD
    DB_DATA_DIR='database-data'
    VOLUME_WEBNAME='volumeApp'
    DB_SERVICE='db_mongo'
    # Mongo default 27017 | NO SE PUBLICA EN EL CONTENEDOR PARA AISLAR Y PROTEGER
    DB_SERVICE_PORT=27017
    DB_NAME='test'
    NET_NAME='my_local_network'
    
    strPathVolume=$(pwd)/$DB_DATA_DIR

    URL_REGISTRY='harbor.tallerdevops.com'
    USER_REGISTRY='taller2211'
    PW_REGISTRY='Taller2211'

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

# main 
    clear
    print_head " Docker Run Actividad Tema 3 Dockerfile "

# ____________________________________________________________________________________________
# Crear Imagenes para App y BD

    print_head " Crear Imagen BD mongo  "

    docker build -t $MONGO_TAG -f mongodb.Dockerfile .

    print_head " Crear Imagen Web App Nodejs  "

    docker build -t $NODE_TAG -f webapp.Dockerfile .

# ____________________________________________________________________________________________
# Eliminar los contenedores y red si existen para evitar ERROR de creacion

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
# Validar si Existe Directorio [$$DB_DATA_DIR] en el HOST para Datos de BD si no crearlo

    if [ ! -d "$DB_DATA_DIR" ]; then 
        print_head "Creando Directorio [$strPathVolume]"
        mkdir $DB_DATA_DIR 
    else
        print_head "Directorio [$strPathVolume] EXISTE"
    fi

# ____________________________________________________________________________________________
# Crear volumen [$VOLUME_WEBNAME] para persistencia de datos

   print_head "Creando Volume [$VOLUME_WEBNAME]"

   docker volume create $VOLUME_WEBNAME 1> /dev/null

# ____________________________________________________________________________________________
# Crear SubRed [$NET_NAME] si no Existe para aislar y conectar los contenedores

    if [ ! "$(docker network ls | grep -w $NET_NAME)" ]; then
        print_head "Creando Subnet [$NET_NAME]"

        docker network create --attachable $NET_NAME #1> /dev/null
    fi

# ____________________________________________________________________________________________
# Crear contendor [$DB_SERVICE_NAME] a partir de la imagen $MONGO_TAG 
# y montar $DB_DATA_DIR para la persistencia de datos a BD
# Rearrancar  [--restart unless-stopped] : Menos si se detiene de forma implicita

    print_head "Creando contenedor servicio [$DB_SERVICE_NAME]"
    print_var "Imagen " "[$MONGO_TAG]"
   
    print_var "Datos persistentes PATH" "[${PWD}/$DB_DATA_DIR]"
#            -p 27018:27017 \

    docker run -d --name=$DB_SERVICE_NAME \
            --restart unless-stopped \
            -v ${PWD}/$DB_DATA_DIR:/data/db \
            --network $NET_NAME \
            $MONGO_TAG 1> /dev/null

# ____________________________________________________________________________________________
# Verificar que el Contenedor [$DB_SERVICE_NAME] este Creado y Corriendo

    if [ "$( docker container inspect -f '{{.State.Status}}' $DB_SERVICE_NAME )" == "running" ]; then 
        print_m "\t*** Contenedor $DB_SERVICE_NAME Creado y Corriendo ***"
    else
        print_m "\t*** !!! ERROR AL CREAR CONTENEDOR $DB_SERVICE_NAME ***"
        exit 1;
    fi

# ____________________________________________________________________________________________
# Crear contenedor [$APP_SERVICE_NAME] opciones :
# Publicar puertos   : Puerto del host $APP_SERVICE_PUBLIC_PORT: Pto al WebServer $APP_SERVICE_PORT
# --network          : Conectar a la red $NET_NAME
# Rearrancar         : [--restart unless-stopped] Menos si se detiene de forma manual 
# Volumes            : Se monta el volumen $VOLUME_WEBNAME
# Bind Mount         : Para enlazar con el codigo de la aplicación ubicado en ${PWD}/app/
# env                : Parametros de conexión a Mongo pasados como variables de entorno
# Instalación webApp :  node install ; /usr/src/app/appserver.sh ; tail -f /dev/null 
#                       Se isntala app node, se lanza listener y se redireccina para mantener
#                       corriendo el contenedor a /dev/null    

    print_head "Creando contenedor servicio [$APP_SERVICE_NAME]"
    print_var "Imagen " "[$NODE_TAG]"
    print_var "Publicando Puertos " "[$APP_SERVICE_PUBLIC_PORT:$APP_SERVICE_PORT]"
    print_var "Nombre de Red" "[$NET_NAME]"

        #    -v ${PWD}/app/:/usr/src/app \
#             --workdir /app \

    docker run -d --name=$APP_SERVICE_NAME \
            -p $APP_SERVICE_PUBLIC_PORT:$APP_SERVICE_PORT \
            --network $NET_NAME \
            --restart unless-stopped \
            -v $VOLUME_WEBNAME:/usr/src/data \
            --env APP_SERVICE_PORT=$APP_SERVICE_PORT \
            --env APP_PUBLIC_DOMAIN=$APP_PUBLIC_DOMAIN \
            --env DB_SERVICE_HOST=$DB_SERVICE_NAME \
            --env DB_SERVICE_PORT=$DB_SERVICE_PORT \
            --env DB_NAME=$DB_NAME \
            $NODE_TAG 
            #\
            #bash -c "node install ; /usr/src/app/appserver.sh ; tail -f /dev/null " 
            #1> /dev/null
            #1> /dev/null
            
# ____________________________________________________________________________________________
# Verificar que el Contenedor [$APP_SERVICE_NAME] este Creado y Corriendo

    if [ "$( docker container inspect -f '{{.State.Status}}' $APP_SERVICE_NAME )" == "running" ]; then 
        print_m "\t*** Contenedor $APP_SERVICE_NAME Creado y Corriendo ***"
    else
        print_m "\t*** !!! ERROR AL CREAR CONTENEDOR $APP_SERVICE_NAME ***"
        exit 1;
    fi

# ____________________________________________________________________________________________
# Test de aplicacion, servicio responde y crea BD Mongo

    print_head "Testeando webApp Node Listener y conexion a Mongo \n"

    sleep 4

    curl "localhost:$APP_SERVICE_PUBLIC_PORT"

    echo "\n"
# ____________________________________________________________________________________________
# Ver contenedores corriendo

    print_head "Contenedores Corriendo \n"

    docker ps

# ____________________________________________________________________________________________
# Mostrar listado de SubNets creadas

    print_head " Redes Disponibnles "
    docker network ls

# ____________________________________________________________________________________________
# Mostrar listado de SubNets creadas

    print_head " Volumenes Disponibnles "
    docker volume ls

    print_head "Contenido DIR [$DB_DATA_DIR] persistencia para BD  \n"

    ls -ls "$DB_DATA_DIR"

# ____________________________________________________________________________________________
# Loguear en registro Harbor
    print_head " Habor Login  "

    docker login $URL_REGISTRY -u $USER_REGISTRY -p $PW_REGISTRY

# ____________________________________________________________________________________________
# Push en registro Harbor

    print_head " Subir a Harbor "
 
 # Actualizar TAGS segun standar Harbor
    docker tag $MONGO_TAG harbor.tallerdevops.com/actividad3fabioandressanchezbernal/$MONGO_TAG
    docker tag $NODE_TAG harbor.tallerdevops.com/actividad3fabioandressanchezbernal/$NODE_TAG

# Subir imagenes a harbor

    docker push harbor.tallerdevops.com/actividad3fabioandressanchezbernal/$MONGO_TAG
    docker push harbor.tallerdevops.com/actividad3fabioandressanchezbernal/$NODE_TAG
