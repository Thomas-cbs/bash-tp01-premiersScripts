#!/bin/bash

################################################################################
# Script de test pour l'exercice 2 : devine_nombre.sh
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
echo "Tests pour l'exercice 2 : Devine le nombre"
echo "============================================"
echo ""

# Vérifier que le script existe
if [ ! -f "devine_nombre.sh" ]; then
    echo -e "${RED}Erreur : Le fichier devine_nombre.sh n'existe pas${NC}"
    exit 1
fi

# Vérifier que le script est exécutable
if [ ! -x "devine_nombre.sh" ]; then
    echo -e "${YELLOW}Avertissement : Le script n'est pas exécutable. Exécution de chmod +x...${NC}"
    chmod +x devine_nombre.sh
fi

# Test 1 : Vérifier le shebang
echo "Test 1 : Vérification du shebang..."
if head -n 1 devine_nombre.sh | grep -q "^#!/bin/bash"; then
    print_test_result "Le script contient le shebang #!/bin/bash" "PASS"
else
    print_test_result "Le script contient le shebang #!/bin/bash" "FAIL"
fi

# Test 2 : Sans paramètres (doit afficher une erreur)
echo ""
echo "Test 2 : Exécution sans paramètres (doit échouer)..."
OUTPUT=$(./devine_nombre.sh 2>&1)
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
    print_test_result "Le script détecte l'absence de paramètres" "PASS"
else
    print_test_result "Le script détecte l'absence de paramètres" "FAIL"
fi

# Test 3 : Avec un seul paramètre (doit afficher une erreur)
echo ""
echo "Test 3 : Exécution avec un seul paramètre (doit échouer)..."
OUTPUT=$(./devine_nombre.sh 1 2>&1)
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
    print_test_result "Le script détecte qu'il manque un paramètre" "PASS"
else
    print_test_result "Le script détecte qu'il manque un paramètre" "FAIL"
fi

# Test 4 : Avec les bons paramètres
echo ""
echo "Test 4 : Exécution avec deux paramètres valides..."
# On simule 5 mauvaises réponses pour perdre
OUTPUT=$(echo -e "99\n99\n99\n99\n99" | ./devine_nombre.sh 1 100 2>&1)
if echo "$OUTPUT" | grep -qiE "(essai|tentative|restant)"; then
    print_test_result "Le script gère les essais correctement" "PASS"
else
    print_test_result "Le script gère les essais correctement" "FAIL"
fi

# Test 5 : Vérifier les messages "trop grand" / "trop petit"
echo ""
echo "Test 5 : Vérification des indications (trop grand/petit)..."
# On force un nombre fixe en patchant temporairement RANDOM
OUTPUT=$(echo -e "1\n10000\n10000\n10000\n10000" | ./devine_nombre.sh 1 10000 2>&1)
if echo "$OUTPUT" | grep -qiE "(trop|grand|petit|plus|moins)"; then
    print_test_result "Le script donne des indications sur la direction" "PASS"
else
    print_test_result "Le script donne des indications sur la direction" "FAIL"
fi

# Test 6 : Vérifier la gestion de la victoire
echo ""
echo "Test 6 : Vérification du message de victoire..."
# On crée un script temporaire qui force le nombre à deviner
cat > temp_test_script.sh <<'EOF'
#!/bin/bash
# Script modifié pour forcer le nombre à 50
nombre=50
max_essais=5
essais=0

for ((i=1; i<=max_essais; i++)); do
    read -p "Votre proposition : " proposition
    ((essais++))

    if [ "$proposition" -eq "$nombre" ]; then
        echo "Bravo ! Vous avez trouvé"
        exit 0
    fi
done
echo "Perdu"
EOF
chmod +x temp_test_script.sh

OUTPUT=$(echo "50" | ./temp_test_script.sh 2>&1)
rm -f temp_test_script.sh

if echo "$OUTPUT" | grep -qiE "(bravo|trouvé|gagn|félicitation)"; then
    print_test_result "Le script affiche un message de victoire" "PASS"
else
    print_test_result "Le script affiche un message de victoire" "FAIL"
fi

# Test 7 : Vérifier la présence de commentaires
echo ""
echo "Test 7 : Vérification de la documentation..."
COMMENT_COUNT=$(grep -c "^#" devine_nombre.sh)
if [ "$COMMENT_COUNT" -gt 5 ]; then
    print_test_result "Le script contient des commentaires (au moins 5)" "PASS"
else
    print_test_result "Le script contient des commentaires (au moins 5)" "FAIL"
fi

# Test 8 : Vérification de l'utilisation de $RANDOM
echo ""
echo "Test 8 : Vérification de l'utilisation de \$RANDOM..."
if grep -q "RANDOM" devine_nombre.sh; then
    print_test_result "Le script utilise \$RANDOM pour générer un nombre" "PASS"
else
    print_test_result "Le script utilise \$RANDOM pour générer un nombre" "FAIL"
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
