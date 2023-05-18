#!/bin/sh
# $0 nombre del script, 
# $1, $2, $3 parametros pasados por CLI 
CMD=$1
  
case "$CMD" in  
	"start" ) 
               # exec iniciar mongo daemon con la configuracion por defecto y el parametro
               #   --bind_ip_all neceario para lograr conectar a la BD desde contenedor externo o 
               # diferente a localhost
                exec mongod --bind_ip_all
	;;

	* ) 
                # Permite la ejecucion de domandos por CLI hacia el contenedor 
                # "docker run [OPTIONS]... [OPTIONS] /bin/bash"  
                exec $CMD ${@:2} 
	    ;; 
esac