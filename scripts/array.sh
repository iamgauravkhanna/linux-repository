#!/bin/sh
# Author : Gaurav Khanna

NAME[0]="Alpha"
NAME[1]="Beta"
NAME[2]="Carol"
NAME[3]="Delta"
NAME[4]="Echo"
echo "First Method: ${NAME[*]}"
echo "Second Method: ${NAME[@]}"