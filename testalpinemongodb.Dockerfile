FROM alpine:3.17

LABEL description="Master DevOps : Mod Contenedores Actividad 4"
LABEL package="Alpine Linux / MongoDB"
LABEL author="fabiosan75 <fabiosan75@gmail.com>"
LABEL license="http://www.gnu.org/copyleft/gpl.html GNU General Public License"
LABEL link="https://github.com/fabiosan75"

ENV DB_DIR=/data/db/

# Esteblecer DIR de trabajo
WORKDIR /usr/src

COPY app/entrypoint_mongo.sh .
#RUN apk add openrc

# Crear directorio de datos para mongoDB y asignar propietario
RUN mkdir -p $DB_DIR && \ 
    chown root $DB_DIR \
    && chmod 755 entrypoint_mongo.sh

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/main' >> /etc/apk/repositories \
    && echo 'http://dl-cdn.alpinelinux.org/alpine/v3.9/community' >> /etc/apk/repositories \
    && apk update
    
   #apk add mongodb && \
# ahrehar add --no-cache cuanto todo instale OK

# Instalar mongodb y utilidades

RUN apk add --no-cache bash \
    && apk add --no-cache mongodb \ 
    && apk add --no-cache mongodb-tools 
#RUN /etc/init.d/mongodb stop
     
#RUN apk add --no-cache tini openrc busybox-initscripts

# APP_DIR   : Deinificion de directorio destino para instalacion APP dentro de la imagen



# Habilitar servicio DB en SO
#RUN rc-update add mongodb default 
 #   && rc-service mongodb stop
# Iniciar servicio de BD
#RUN rc-service mongodb stop

#RUN mongo --version

#4.05-r0


# chmod 755 entrypoint_mongo.sh

# Definicion de variables de ambiente con parametros de conexion paara BD
# DB_SERVICE_HOST           : Nombre contenedor para la instancia de la BD
# DB_SERVICE_PORT           : Puerto para publicar el servicio BD Mongo 
# DB_NAME                   : Nombre de la BD

ENV DB_SERVICE_HOST=localhost \
    DB_SERVICE_PORT=27017 \
    DB_NAME=appadmin \
    MONGO_INITDB_ROOT_USERNAME=app_user \
    MONGO_INITDB_ROOT_PASSWORD=app_password

# Publicar puerto para acceso al servicio que provee la imagen EJ : 3000 nodejs
EXPOSE $DB_SERVICE_PORT

# Script de entrada para recibir opciones externas y lanzar EXEC hacia la aplicacion 
# EJ : [start|dev] lanzan (exec npm start / exec npm run dev)
# La implementación del entrypoint.sh permite tambien el paso de comandos bash hacia el contenedor 

#ENTRYPOINT [ "./entrypoint_mongo.sh"]

# CMD permitira recibir parametros hacia el entrypoint sustituyento el parametro por deferecto "start"
ENTRYPOINT [ "/usr/src/entrypoint_mongo.sh"]

# CMD permitira recibir parametros hacia el entrypoint sustituyento el parametro por deferecto "start"

CMD ["start"]
#CMD ["/usr/bin/mongod","--bind_ip_all"]

# OK
#CMD ["node","/app/server.js"] 
