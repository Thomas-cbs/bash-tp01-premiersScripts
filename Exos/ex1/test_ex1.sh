#!/bin/bash

################################################################################
# Script de test pour l'exercice 1 : table_multiplication.sh
################################################################################

# Couleurs pour l'affichage
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Compteurs
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Fonction pour afficher les résultats
print_test_result() {
    local test_name=$1
    local result=$2
    ((TESTS_TOTAL++))

    if [ "$result" = "PASS" ]; then
        echo -e "${GREEN}✓${NC} $test_name"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗${NC} $test_name"
        ((TESTS_FAILED++))
    fi
}

echo "============================================"
echo "Tests pour l'exercice 1 : Table de multiplication"
echo "============================================"
echo ""

# Vérifier que le script existe
if [ ! -f "table_multiplication.sh" ]; then
    echo -e "${RED}Erreur : Le fichier table_multiplication.sh n'existe pas${NC}"
    exit 1
fi

# Vérifier que le script est exécutable
if [ ! -x "table_multiplication.sh" ]; then
    echo -e "${YELLOW}Avertissement : Le script n'est pas exécutable. Exécution de chmod +x...${NC}"
    chmod +x table_multiplication.sh
fi

# Test 1 : Vérifier le shebang
echo "Test 1 : Vérification du shebang..."
if head -n 1 table_multiplication.sh | grep -q "^#!/bin/bash"; then
    print_test_result "Le script contient le shebang #!/bin/bash" "PASS"
else
    print_test_result "Le script contient le shebang #!/bin/bash" "FAIL"
fi

# Test 2 : Test avec le nombre 5
echo ""
echo "Test 2 : Table de multiplication de 5..."
OUTPUT=$(echo "5" | ./table_multiplication.sh 2>/dev/null)
if echo "$OUTPUT" | grep -q "5 x 1 = 5" && \
   echo "$OUTPUT" | grep -q "5 x 10 = 50"; then
    print_test_result "Affichage correct de la table de 5" "PASS"
else
    print_test_result "Affichage correct de la table de 5" "FAIL"
    echo "  Sortie obtenue : $OUTPUT"
fi

# Test 3 : Test avec le nombre 7
echo ""
echo "Test 3 : Table de multiplication de 7..."
OUTPUT=$(echo "7" | ./table_multiplication.sh 2>/dev/null)
if echo "$OUTPUT" | grep -q "7 x 1 = 7" && \
   echo "$OUTPUT" | grep -q "7 x 5 = 35" && \
   echo "$OUTPUT" | grep -q "7 x 10 = 70"; then
    print_test_result "Affichage correct de la table de 7" "PASS"
else
    print_test_result "Affichage correct de la table de 7" "FAIL"
fi

# Test 4 : Vérifier que toutes les lignes de 1 à 10 sont présentes
echo ""
echo "Test 4 : Vérification de toutes les multiplications (1 à 10)..."
OUTPUT=$(echo "3" | ./table_multiplication.sh 2>/dev/null)
ALL_PRESENT=true
for i in {1..10}; do
    RESULT=$((3 * i))
    if ! echo "$OUTPUT" | grep -q "3 x $i = $RESULT"; then
        ALL_PRESENT=false
        break
    fi
done

if [ "$ALL_PRESENT" = true ]; then
    print_test_result "Toutes les multiplications de 1 à 10 sont présentes" "PASS"
else
    print_test_result "Toutes les multiplications de 1 à 10 sont présentes" "FAIL"
fi

# Test 5 : Vérifier la présence de commentaires
echo ""
echo "Test 5 : Vérification de la documentation..."
COMMENT_COUNT=$(grep -c "^#" table_multiplication.sh)
if [ "$COMMENT_COUNT" -gt 3 ]; then
    print_test_result "Le script contient des commentaires (au moins 3)" "PASS"
else
    print_test_result "Le script contient des commentaires (au moins 3)" "FAIL"
fi

# Résumé
echo ""
echo "============================================"
echo "Résumé des tests"
echo "============================================"
echo -e "Total : $TESTS_TOTAL tests"
echo -e "${GREEN}Réussis : $TESTS_PASSED${NC}"
echo -e "${RED}Échoués : $TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 Tous les tests sont passés ! Excellent travail !${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Certains tests ont échoué. Continuez à améliorer votre script !${NC}"
    exit 1
fi
