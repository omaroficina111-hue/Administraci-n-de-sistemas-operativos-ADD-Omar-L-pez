#!/bin/bash
# omarlogs.sh
# Cuenta los registros del mes actual de un nivel de severidad y los guarda en un archivo.
# Uso: ./omarlogs.sh <emergente|alerta|crítico|error|advertencia|noticia|información|depuración>
 
# 1. Validar que se recibe exactamente un parámetro.
if [ $# -ne 1 ]; then
    echo "Error: se necesita un único parámetro."
    echo "Uso: $0 <emergente|alerta|crítico|error|advertencia|noticia|información|depuración>"
    exit 1
fi
 
# 2. Traducir el nivel (en español) a la prioridad numérica de journalctl
case "${1,,}" in
    emergente)                NIVEL=0 ;;   # emerg
    alerta)                   NIVEL=1 ;;   # alert
    crítico|critico)          NIVEL=2 ;;   # crit
    error)                    NIVEL=3 ;;   # err
    advertencia)              NIVEL=4 ;;   # warning
    noticia)                  NIVEL=5 ;;   # notice
    información|informacion)  NIVEL=6 ;;   # info
    depuración|depuracion)    NIVEL=7 ;;   # debug
    *)
        echo "Error: el nivel '$1' no es válido."
        exit 2 ;;
esac
 
# 3. Definir el inicio del mes actual y el archivo de salida (directorio personal de quien ejecuta)
INICIO=$(date +%Y-%m-01)
ARCHIVO="$HOME/logs_${1}_$(date +%Y-%m).txt"
 
# 4. Guardar solo los registros de ESE nivel (rango NIVEL..NIVEL) desde el día 1 del mes
journalctl -p "${NIVEL}..${NIVEL}" --since "$INICIO" --no-pager -q > "$ARCHIVO"
 
# 5. Contar las líneas del archivo y mostrar el resultado por consola
TOTAL=$(wc -l < "$ARCHIVO")
echo "Registros de nivel '$1' en este mes: $TOTAL"
echo "Listado guardado en: $ARCHIVO"
