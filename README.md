# TP01 : Premiers scripts Bash

**Durée :** 4 heures  
**Environnement :** Ubuntu Server 24.04 (VM VirtualBox)  
**Rendu :** via GitHub Classroom (push de votre repository)

## Objectifs pédagogiques

À l'issue de ce TP, vous serez capable de :
- Écrire des scripts Bash avec interactions utilisateur
- Utiliser les structures de contrôle (boucles, conditions)
- Manipuler les variables et les paramètres
- Automatiser des tâches système avec des scripts
- Utiliser Git pour versionner votre travail

## Mise en place

### Prérequis
- Connexion SSH à votre VM Ubuntu Server
- Git configuré avec votre compte GitHub
- Éditeur de texte (nano, vim, ou autre)

### Initialisation du projet

```bash
# Cloner votre repository depuis GitHub Classroom
git clone <url-de-votre-repo>
cd <nom-du-repo>

# Créer la structure de répertoires
mkdir -p Exos/{ex1,ex2,ex3,ex4,ex5}
```

### Bonnes pratiques pour ce TP

- **Shebang** : Tous vos scripts doivent commencer par `#!/bin/bash`
- **Permissions** : Rendez vos scripts exécutables : `chmod +x script.sh`
- **Commentaires** : Commentez votre code pour expliquer la logique
- **Tests** : Testez chaque script avec différents cas (valeurs normales, limites, erreurs)
- **Commits** : Faites des commits réguliers avec des messages clairs

```bash
# Exemple de workflow Git
git add all # Ajout de tous les fichiers du repos à Git
git commit -m "Ex1: Script table de multiplication terminé"
git push
```

---

## Exo 1 : Table de multiplication (30 min)

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

## Exo 2 : Jeu - Deviner un nombre 🎲 (45 min)

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

## Exo 3 : Script de backup avec rsync 💾 (90 min)

### Objectif
Créer un script de sauvegarde incrémentale utilisant `rsync` avec conservation des fichiers supprimés.

### Partie 3.1 : Sauvegarde locale (45 min)

#### Structure de répertoires

```
/home/votre_user/
├── Documents/           # Dossier source à sauvegarder
│   ├── fichier1.txt
│   ├── fichier2.txt
│   └── dossier/
└── Backup/             # Dossier de sauvegarde
    ├── Courant/        # Clone actuel de Documents
    └── Trash/          # Fichiers supprimés
```

#### Préparation

```bash
# Créer la structure de test
mkdir -p ~/Documents ~/Backup/Courant ~/Backup/Trash

# Créer des fichiers de test
echo "Contenu fichier 1" > ~/Documents/fichier1.txt
echo "Contenu fichier 2" > ~/Documents/fichier2.txt
mkdir ~/Documents/dossier
echo "Contenu fichier 3" > ~/Documents/dossier/fichier3.txt
```

#### Script à créer : `backup_local.sh`

Votre script doit utiliser `rsync` avec les options suivantes :

- `-a` : Mode archive (récursif + conservation des permissions)
- `-u` : Update (synchronise seulement si source plus récente)
- `--delete` : Supprime dans la destination ce qui n'existe plus dans la source
- `--backup` : Sauvegarde les fichiers avant suppression/écrasement
- `--backup-dir=/chemin/vers/Trash` : Dossier de sauvegarde des fichiers supprimés
- `--stats` : Affiche les statistiques

#### Exemple de commande rsync

```bash
rsync -au --delete --backup --backup-dir=/home/user/Backup/Trash --stats /home/user/Documents/ /home/user/Backup/Courant/
```

⚠️ **Attention aux slashes** : Le `/` à la fin de `Documents/` est important !

### Questions Partie 3.1

1. **Variables** : Pourquoi est-il préférable d'utiliser des variables pour les chemins plutôt que les écrire en dur ?
2. **Test de backup** : Décrivez le scénario de test suivant et son résultat attendu :
   - Faire une première sauvegarde
   - Modifier un fichier dans Documents
   - Supprimer un fichier dans Documents
   - Refaire une sauvegarde
   - Que doit-il se passer dans Courant et Trash ?
3. **Logs** : Comment pourriez-vous rediriger les statistiques de rsync vers un fichier de log daté ?

### Partie 3.2 : Envoi de rapport par mail avec Gmail (45 min) - OPTIONNEL

#### Objectif
Envoyer un email réel avec le résultat de la sauvegarde en utilisant `ssmtp` et le serveur SMTP de Gmail.

#### Étape 1 : Créer un mot de passe d'application Gmail

⚠️ **Important** : Ne jamais utiliser votre mot de passe Gmail principal dans un script !

**Procédure pour créer un mot de passe d'application :**

1. **Activer la validation en deux étapes** (prérequis obligatoire)
   - Allez sur https://myaccount.google.com/security
   - Cliquez sur "Validation en deux étapes"
   - Suivez les instructions pour l'activer (SMS, application Google Authenticator, etc.)

2. **Créer un mot de passe d'application**
   - Une fois la validation en 2 étapes activée, retournez sur https://myaccount.google.com/security
   - Cherchez "Mots de passe des applications" ou allez directement sur : https://myaccount.google.com/apppasswords
   - Cliquez sur "Générer"
   - Sélectionnez :
     - **Application** : "Autre (nom personnalisé)"
     - **Nom** : "Script Backup Ubuntu" (ou autre nom explicite)
   - Cliquez sur "Générer"
   - **Notez le mot de passe de 16 caractères** (format : `xxxx xxxx xxxx xxxx`)
   - ⚠️ Vous ne pourrez plus le revoir, conservez-le précieusement !

#### Étape 2 : Installation et configuration de SSMTP

**Installation :**

```bash
sudo apt update
sudo apt install ssmtp
```

**Configuration du fichier `/etc/ssmtp/ssmtp.conf` :**

```bash
# Éditer le fichier de configuration
sudo nano /etc/ssmtp/ssmtp.conf
```

**Contenu à mettre dans le fichier :**

```conf
# Configuration SMTP Gmail
root=votre.email@gmail.com
mailhub=smtp.gmail.com:587
hostname=localhost
AuthUser=votre.email@gmail.com
AuthPass=xxxx xxxx xxxx xxxx
UseSTARTTLS=YES
UseTLS=YES
FromLineOverride=YES

# Optionnel : pour les logs de debug
#Debug=YES
```

**Remplacez :**
- `votre.email@gmail.com` par votre adresse Gmail
- `xxxx xxxx xxxx xxxx` par le mot de passe d'application généré

**Sécurisation du fichier :**

```bash
# Restreindre les permissions (important pour la sécurité)
sudo chmod 640 /etc/ssmtp/ssmtp.conf
sudo chown root:mail /etc/ssmtp/ssmtp.conf
```

#### Étape 3 : Configuration de l'alias mail

Créer/éditer le fichier `/etc/ssmtp/revaliases` :

```bash
sudo nano /etc/ssmtp/revaliases
```

**Contenu :**

```
root:votre.email@gmail.com:smtp.gmail.com:587
votre_user:votre.email@gmail.com:smtp.gmail.com:587
```

Remplacez `votre_user` par votre nom d'utilisateur Ubuntu.

#### Étape 4 : Test d'envoi de mail

**Test simple :**

```bash
echo "Test d'envoi de mail depuis Ubuntu" | ssmtp destinataire@example.com
```

**Test avec sujet et corps :**

```bash
cat << EOF | ssmtp destinataire@example.com
To: destinataire@example.com
From: votre.email@gmail.com
Subject: Test SSMTP

Ceci est un test d'envoi de mail depuis Ubuntu Server.

Cordialement,
Votre serveur
EOF
```

Si vous recevez le mail, c'est bon !

#### Étape 5 : Script d'envoi de rapport `backup_mail.sh`

Créez un script qui combine backup et envoi de rapport :

```bash
#!/bin/bash

# Configuration
SOURCE="/home/$USER/Documents/"
DESTINATION="/home/$USER/Backup/Courant"
TRASH="/home/$USER/Backup/Trash"
EMAIL_DEST="votre.email@gmail.com"
LOG_FILE="/tmp/backup_$(date +%Y%m%d_%H%M%S).log"

# Fonction d'envoi de mail
envoyer_rapport() {
    local sujet="$1"
    local contenu="$2"
    
    cat << EOF | ssmtp "$EMAIL_DEST"
To: $EMAIL_DEST
From: $EMAIL_DEST
Subject: $sujet

$contenu
EOF
}

# Exécution de la sauvegarde et capture des statistiques
echo "Début de la sauvegarde : $(date)" > "$LOG_FILE"

# Exécuter rsync et capturer la sortie
RSYNC_OUTPUT=$(rsync -au --delete --backup --backup-dir="$TRASH" --stats "$SOURCE" "$DESTINATION" 2>&1)
RSYNC_EXIT=$?

# Ajouter au log
echo "$RSYNC_OUTPUT" >> "$LOG_FILE"
echo "Fin de la sauvegarde : $(date)" >> "$LOG_FILE"

# Préparer le rapport
if [ $RSYNC_EXIT -eq 0 ]; then
    STATUT="✅ SUCCÈS"
    SUJET="[OK] Sauvegarde réussie - $(date +%d/%m/%Y)"
else
    STATUT="❌ ÉCHEC"
    SUJET="[ERREUR] Échec de la sauvegarde - $(date +%d/%m/%Y)"
fi

RAPPORT=$(cat << EOF
═══════════════════════════════════════════════════
  RAPPORT DE SAUVEGARDE
═══════════════════════════════════════════════════

Statut : $STATUT
Date : $(date '+%d/%m/%Y à %H:%M:%S')
Serveur : $(hostname)

─────────────────────────────────────────────────
CONFIGURATION
─────────────────────────────────────────────────
Source      : $SOURCE
Destination : $DESTINATION
Corbeille   : $TRASH

─────────────────────────────────────────────────
STATISTIQUES
─────────────────────────────────────────────────
$RSYNC_OUTPUT

─────────────────────────────────────────────────

Fichier de log complet : $LOG_FILE

Cordialement,
Système de sauvegarde automatisé
EOF
)

# Envoyer le rapport
envoyer_rapport "$SUJET" "$RAPPORT"

# Afficher un message
if [ $RSYNC_EXIT -eq 0 ]; then
    echo "✅ Sauvegarde terminée avec succès"
    echo "📧 Rapport envoyé à $EMAIL_DEST"
else
    echo "❌ Erreur lors de la sauvegarde"
    echo "📧 Rapport d'erreur envoyé à $EMAIL_DEST"
fi

exit $RSYNC_EXIT
```

**Rendre le script exécutable et tester :**

```bash
chmod +x backup_mail.sh
./backup_mail.sh
```

#### Dépannage

**Problème 1 : "Cannot open smtp.gmail.com:587"**
- Vérifiez votre connexion internet
- Vérifiez que le port 587 n'est pas bloqué par un firewall

**Problème 2 : "Authorization failed"**
- Vérifiez que la validation en 2 étapes est activée
- Vérifiez le mot de passe d'application (sans espaces dans le fichier de config)
- Vérifiez l'adresse email

**Problème 3 : Mail non reçu**
- Vérifiez vos spams
- Attendez quelques minutes (délai possible)
- Vérifiez l'adresse destinataire

**Mode debug :**

```bash
# Ajouter dans /etc/ssmtp/ssmtp.conf
Debug=YES

# Puis tester
echo "Test" | ssmtp -v votre.email@gmail.com
```

#### Alternative : utiliser `mailx` avec SMTP externe

Si vous préférez `mailx` :

```bash
sudo apt install mailutils

# Créer ~/.mailrc
cat > ~/.mailrc << 'EOF'
set smtp=smtp://smtp.gmail.com:587
set smtp-auth=login
set smtp-auth-user=votre.email@gmail.com
set smtp-auth-password=xxxx-xxxx-xxxx-xxxx
set ssl-verify=ignore
set nss-config-dir=/etc/pki/nssdb/
EOF

chmod 600 ~/.mailrc

# Test
echo "Contenu du mail" | mailx -s "Sujet" destinataire@example.com
```

#### Script à améliorer : `backup_mail.sh`

Améliorez votre script pour :
1. Capturer les statistiques de rsync dans une variable
2. Générer un rapport formaté avec sections claires
3. Envoyer le rapport par mail via Gmail
4. Bonus : Gérer différents niveaux d'alerte (succès, warning, erreur)
5. Bonus : Joindre le fichier de log complet en pièce jointe

### Questions Partie 3.2

1. **Capture de sortie** : Comment capturer la sortie d'une commande dans une variable en Bash ?
2. **Formatage** : Comment créer un message mail lisible avec des retours à la ligne ?
3. **Production** : Dans un environnement de production, quelles seraient les différences pour envoyer un vrai mail (Gmail, SMTP externe) ?

### Partie 3.3 : Sauvegarde distante avec SSH (30 min) - OPTIONNEL

#### Objectif
Adapter le script pour sauvegarder sur une machine distante via SSH.

#### Prérequis

Pour tester, vous aurez besoin :
- D'une seconde VM ou d'accès à une machine distante
- De configurer l'authentification SSH par clé (sans mot de passe)

#### Configuration SSH sans mot de passe

```bash
# Sur votre machine source
ssh-keygen -t rsa -b 4096
ssh-copy-id user@machine_distante

# Tester la connexion
ssh user@machine_distante
```

#### Adaptation du script : `backup_distant.sh`

Modifier la variable de destination :

```bash
# Local
DESTINATION="/home/user/Backup/Courant"

# Distant
DESTINATION="user@192.168.1.100:/home/user/Backup/Courant"
```

La commande rsync fonctionne de la même manière !

### Questions Partie 3.3

1. **Sécurité** : Pourquoi est-il recommandé d'utiliser des clés SSH plutôt que des mots de passe pour les sauvegardes automatisées ?
2. **Automatisation** : Comment programmer ce script pour qu'il s'exécute automatiquement tous les jours à 2h du matin ? (Indice: cron)
3. **Robustesse** : Que se passe-t-il si la machine distante est inaccessible ? Comment gérer ce cas ?

### Critères d'évaluation Ex3

- [ ] Structure de répertoires correcte
- [ ] Script de backup local fonctionnel
- [ ] Options rsync appropriées
- [ ] Conservation des fichiers supprimés
- [ ] Script commenté et avec gestion d'erreurs
- [ ] Bonus : envoi de rapport
- [ ] Bonus : sauvegarde distante

---

## Exo 4 : Analyseur de logs (45 min)

### Objectif
Créer un script `analyse_logs.sh` qui analyse un fichier de log et en extrait des statistiques.

### Contexte

Les fichiers de logs système contiennent des informations précieuses. Votre script doit analyser un fichier de log et générer un rapport.

### Préparation : Créer un fichier de log de test

```bash
cat > ~/test.log << 'EOF'
2025-11-10 08:15:23 ERROR Connection failed to database
2025-11-10 08:15:45 INFO User admin logged in
2025-11-10 08:16:12 WARNING High memory usage detected
2025-11-10 08:17:03 ERROR Connection failed to database
2025-11-10 08:18:30 INFO User john logged in
2025-11-10 08:19:45 ERROR File not found: config.xml
2025-11-10 08:20:11 INFO Backup completed successfully
2025-11-10 08:21:33 WARNING Disk space low
2025-11-10 08:22:15 INFO User admin logged out
2025-11-10 08:23:02 ERROR Permission denied: /var/log/secure
EOF
```

### Fonctionnalités attendues

Le script doit :
1. Accepter un fichier de log en paramètre
2. Compter le nombre total de lignes
3. Compter le nombre d'erreurs (ERROR)
4. Compter le nombre d'avertissements (WARNING)
5. Compter le nombre d'informations (INFO)
6. Afficher les 3 dernières erreurs

### Exemple d'utilisation

```bash
./analyse_logs.sh ~/test.log

=== Analyse du fichier : /home/user/test.log ===

Statistiques :
- Total de lignes : 10
- Erreurs (ERROR) : 4
- Avertissements (WARNING) : 2
- Informations (INFO) : 4

Dernières erreurs :
- 2025-11-10 08:17:03 ERROR Connection failed to database
- 2025-11-10 08:19:45 ERROR File not found: config.xml
- 2025-11-10 08:23:02 ERROR Permission denied: /var/log/secure
```

### Commandes utiles

```bash
# Compter les lignes d'un fichier
wc -l fichier.txt

# Compter les lignes contenant un motif
grep "ERROR" fichier.txt | wc -l

# Afficher les dernières lignes contenant un motif
grep "ERROR" fichier.txt | tail -n 3
```

### Questions

1. **Validation** : Comment vérifier que le fichier passé en paramètre existe et est lisible ?
2. **Grep** : Expliquez la différence entre `grep "ERROR"` et `grep -c "ERROR"`.
3. **Extension** : Comment pourriez-vous identifier le type d'erreur le plus fréquent ?

### Critères d'évaluation

- [ ] Vérification de l'existence du fichier
- [ ] Comptage correct de chaque type de log
- [ ] Affichage formaté et lisible
- [ ] Gestion des erreurs (fichier inexistant, etc.)

### Bonus

Ajoutez la possibilité de filtrer par date :

```bash
./analyse_logs.sh ~/test.log 2025-11-10
# N'analyse que les entrées du 10 novembre 2025
```

---

## Exo 5 : Surveillance système (30 min)

### Objectif
Créer un script `check_system.sh` qui vérifie l'état du système et alerte si des seuils sont dépassés.

### Fonctionnalités

Le script doit vérifier :
1. **Utilisation CPU** : Alerter si > 80%
2. **Utilisation RAM** : Alerter si > 80%
3. **Espace disque** : Alerter si > 90% sur la partition racine
4. **Nombre de processus** : Afficher le top 5 des processus les plus gourmands

### Commandes utiles

```bash
# Utilisation CPU (moyenne sur 1 minute)
top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1

# Utilisation RAM
free | grep Mem | awk '{printf "%.0f", $3/$2 * 100.0}'

# Espace disque
df -h / | tail -1 | awk '{print $5}' | cut -d'%' -f1

# Top 5 processus par CPU
ps aux --sort=-%cpu | head -6
```

### Exemple de sortie

```
=== Surveillance Système - 2025-11-10 14:30:00 ===

✓ CPU : 45% - OK
✗ RAM : 85% - ALERTE : Utilisation élevée !
✓ Disque (/) : 67% - OK

Top 5 processus :
USER       PID %CPU %MEM COMMAND
root      1234  5.2  2.1 /usr/bin/apache2
mysql     5678  3.1  8.4 /usr/sbin/mysqld
...
```

### Questions

1. **AWK** : Expliquez le rôle de `awk` dans l'extraction des données.
2. **Conditions** : Comment comparer des nombres avec décimales en Bash ?
3. **Automatisation** : Comment faire pour que ce script enregistre l'historique des vérifications ?

### Critères d'évaluation

- [ ] Calcul correct des pourcentages
- [ ] Détection des seuils d'alerte
- [ ] Affichage clair avec indicateurs visuels
- [ ] Top 5 des processus affiché

### Bonus

- Enregistrez l'historique dans un fichier CSV : `date,cpu,ram,disk`
- Ajoutez une notification (sonore ou visuelle) en cas d'alerte

---

## Rendu du TP

### Structure finale de votre repository

```
votre-repo/
├── README.md (ce fichier avec vos réponses aux questions)
├── Exos/
│   ├── ex1/
│   │   └── table_multiplication.sh
│   ├── ex2/
│   │   └── devine_nombre.sh
│   ├── ex3/
│   │   ├── backup_local.sh
│   │   ├── backup_mail.sh (optionnel)
│   │   └── backup_distant.sh (optionnel)
│   ├── ex4/
│   │   └── analyse_logs.sh
│   └── ex5/
│       └── check_system.sh
└── REPONSES.md (vos réponses aux questions)
```

### Fichier REPONSES.md

Créez un fichier `REPONSES.md` à la racine contenant vos réponses aux questions de chaque Exo. Exemple :

```markdown
# Réponses aux questions du TP Bash

## Exo 1

### Question 1 : Validation d'entrée
Pour vérifier que l'entrée est un nombre, on peut utiliser...

### Question 2 : Boucle
J'ai choisi une boucle for car...

...
```

### Commits attendus

Faites des commits réguliers et explicites :

```bash
git add Exos/ex1/
git commit -m "Ex1: Table de multiplication terminée"

git add Exos/ex2/
git commit -m "Ex2: Jeu de devinette avec validation des paramètres"

# etc.
```

### Dernier push

```bash
git add .
git commit -m "Finalisation du TP - Tous Exos terminés"
git push origin main
```

---

## Checklist finale

Avant de rendre votre travail, vérifiez :

- [ ] Tous les scripts commencent par `#!/bin/bash`
- [ ] Tous les scripts sont exécutables (`chmod +x`)
- [ ] Tous les scripts sont commentés
- [ ] Tous les scripts gèrent les erreurs basiques
- [ ] Le fichier REPONSES.md est complet
- [ ] Tous les commits ont des messages clairs
- [ ] Le push final a été effectué sur GitHub

---

## Ressources complémentaires

### Commandes Bash essentielles

- Variables : `variable="valeur"`, accès avec `$variable`
- Tests : `[ condition ]` ou `[[ condition ]]`
- Comparaisons numériques : `-eq`, `-ne`, `-lt`, `-le`, `-gt`, `-ge`
- Comparaisons chaînes : `=`, `!=`
- Tests fichiers : `-f` (fichier), `-d` (répertoire), `-e` (existe), `-r` (lisible)
- Boucles : `for`, `while`, `until`
- Conditions : `if`, `elif`, `else`

### Documentation

```bash
# Aide sur une commande
man commande
commande --help

# Exemples : 
man rsync
man grep
man bash
```

### Aide en ligne

- [Cours Bash sur ciel-ir-rascol](https://ciel-ir-rascol.github.io/linux/05-Scripts_bash/) **<-- À voir en premier 👍**
- [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
- [ShellCheck](https://www.shellcheck.net/) - Vérificateur de syntaxe Bash


**Bon courage ! 😉**
