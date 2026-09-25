#!/bin/bash

################################################################################
# Script : devine_nombre.sh
# Description : Jeu de devinette - trouver un nombre aléatoire
# Usage : ./devine_nombre.sh <min> <max> [difficile]
# Auteur : [Votre nom]
# Date : [Date]
################################################################################

# TODO: Vérifier que 2 paramètres sont fournis
if [ "$#" -ne 2 ]; then
    echo "Erreur : Vous devez fournir exactement 2 paramètres."
    echo "Usage: $0 <paramètre1> <paramètre2>"
    exit 1
fi
$essais=0
$nb_aleatoire=0
$essais_restant=0
$test=0
# TODO: Valider que les paramètres sont des nombres
if [[ "$1" =~ ^[0-9]+$ ]]; then
    
    if [ $1 -lt $2 ]; then
        nb_aleatoire=$(($1 + RANDOM % $2))


        i=0 
        until [ $i -gt 5 ]; do 
            essais_restant=$((5-$1))
            echo "essayer de deviner le nombre entre $1 et $2 , il vous reste $i essaie(s) :" 
            i=$(($i+1))
            read test
            if [ $1 -lt $2 ]; do

        done 


    else
        echo "le premier paramétre doit etre un nombre stictement plue petit que le deuxiéme"
    fi

else
    echo "saissisez un entier valide."
fi

# TODO: Valider que min < max


# TODO: Générer un nombre aléatoire entre min et max


# TODO: Initialiser le nombre d'essais (5 par défaut, 3 en mode difficile)


# TODO: Boucle de jeu avec 5 essais maximum


# TODO: Afficher le message de fin (victoire ou défaite)

