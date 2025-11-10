#!/bin/bash

################################################################################
# Tests automatiques pour l'exercice 1 - Table de multiplication
# Utilisé pour l'autograding GitHub Classroom
################################################################################

SCRIPT_PATH="exercices/ex1/table_multiplication.sh"
SCORE=0
MAX_SCORE=10

echo "======================================"
echo "Tests Exercice 1 - Table multiplication"
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
    echo "  (Correction appliquée automatiquement)"
fi

# Test 3 : Le script contient un shebang
echo "[Test 3/5] Vérification du shebang..."
if head -n 1 "$SCRIPT_PATH" | grep -q "^#!/bin/bash"; then
    echo "✓ Shebang correct"
    ((SCORE+=1))
else
    echo "✗ Shebang manquant ou incorrect"
fi

# Test 4 : Test fonctionnel avec entrée simple
echo "[Test 4/5] Test fonctionnel (table de 5)..."
OUTPUT=$(echo "5" | timeout 5 bash "$SCRIPT_PATH" 2>&1)
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    # Vérifier que la sortie contient les bonnes valeurs
    if echo "$OUTPUT" | grep -q "5 x 1 = 5" && \
       echo "$OUTPUT" | grep -q "5 x 10 = 50"; then
        echo "✓ Le script produit la table de multiplication correcte"
        ((SCORE+=4))
    else
        echo "✗ La sortie ne contient pas les valeurs attendues"
        echo "  Sortie reçue :"
        echo "$OUTPUT" | head -5
    fi
else
    echo "✗ Le script a échoué ou a dépassé le temps limite"
fi

# Test 5 : Vérification des commentaires
echo "[Test 5/5] Vérification de la présence de commentaires..."
COMMENT_COUNT=$(grep -c "^#" "$SCRIPT_PATH")
if [ $COMMENT_COUNT -ge 3 ]; then
    echo "✓ Le script contient des commentaires ($COMMENT_COUNT lignes)"
    ((SCORE+=2))
else
    echo "✗ Le script manque de commentaires (seulement $COMMENT_COUNT lignes)"
fi

echo ""
echo "======================================"
echo "Score final : $SCORE/$MAX_SCORE"
echo "======================================"

# Retourner un code de sortie basé sur le score
if [ $SCORE -ge 8 ]; then
    exit 0
else
    exit 1
fi
