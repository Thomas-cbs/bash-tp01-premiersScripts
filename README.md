# TP01 : Premiers scripts Bash

**Durée :** 3 heures  
**Environnement :** Ubuntu Server 24.04 (VM VirtualBox)  
**Rendu :** via GitHub Classroom (push de votre repository)

## Objectifs pédagogiques

À l'issue de ce TP, vous serez capable de :
- Écrire vos premiers scripts Bash avec interactions utilisateur
- Utiliser les structures de contrôle (boucles, conditions)
- Manipuler les variables et les paramètres
- Traiter et manipuler des fichiers avec Bash
- Utiliser Git pour versionner votre travail

## Mise en place

### Prérequis
- Connexion SSH à votre VM Ubuntu Server
- Git configuré avec votre compte GitHub
- Éditeur de texte (nano, vim, ou VSCode avec Remote-SSH)

### Initialisation du projet

```bash
# Cloner votre repository depuis GitHub Classroom
git clone <url-de-votre-repo>
cd <nom-du-repo>

# La structure de répertoires est déjà créée !
# Vérifier la structure :
ls -R Exos/
```

### Bonnes pratiques pour ce TP

- **Shebang** : Tous vos scripts doivent commencer par `#!/bin/bash`
- **Permissions** : Rendez vos scripts exécutables : `chmod +x script.sh`
- **Commentaires** : Commentez votre code pour expliquer la logique
- **Tests** : Testez chaque script avec différents cas (valeurs normales, limites, erreurs)
- **Commits** : Faites des commits réguliers avec des messages clairs

```bash
# Exemple de workflow Git
git add Exos/ex1/
git commit -m "Ex1: Script table de multiplication terminé"
git push
```

### Tests automatisés

Pour tester un exercice spécifique :
```bash
./test_ex1.sh  # depuis Exos/ex1/
./test_ex2.sh  # depuis Exos/ex2/
./test_ex3.sh  # depuis Exos/ex3/
```

Pour lancer tous les tests d'un coup :
```bash
./run_all_tests.sh  # depuis la racine du projet
```

---

## Exo 1 : Table de multiplication (45 min)

### Objectif
Créer un script `table_multiplication.sh` qui affiche la table de multiplication d'un nombre entré par l'utilisateur.

### Comportement attendu

```
Entrez un nombre : 7
Table de multiplication de 7 :
7 x 1 = 7
7 x 2 = 14
7 x 3 = 21
...
7 x 10 = 70
```

### Questions

1. **Validation d'entrée** : Comment vérifier que l'utilisateur a bien entré un nombre ?
2. **Boucle** : Quelle structure de boucle est la plus appropriée (for, while) ? Pourquoi ?
3. **Extension** : Comment pourriez-vous permettre à l'utilisateur de choisir jusqu'à quel multiplicateur aller (ex: jusqu'à 15 au lieu de 10) ?

### Critères d'évaluation

- [ ] Le script demande un nombre à l'utilisateur
- [ ] La table de 1 à 10 s'affiche correctement
- [ ] Le formatage est propre et lisible
- [ ] Le script est commenté
- [ ] Le script est exécutable

### Bonus

Ajoutez une validation qui redemande le nombre si l'entrée n'est pas valide :

```bash
Entrez un nombre : abc
Erreur : Veuillez entrer un nombre valide.
Entrez un nombre : 5
Table de multiplication de 5 :
...
```

---

## Exo 2 : Jeu - Deviner un nombre 🎲 (60 min)

### Objectif
Créer un jeu `devine_nombre.sh` où l'ordinateur tire un nombre aléatoire entre deux bornes données en paramètres, et l'utilisateur doit le deviner en maximum 5 essais.

### Utilisation

```bash
./devine_nombre.sh 1 100
```

### Comportement attendu

```
Jeu : Devinez le nombre entre 1 et 100
Nombre d'essais restants : 5
Votre proposition : 50
Trop grand !

Nombre d'essais restants : 4
Votre proposition : 25
Trop petit !

Nombre d'essais restants : 3
Votre proposition : 37
Bravo ! Vous avez trouvé en 3 essais !
```

### Aide : Nombre aléatoire en Bash

Pour générer un nombre aléatoire entre `a` et `b` :

```bash
# $RANDOM génère un nombre entre 0 et 32767
# Pour obtenir un nombre entre a et b :
nombre=$(( $RANDOM % (b - a + 1) + a ))
```

**Exemple** : Pour un nombre entre 1 et 100 :
```bash
nombre=$(( $RANDOM % 100 + 1 ))
```

### Questions

1. **Gestion des paramètres** : Que se passe-t-il si l'utilisateur ne fournit pas exactement 2 paramètres ? Comment gérer ce cas ?
2. **Validation** : Comment vérifier que le premier paramètre est bien inférieur au second ?
3. **Compteur** : Expliquez comment vous gérez le décompte des essais restants.
4. **Comparaisons** : Quelle syntaxe utilisez-vous pour comparer des nombres en Bash ?

### Critères d'évaluation

- [ ] Le script accepte 2 paramètres (min et max)
- [ ] Validation des paramètres (nombre, ordre)
- [ ] Génération correcte du nombre aléatoire
- [ ] Boucle de 5 essais maximum
- [ ] Indications "trop grand" / "trop petit"
- [ ] Message de victoire ou de défaite

### Bonus

Ajoutez un mode "difficile" où l'utilisateur n'a que 3 essais, activable avec un 3ème paramètre :

```bash
./devine_nombre.sh 1 100 difficile
```

---

## Exo 3 : Traitement de fichiers en lot 📁 (75 min)

### Objectif
Créer un script `renommer_fichiers.sh` qui manipule et traite des fichiers dans un dossier de manière automatisée.

### Contexte

Vous avez récupéré un dossier contenant des fichiers avec des noms mal formatés. Votre script doit :
1. Renommer tous les fichiers `.txt` en remplaçant les espaces par des underscores
2. Convertir les noms en minuscules
3. Ajouter un préfixe avec la date du jour
4. Générer un rapport des modifications

### Fichiers de test fournis

**Un dossier `test_data/` est déjà fourni dans `Exos/ex3/`** avec des fichiers de test :

```bash
Exos/ex3/test_data/
├── Mon Document.txt
├── Rapport FINAL.txt
├── Notes DIVERSES.txt
├── TODO Liste.txt
├── Fichier IMPORTANT.txt
├── Compte Rendu TP.txt
├── SYNTHESE Projet.txt
├── image.jpg          # Ne doit pas être renommé
├── photo.png          # Ne doit pas être renommé
└── script.sh          # Ne doit pas être renommé
```

**Pour tester votre script** :

```bash
# Se placer dans le dossier de l'exercice 3
cd Exos/ex3

# Option 1 : Utiliser le dossier test_data fourni
./renommer_fichiers.sh test_data

# Option 2 : Créer votre propre dossier de test (optionnel)
mkdir -p ~/TestFichiers
cd ~/TestFichiers
touch "Mon Document.txt" "Rapport FINAL.txt" "Notes DIVERSES.txt"
touch "TODO Liste.txt" "image.jpg"
cd -
./renommer_fichiers.sh ~/TestFichiers
```

**Note importante** : Après avoir testé votre script, vous pouvez restaurer les fichiers originaux avec :

```bash
git restore Exos/ex3/test_data/
```

### Fonctionnalités attendues

Le script doit :
1. Prendre un dossier en paramètre
2. Lister tous les fichiers `.txt` du dossier
3. Pour chaque fichier `.txt` :
   - Remplacer les espaces par des underscores `_`
   - Convertir le nom en minuscules
   - Ajouter le préfixe `backup_AAAAMMJJ_` (ex: `backup_20251117_`)
4. Afficher un résumé des modifications
5. Ne pas renommer les fichiers qui ne sont pas `.txt`

### Exemple d'utilisation

```bash
# Depuis le dossier Exos/ex3
cd Exos/ex3
./renommer_fichiers.sh test_data

=== Traitement des fichiers dans : test_data ===

Fichiers .txt trouvés : 7

Renommage en cours...
✓ "Mon Document.txt" → "backup_20251117_mon_document.txt"
✓ "Rapport FINAL.txt" → "backup_20251117_rapport_final.txt"
✓ "Notes DIVERSES.txt" → "backup_20251117_notes_diverses.txt"
✓ "TODO Liste.txt" → "backup_20251117_todo_liste.txt"
✓ "Fichier IMPORTANT.txt" → "backup_20251117_fichier_important.txt"
✓ "Compte Rendu TP.txt" → "backup_20251117_compte_rendu_tp.txt"
✓ "SYNTHESE Projet.txt" → "backup_20251117_synthese_projet.txt"

Résumé :
- Fichiers traités : 7
- Fichiers ignorés : 3 (image.jpg, photo.png, script.sh)
- Opération terminée avec succès !
```

### Commandes utiles

```bash
# Lister uniquement les fichiers .txt
ls *.txt

# Boucle sur les fichiers
for fichier in *.txt; do
    echo "$fichier"
done

# Obtenir la date du jour au format AAAAMMJJ
date +%Y%m%d

# Remplacer les espaces par des underscores
echo "Mon Fichier.txt" | tr ' ' '_'

# Convertir en minuscules
echo "FICHIER.txt" | tr '[:upper:]' '[:lower:]'

# Renommer un fichier
mv "ancien_nom.txt" "nouveau_nom.txt"

# Extraire le nom sans l'extension
nom_base="${fichier%.txt}"

# Vérifier si un fichier existe
if [ -f "$fichier" ]; then
    echo "Le fichier existe"
fi
```

### Questions

1. **Paramètres** : Comment vérifier que le dossier passé en paramètre existe et est bien un répertoire ?
2. **Sécurité** : Que se passe-t-il si deux fichiers ont le même nom après transformation ? Comment gérer ce cas ?
3. **Extension** : Comment pourriez-vous permettre à l'utilisateur de choisir l'extension à traiter (pas seulement .txt) ?
4. **Variables** : Expliquez l'intérêt d'utiliser des variables pour stocker les compteurs (fichiers traités, ignorés).

### Critères d'évaluation

- [ ] Vérification de l'existence du dossier en paramètre
- [ ] Traitement uniquement des fichiers .txt
- [ ] Remplacement correct des espaces
- [ ] Conversion en minuscules
- [ ] Ajout du préfixe avec la date
- [ ] Affichage clair des opérations effectuées
- [ ] Compteur de fichiers traités et ignorés
- [ ] Gestion des erreurs basiques

### Bonus

1. Ajoutez une option `--dry-run` qui simule les modifications sans les appliquer :
```bash
./renommer_fichiers.sh ~/TestFichiers --dry-run
=== MODE SIMULATION (aucune modification réelle) ===
...
```

2. Créez une fonction de sauvegarde qui garde une copie des noms originaux dans un fichier `renommage.log` :
```
2025-11-17 14:30:22 | Mon Document.txt → backup_20251117_mon_document.txt
2025-11-17 14:30:22 | Rapport FINAL.txt → backup_20251117_rapport_final.txt
```

---

## Rendu du TP

### Structure finale de votre repository

```
votre-repo/
├── README.md
├── REPONSES.md (vos réponses aux questions)
├── run_all_tests.sh (lance tous les tests)
└── Exos/
    ├── ex1/
    │   ├── table_multiplication.sh
    │   └── test_ex1.sh (tests automatiques)
    ├── ex2/
    │   ├── devine_nombre.sh
    │   └── test_ex2.sh (tests automatiques)
    └── ex3/
        ├── renommer_fichiers.sh
        ├── test_ex3.sh (tests automatiques)
        └── test_data/ (fichiers de test fournis)
            ├── README.md
            ├── Mon Document.txt
            ├── Rapport FINAL.txt
            ├── Notes DIVERSES.txt
            ├── TODO Liste.txt
            ├── Fichier IMPORTANT.txt
            ├── Compte Rendu TP.txt
            ├── SYNTHESE Projet.txt
            ├── image.jpg
            ├── photo.png
            └── script.sh
```

### Fichier REPONSES.md

Créez un fichier `REPONSES.md` à la racine contenant vos réponses aux questions de chaque exercice. Exemple :

```markdown
# Réponses aux questions du TP01 - Premiers scripts Bash

## Exo 1 : Table de multiplication

### Question 1 : Validation d'entrée
Pour vérifier que l'entrée est un nombre, on peut utiliser...

### Question 2 : Boucle
J'ai choisi une boucle for car...

### Question 3 : Extension
Pour permettre à l'utilisateur de choisir le multiplicateur...

## Exo 2 : Jeu de devinette

### Question 1 : Gestion des paramètres
...

## Exo 3 : Traitement de fichiers

### Question 1 : Paramètres
...
```

### Commits attendus

Faites des commits réguliers et explicites :

```bash
git add Exos/ex1/
git commit -m "Ex1: Table de multiplication terminée"

git add Exos/ex2/
git commit -m "Ex2: Jeu de devinette avec validation des paramètres"

git add Exos/ex3/
git commit -m "Ex3: Script de renommage de fichiers terminé"
```

### Dernier push

```bash
git add .
git commit -m "Finalisation du TP01 - Tous les exercices terminés"
git push origin main
```

---

## Checklist finale

Avant de rendre votre travail, vérifiez :

- [ ] Tous les scripts commencent par `#!/bin/bash`
- [ ] Tous les scripts sont exécutables (`chmod +x`)
- [ ] Tous les scripts sont commentés
- [ ] Tous les scripts gèrent les erreurs basiques
- [ ] **Tous les tests passent** (`./run_all_tests.sh` affiche tous les ✓)
- [ ] Le fichier REPONSES.md est complet
- [ ] Tous les commits ont des messages clairs
- [ ] Le push final a été effectué sur GitHub

---

## Ressources complémentaires

### Commandes Bash essentielles

- Variables : `variable="valeur"`, accès avec `$variable`
- Tests : `[ condition ]` ou `[[ condition ]]`
- Comparaisons numériques : `-eq`, `-ne`, `-lt`, `-le`, `-gt`, `-ge`
- Comparaisons chaînes : `==`, `!=` et condition à mettre entre `[[ condition ]]`
- Tests fichiers : `-f` (fichier), `-d` (répertoire), `-e` (existe), `-r` (lisible)
- Boucles : `for`, `while`, `until`
- Conditions : `if`, `elif`, `else`

### Documentation

```bash
# Aide sur une commande
man commande
commande --help

# Exemples : 
man bash
man test
man tr
```

### Aide en ligne

- [Cours Bash sur ciel-ir-rascol](https://ciel-ir-rascol.github.io/linux/05-Scripts_bash/) **<-- À voir en premier 👍**
- [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
- [ShellCheck](https://www.shellcheck.net/) - Vérificateur de syntaxe Bash

---

**Bon courage pour vos premiers scripts Bash ! 😉**
