#!/bin/bash

################################################################################
# Script : renommer_fichiers.sh
# Description : Renomme les fichiers .txt d'un dossier
#               - Remplace les espaces par des underscores
#               - Convertit en minuscules
#               - Ajoute un préfixe avec la date
# Usage : ./renommer_fichiers.sh <dossier> [--dry-run]
# Auteur : [Votre nom]
# Date : [Date]
################################################################################

# TODO: Vérifier qu'un dossier est fourni en paramètre
# TODO: Vérifier que le dossier existe
if [ -d "$1" ]; then
    #cas ou le dossier existe


    # Obtenir la date du jour au format AAAAMMJJ
    date=$(date +%Y%m%d)


    # Lister uniquement les fichiers .txt 
    ls *.txt
    dossier=$1
    for fichier in $dossier/*.txt; do
        echo "$fichier"
        nom_base="${fichier%.txt}"
        nouveau_nom=$(echo "$nom_base" | tr ' ' '_' | tr '[:upper:]' '[:lower:]')
        nouveau_nom="$date-$nouveau_nom.txt"
        mv "$fichier" "$dossier/$nouveau_nom"
        echo "le $fichier a été renommé en --> $nouveau_nom"
    done

else
    echo "Erreur : '$1' n'est pas un dossier valide ou n'existe pas."
    exit 1
fi




# TODO: Récupérer la date du jour au format AAAAMMJJ


# TODO: Initialiser les compteurs


# TODO: Boucler sur tous les fichiers .txt du dossier


# TODO: Pour chaque fichier :
#       - Extraire le nom sans extension
#       - Remplacer les espaces par des underscores
#       - Convertir en minuscules

#       - Créer le nouveau nom avec le préfixe


# TODO: Afficher le résumé des opérations
