#!/bin/bash

################################################################################
# Script : table_multiplication.sh
# Description : Affiche la table de multiplication d'un nombre
# Auteur : [Votre nom]
# Date : [Date]
################################################################################

# TODO: Demander un nombre à l'utilisateur
#echo "saissisez un entier valide."
read nb

# TODO: Valider que l'entrée est bien un nombre
if [[ "$nb" =~ ^-?[0-9]+$ ]]; then
    #echo "C'est un nombre entier valide."
    
    for ((i=1; i<11; i++))
    do
        result=$(($nb*$i))
        echo "$nb x $i = $result"
    done

else
    echo "Ce n'est pas un entier valide."
fi

# TODO: Afficher la table de multiplication de 1 à 10

