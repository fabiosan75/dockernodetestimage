____________________________________________________________________________________________

./deploy.sh
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

   docker push harbor.tallerdevops.com/actividad3fabioandressanchezbernal/fabiosan75/mongoimage:1.0
   docker push harbor.tallerdevops.com/actividad3fabioandressanchezbernal/fabiosan75/nodeappimg:1.0

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
