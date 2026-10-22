#!/bin/bash
read -p "Nombre del fichero: " fichero
ls -lh "$fichero"
file "$fichero"
