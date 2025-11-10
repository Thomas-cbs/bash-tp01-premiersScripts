#!/bin/bash

################################################################################
# Tests automatiques pour l'exercice 3 - Script de backup
# Utilisé pour l'autograding GitHub Classroom
################################################################################

SCRIPT_PATH="exercices/ex3/backup_local.sh"
SCORE=0
MAX_SCORE=10

echo "======================================"
echo "Tests Exercice 3 - Script de backup"
echo "======================================"
echo ""

# Test 1 : Le script existe
echo "[Test 1/6] Vérification de l'existence du script..."
if [ -f "$SCRIPT_PATH" ]; then
    echo "✓ Le script existe"
    ((SCORE+=2))
else
    echo "✗ Le script n'existe pas à l'emplacement : $SCRIPT_PATH"
    echo "Score final : $SCORE/$MAX_SCORE"
    exit 1
fi

# Test 2 : Le script est exécutable
echo "[Test 2/6] Vérification des permissions..."
if [ -x "$SCRIPT_PATH" ]; then
    echo "✓ Le script est exécutable"
    ((SCORE+=1))
else
    echo "✗ Le script n'est pas exécutable"
    chmod +x "$SCRIPT_PATH" 2>/dev/null
fi

# Test 3 : Le script contient les commandes rsync appropriées
echo "[Test 3/6] Vérification de l'utilisation de rsync..."
if grep -q "rsync" "$SCRIPT_PATH"; then
    echo "✓ Le script utilise rsync"
    ((SCORE+=1))
    
    # Vérifier les options importantes
    if grep "rsync" "$SCRIPT_PATH" | grep -q "\-a" && \
       grep "rsync" "$SCRIPT_PATH" | grep -q "\-\-delete"; then
        echo "✓ Les options rsync semblent correctes (-a et --delete)"
        ((SCORE+=2))
    else
        echo "⚠ Les options rsync pourraient être incomplètes"
    fi
else
    echo "✗ Le script n'utilise pas rsync"
fi

# Test 4 : Vérification de la structure avec backup-dir
echo "[Test 4/6] Vérification de l'option --backup-dir..."
if grep "rsync" "$SCRIPT_PATH" | grep -q "\-\-backup-dir"; then
    echo "✓ L'option --backup-dir est présente"
    ((SCORE+=2))
else
    echo "✗ L'option --backup-dir n'est pas trouvée"
fi

# Test 5 : Test fonctionnel basique
echo "[Test 5/6] Test fonctionnel avec répertoires de test..."

# Créer une structure de test temporaire
TEST_DIR=$(mktemp -d)
SOURCE_DIR="$TEST_DIR/source"
BACKUP_DIR="$TEST_DIR/backup"

mkdir -p "$SOURCE_DIR" "$BACKUP_DIR/Courant" "$BACKUP_DIR/Trash"
echo "test file" > "$SOURCE_DIR/test.txt"

# Créer une version modifiée du script pour les tests
TEST_SCRIPT="$TEST_DIR/test_script.sh"
sed "s|/home/\$USER/Documents/|$SOURCE_DIR/|g; s|/home/\$USER/Backup/Courant|$BACKUP_DIR/Courant|g; s|/home/\$USER/Backup/Trash|$BACKUP_DIR/Trash|g" "$SCRIPT_PATH" > "$TEST_SCRIPT"
chmod +x "$TEST_SCRIPT"

# Exécuter le script
timeout 10 bash "$TEST_SCRIPT" > /dev/null 2>&1
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ] && [ -f "$BACKUP_DIR/Courant/test.txt" ]; then
    echo "✓ Le script fonctionne et crée la sauvegarde"
    ((SCORE+=1))
else
    echo "⚠ Le test fonctionnel a échoué (ce n'est peut-être pas un problème si votre script utilise des chemins différents)"
fi

# Nettoyage
rm -rf "$TEST_DIR"

# Test 6 : Vérification des commentaires
echo "[Test 6/6] Vérification de la présence de commentaires..."
COMMENT_COUNT=$(grep -c "^#" "$SCRIPT_PATH")
if [ $COMMENT_COUNT -ge 5 ]; then
    echo "✓ Le script contient des commentaires ($COMMENT_COUNT lignes)"
    ((SCORE+=1))
else
    echo "✗ Le script manque de commentaires"
fi

echo ""
echo "======================================"
echo "Score final : $SCORE/$MAX_SCORE"
echo "======================================"

if [ $SCORE -ge 7 ]; then
    exit 0
else
    exit 1
fi
