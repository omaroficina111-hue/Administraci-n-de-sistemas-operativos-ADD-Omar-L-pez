#!/bin/bash
read -p "Año de nacimiento: " nacimiento
actual=$(date +%Y)
echo "Tienes aproximadamente $((actual - nacimiento)) años."
