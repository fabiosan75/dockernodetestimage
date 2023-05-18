# Imagen de base mongo dado que no hay disponibilidad con Linux Alpine
FROM mongo:6.0

# Agregar metadata a la imagen tomando como base LABEL SCHEMA org.opencontainers.image
# https://specs.opencontainers.org/image-spec/annotations/
# docker.cmd="docker run -d --name mongotest mongoimagetest:1.0 start"

LABEL org.opencontainers.image.description="Mongo 6 Ubuntu Master DevOps - Mod Contenedores Actividad 3" \
        org.opencontainers.image.title="mongoimagetest" \
        org.opencontainers.image.version="1.0" \
        org.opencontainers.image.date="2023-04-17T10:04:00" \
        org.opencontainers.image.vendor="fabiosan75 <fabiosan75@gmail.com>" \
        org.opencontainers.image.url="https://github.com/fabiosan75"


# DB_DIR    : PATH sirectorio de datos mongo
ENV DB_DIR=/data/db/

# Esteblecer DIR de trabajo
WORKDIR /usr/src

# Copiar el entrypoint dentro de la imagen
COPY app/entrypoint_mongo.sh .

# Crear directorio de datos para mongoDB y asignar propietario
# Asegurar permisos de ejecucion del entrypoint
RUN mkdir -p $DB_DIR \
    && chown root $DB_DIR \
    && chmod 755 entrypoint_mongo.sh

# Definicion de variables de ambiente con parametros de conexion paara BD
# DB_SERVICE_HOST           : Nombre contenedor para la instancia de la BD
# DB_SERVICE_PORT           : Puerto para publicar el servicio BD Mongo 
# DB_NAME                   : Nombre de la BD
# ***  Parametros de servicio mongodb
# MONGO_INITDB_ROOT_USERNAME: Root user  
# MONGO_INITDB_ROOT_PASSWORD: Root password

ENV DB_SERVICE_HOST=localhost \
    DB_SERVICE_PORT=27017 \
    DB_NAME=appadmin \
    MONGO_INITDB_ROOT_USERNAME=app_user \
    MONGO_INITDB_ROOT_PASSWORD=app_password

# Publicar puerto para acceso al servicio que provee la imagen EJ : 27017 mongo
EXPOSE $DB_SERVICE_PORT

# Script de entrada para recibir opciones externas y lanzar EXEC hacia la aplicacion 
# EJ : [start] lanzan (exec mongod --bind_ip_all) 
# IMPORTANTE **** --bind_ip_all es necesario para poder conectar a la BD desde otro contenedor
# La implementación del entrypoint.sh permite tambien el paso de comandos bash hacia el contenedor 
ENTRYPOINT [ "./entrypoint_mongo.sh"]

# CMD permitira recibir parametros hacia el entrypoint sustituyento el parametro por deferecto "start"

CMD ["start"]
