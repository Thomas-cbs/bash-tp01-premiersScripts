#!/bin/bash

################################################################################
# Tests automatiques pour l'exercice 2 - Jeu deviner un nombre
# Utilisé pour l'autograding GitHub Classroom
################################################################################

SCRIPT_PATH="exercices/ex2/devine_nombre.sh"
SCORE=0
MAX_SCORE=10

echo "======================================"
echo "Tests Exercice 2 - Jeu deviner un nombre"
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

# Test 3 : Vérification de la gestion des paramètres
echo "[Test 3/6] Test sans paramètres (doit échouer)..."
OUTPUT=$(bash "$SCRIPT_PATH" 2>&1)
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ] && echo "$OUTPUT" | grep -iq "erreur\|usage\|paramètre"; then
    echo "✓ Le script gère correctement l'absence de paramètres"
    ((SCORE+=2))
else
    echo "✗ Le script ne gère pas correctement l'absence de paramètres"
fi

# Test 4 : Vérification avec 2 paramètres valides
echo "[Test 4/6] Test avec paramètres valides (1 100)..."
# Le script doit démarrer correctement
OUTPUT=$(echo "" | timeout 2 bash "$SCRIPT_PATH" 1 100 2>&1)
if echo "$OUTPUT" | grep -iq "jeu\|devinez\|nombre"; then
    echo "✓ Le script démarre avec des paramètres valides"
    ((SCORE+=2))
else
    echo "✗ Le script ne démarre pas correctement"
fi

# Test 5 : Vérification de la validation des paramètres (min > max)
echo "[Test 5/6] Test avec paramètres invalides (100 1)..."
OUTPUT=$(bash "$SCRIPT_PATH" 100 1 2>&1)
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ] && echo "$OUTPUT" | grep -iq "erreur\|inférieur"; then
    echo "✓ Le script valide l'ordre des paramètres"
    ((SCORE+=2))
else
    echo "✗ Le script ne valide pas l'ordre des paramètres"
fi

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
