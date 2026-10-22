#!/bin/bash
echo "=== 10 primeras líneas ==="
head -n 10 /etc/passwd
echo "=========================="
echo "=== 10 últimas líneas ==="
tail -n 10 /etc/passwd
