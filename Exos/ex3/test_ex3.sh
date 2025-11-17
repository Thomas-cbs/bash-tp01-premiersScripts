#!/bin/bash

################################################################################
# Script de test pour l'exercice 3 : renommer_fichiers.sh
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

# Fonction de nettoyage
cleanup() {
    if [ -d "test_temp" ]; then
        rm -rf test_temp
    fi
}

echo "============================================"
echo "Tests pour l'exercice 3 : Renommer fichiers"
echo "============================================"
echo ""

# Vérifier que le script existe
if [ ! -f "renommer_fichiers.sh" ]; then
    echo -e "${RED}Erreur : Le fichier renommer_fichiers.sh n'existe pas${NC}"
    exit 1
fi

# Vérifier que le script est exécutable
if [ ! -x "renommer_fichiers.sh" ]; then
    echo -e "${YELLOW}Avertissement : Le script n'est pas exécutable. Exécution de chmod +x...${NC}"
    chmod +x renommer_fichiers.sh
fi

# Nettoyage au début
cleanup

# Test 1 : Vérifier le shebang
echo "Test 1 : Vérification du shebang..."
if head -n 1 renommer_fichiers.sh | grep -q "^#!/bin/bash"; then
    print_test_result "Le script contient le shebang #!/bin/bash" "PASS"
else
    print_test_result "Le script contient le shebang #!/bin/bash" "FAIL"
fi

# Test 2 : Sans paramètre (doit afficher une erreur)
echo ""
echo "Test 2 : Exécution sans paramètre (doit échouer)..."
OUTPUT=$(./renommer_fichiers.sh 2>&1)
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
    print_test_result "Le script détecte l'absence de paramètre" "PASS"
else
    print_test_result "Le script détecte l'absence de paramètre" "FAIL"
fi

# Test 3 : Avec un dossier inexistant (doit afficher une erreur)
echo ""
echo "Test 3 : Exécution avec un dossier inexistant (doit échouer)..."
OUTPUT=$(./renommer_fichiers.sh /dossier/inexistant 2>&1)
EXIT_CODE=$?
if [ $EXIT_CODE -ne 0 ]; then
    print_test_result "Le script détecte un dossier inexistant" "PASS"
else
    print_test_result "Le script détecte un dossier inexistant" "FAIL"
fi

# Créer un dossier de test temporaire
echo ""
echo "Préparation d'un environnement de test..."
mkdir -p test_temp
cd test_temp
touch "Fichier TEST.txt"
touch "DOCUMENT Important.txt"
touch "Rapport FINAL.txt"
touch "image.jpg"
touch "script.sh"
cd ..

# Test 4 : Renommage basique
echo ""
echo "Test 4 : Test de renommage avec des fichiers réels..."
./renommer_fichiers.sh test_temp > /dev/null 2>&1
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    print_test_result "Le script s'exécute sans erreur" "PASS"
else
    print_test_result "Le script s'exécute sans erreur" "FAIL"
fi

# Test 5 : Vérifier la conversion en minuscules
echo ""
echo "Test 5 : Vérification de la conversion en minuscules..."
LOWERCASE_COUNT=$(ls test_temp/*.txt 2>/dev/null | grep -c "[a-z]")
UPPERCASE_COUNT=$(ls test_temp/*.txt 2>/dev/null | grep -c "[A-Z]")

if [ -f test_temp/*.txt ] && [ $LOWERCASE_COUNT -gt 0 ]; then
    # Vérifier qu'il n'y a plus de majuscules dans les noms de fichiers .txt
    HAS_UPPERCASE=false
    for file in test_temp/*.txt; do
        basename_file=$(basename "$file")
        if echo "$basename_file" | grep -q "[A-Z]"; then
            HAS_UPPERCASE=true
            break
        fi
    done

    if [ "$HAS_UPPERCASE" = false ]; then
        print_test_result "Les noms de fichiers .txt sont en minuscules" "PASS"
    else
        print_test_result "Les noms de fichiers .txt sont en minuscules" "FAIL"
    fi
else
    print_test_result "Les noms de fichiers .txt sont en minuscules" "FAIL"
fi

# Test 6 : Vérifier le remplacement des espaces par des underscores
echo ""
echo "Test 6 : Vérification du remplacement des espaces..."
HAS_SPACES=false
for file in test_temp/*.txt 2>/dev/null; do
    if [[ -f "$file" && $(basename "$file") == *" "* ]]; then
        HAS_SPACES=true
        break
    fi
done

if [ "$HAS_SPACES" = false ]; then
    print_test_result "Les espaces sont remplacés par des underscores" "PASS"
else
    print_test_result "Les espaces sont remplacés par des underscores" "FAIL"
fi

# Test 7 : Vérifier le préfixe avec la date
echo ""
echo "Test 7 : Vérification du préfixe avec la date..."
TODAY=$(date +%Y%m%d)
HAS_DATE_PREFIX=false
for file in test_temp/*.txt 2>/dev/null; do
    if [[ -f "$file" && $(basename "$file") == backup_${TODAY}_* ]]; then
        HAS_DATE_PREFIX=true
        break
    fi
done

if [ "$HAS_DATE_PREFIX" = true ]; then
    print_test_result "Le préfixe avec la date est ajouté (backup_AAAAMMJJ_)" "PASS"
else
    print_test_result "Le préfixe avec la date est ajouté (backup_AAAAMMJJ_)" "FAIL"
fi

# Test 8 : Vérifier que les fichiers non-.txt ne sont pas renommés
echo ""
echo "Test 8 : Vérification que les fichiers non-.txt restent intacts..."
NON_TXT_INTACT=true
if [ ! -f "test_temp/image.jpg" ] || [ ! -f "test_temp/script.sh" ]; then
    NON_TXT_INTACT=false
fi

if [ "$NON_TXT_INTACT" = true ]; then
    print_test_result "Les fichiers non-.txt ne sont pas modifiés" "PASS"
else
    print_test_result "Les fichiers non-.txt ne sont pas modifiés" "FAIL"
fi

# Test 9 : Vérifier la présence de commentaires
echo ""
echo "Test 9 : Vérification de la documentation..."
COMMENT_COUNT=$(grep -c "#" renommer_fichiers.sh)
if [ "$COMMENT_COUNT" -gt 5 ]; then
    print_test_result "Le script contient des commentaires (au moins 5)" "PASS"
else
    print_test_result "Le script contient des commentaires (au moins 5)" "FAIL"
fi

# Test 10 : Vérifier l'utilisation de la commande date
echo ""
echo "Test 10 : Vérification de l'utilisation de la commande date..."
if grep -q "date" renommer_fichiers.sh; then
    print_test_result "Le script utilise la commande date" "PASS"
else
    print_test_result "Le script utilise la commande date" "FAIL"
fi

# Nettoyage
cleanup

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
