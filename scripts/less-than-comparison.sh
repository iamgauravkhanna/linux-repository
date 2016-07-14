#!/bin/sh

a=0

until [ ! $a -lt 100 ]
do
   echo $a
   a=`expr $a + 1`
done