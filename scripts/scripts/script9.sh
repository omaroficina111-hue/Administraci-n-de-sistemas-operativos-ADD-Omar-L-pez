#!/bin/bash
echo "Nombre de la máquina: $(hostname)"
echo "Usuarios conectados: $(who | wc -l)"
echo "Versión del kernel: $(uname -r)"
