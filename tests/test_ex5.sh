#!/bin/bash

################################################################################
# Tests automatiques pour l'exercice 5 - Surveillance système
# Utilisé pour l'autograding GitHub Classroom
################################################################################

SCRIPT_PATH="exercices/ex5/check_system.sh"
SCORE=0
MAX_SCORE=10

echo "======================================"
echo "Tests Exercice 5 - Surveillance système"
echo "======================================"
echo ""

# Test 1 : Le script existe
echo "[Test 1/5] Vérification de l'existence du script..."
if [ -f "$SCRIPT_PATH" ]; then
    echo "✓ Le script existe"
    ((SCORE+=2))
else
    echo "✗ Le script n'existe pas à l'emplacement : $SCRIPT_PATH"
    echo "Score final : $SCORE/$MAX_SCORE"
    exit 1
fi

# Test 2 : Le script est exécutable
echo "[Test 2/5] Vérification des permissions..."
if [ -x "$SCRIPT_PATH" ]; then
    echo "✓ Le script est exécutable"
    ((SCORE+=1))
else
    echo "✗ Le script n'est pas exécutable"
    chmod +x "$SCRIPT_PATH" 2>/dev/null
fi

# Test 3 : Test d'exécution
echo "[Test 3/5] Test d'exécution du script..."
OUTPUT=$(timeout 10 bash "$SCRIPT_PATH" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ] || [ $EXIT_CODE -eq 1 ]; then
    echo "✓ Le script s'exécute correctement"
    ((SCORE+=2))
else
    echo "✗ Le script a rencontré une erreur"
fi

# Test 4 : Vérification de la surveillance CPU, RAM et Disque
echo "[Test 4/5] Vérification des métriques surveillées..."
CHECKS=0

if echo "$OUTPUT" | grep -iq "cpu"; then
    echo "  ✓ Surveillance CPU détectée"
    ((CHECKS++))
fi

if echo "$OUTPUT" | grep -iq "ram\|mémoire\|mem"; then
    echo "  ✓ Surveillance RAM détectée"
    ((CHECKS++))
fi

if echo "$OUTPUT" | grep -iq "disque\|disk"; then
    echo "  ✓ Surveillance Disque détectée"
    ((CHECKS++))
fi

if [ $CHECKS -ge 2 ]; then
    echo "✓ Au moins 2 métriques sont surveillées"
    ((SCORE+=3))
elif [ $CHECKS -ge 1 ]; then
    echo "⚠ Seulement 1 métrique détectée"
    ((SCORE+=1))
else
    echo "✗ Aucune métrique de surveillance détectée"
fi

# Test 5 : Vérification de l'affichage des processus
echo "[Test 5/5] Vérification de l'affichage des processus..."
if echo "$OUTPUT" | grep -iq "processus\|process\|pid\|cpu.*mem"; then
    echo "✓ Affichage des processus détecté"
    ((SCORE+=2))
else
    echo "⚠ Affichage des processus non détecté"
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
