# Imagen base 
FROM node:19-alpine

# Agregar metadata a la imagen tomando como base LABEL SCHEMA org.opencontainers.image
# https://specs.opencontainers.org/image-spec/annotations/
# docker.cmd="docker run -d --name testappnode nodeappimg:1.0 start"

LABEL org.opencontainers.image.description="Imagen node App Con Linux Alpine - Mod Contenedores Actividad 3" \
        org.opencontainers.image.title="mongoimagetest" \
        org.opencontainers.image.version="1.0" \
        org.opencontainers.image.date="2023-04-17T10:04:00" \
        org.opencontainers.image.vendor="fabiosan75 <fabiosan75@gmail.com>" \
        org.opencontainers.image.url="https://github.com/fabiosan75"



# APP_DIR   : Deinificion de directorio destino para instalacion APP dentro de la imagen
ENV APP_DIR=/app
# Esteblecer DIR de trabajo
WORKDIR $APP_DIR

# Copia packege.json necesario para instalacion de dependencia nodejs de la APP
COPY app/package.json $APP_DIR

# Instalación node y dependencias definidad en package.json
# Instalación de bash en Alpine ya que por defecto no viene en la imagen
# --no-cache Limpiar caches
RUN npm install && apk update && apk add --no-cache bash

# Copiar contenido de src (Codigo Aplicacion) en directorio $APP_DIR de la imagen
COPY ./app $APP_DIR

# Definicion de variables de ambiente con parametros de conexion paara BD
# APP_SERVICE_PORT          : Definicion Pto interno (LOCAL) APP Server Node : Default 3000 
# APP_PUBLIC_DOMAIN         : Dominio para la URL publica Para este ejemplo de node "localhost" para el API user
# APP_SERVICE_PUBLIC_PORT   : Puerto a publicar la aplicación para acceso WEB - Acceso Publico USO INTERNO DE APP
# DB_SERVICE_HOST           : Nombre contenedor para la instancia de la BD
# DB_SERVICE_PORT           : Puerto para publicar el servicio BD Mongo 
# DB_NAME                   : Nombre de la BD

ENV APP_SERVICE_PORT=3000 \
    APP_PUBLIC_DOMAIN=localhost \
    APP_SERVICE_PUBLIC_PORT=8081 \
    DB_SERVICE_HOST=localhost \
    DB_SERVICE_PORT=27017 \
    DB_NAME=appadmin

# Publicar puerto para acceso al servicio que provee la imagen EJ : 3000 nodejs
EXPOSE $APP_SERVICE_PORT

# Script de entrada para recibir opciones externas y lanzar EXEC hacia la aplicacion 
# EJ : [start|dev] lanzan (exec npm start / exec npm run dev)
# La implementación del entrypoint.sh permite tambien el paso de comandos bash hacia el contenedor 
ENTRYPOINT [ "/app/entrypoint.sh"]

# CMD permitira recibir parametros hacia el entrypoint sustituyento el parametro por deferecto "start"
CMD ["start"]

