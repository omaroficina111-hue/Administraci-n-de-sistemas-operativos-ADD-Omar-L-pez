#!/bin/bash
echo "Contenido original" > original.txt
ln -s original.txt enlace_blando
ln original.txt enlace_duro
ls -li original.txt enlace_blando enlace_duro
