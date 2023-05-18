#!/bin/sh
# $0 nombre del script, 
# $1, $2, $3 parametros pasados por CLI 
CMD=$1
  
case "$CMD" in  
	"start" ) 
               # exec equvalente a node app/server.js para Prod y para DEV nodemon /app/server.js 
                exec npm start 
	;;

	* ) 
                # Permite la ejecucion de domandos por CLI hacia el contenedor 
                # "docker run [OPTIONS]... [OPTIONS] /bin/bash"  
                exec $CMD ${@:2} 
	    ;; 
esac