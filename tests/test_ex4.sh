#!/bin/bash

################################################################################
# Tests automatiques pour l'exercice 4 - Analyseur de logs
# Utilisé pour l'autograding GitHub Classroom
################################################################################

SCRIPT_PATH="exercices/ex4/analyse_logs.sh"
SCORE=0
MAX_SCORE=10

echo "======================================"
echo "Tests Exercice 4 - Analyseur de logs"
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

# Créer un fichier de log de test
TEST_LOG=$(mktemp)
cat > "$TEST_LOG" << 'EOF'
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

# Test 3 : Vérification de la gestion des paramètres
echo "[Test 3/6] Test sans paramètres (doit échouer)..."
OUTPUT=$(bash "$SCRIPT_PATH" 2>&1)
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ] && echo "$OUTPUT" | grep -iq "erreur\|usage\|fichier"; then
    echo "✓ Le script gère l'absence de paramètres"
    ((SCORE+=1))
else
    echo "✗ Le script ne gère pas correctement l'absence de paramètres"
fi

# Test 4 : Test fonctionnel avec le fichier de test
echo "[Test 4/6] Test avec fichier de log de test..."
OUTPUT=$(timeout 5 bash "$SCRIPT_PATH" "$TEST_LOG" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    echo "✓ Le script s'exécute sans erreur"
    ((SCORE+=2))
    
    # Vérifier que la sortie contient les statistiques attendues
    if echo "$OUTPUT" | grep -q "4" && \
       echo "$OUTPUT" | grep -iq "erreur"; then
        echo "✓ Le script compte correctement les erreurs (4)"
        ((SCORE+=2))
    else
        echo "⚠ Le comptage des erreurs pourrait être incorrect"
        echo "  Sortie reçue :"
        echo "$OUTPUT" | head -10
    fi
else
    echo "✗ Le script a échoué"
fi

# Test 5 : Vérification de l'utilisation de grep
echo "[Test 5/6] Vérification de l'utilisation de grep..."
if grep -q "grep" "$SCRIPT_PATH"; then
    echo "✓ Le script utilise grep"
    ((SCORE+=1))
else
    echo "✗ Le script n'utilise pas grep"
fi

# Test 6 : Vérification des commentaires
echo "[Test 6/6] Vérification de la présence de commentaires..."
COMMENT_COUNT=$(grep -c "^#" "$SCRIPT_PATH")
if [ $COMMENT_COUNT -ge 3 ]; then
    echo "✓ Le script contient des commentaires ($COMMENT_COUNT lignes)"
    ((SCORE+=1))
else
    echo "✗ Le script manque de commentaires"
fi

# Nettoyage
rm -f "$TEST_LOG"

echo ""
echo "======================================"
echo "Score final : $SCORE/$MAX_SCORE"
echo "======================================"

if [ $SCORE -ge 7 ]; then
    exit 0
else
    exit 1
fi
