#!/bin/bash

################################################################################
# Script principal pour lancer tous les tests du TP
################################################################################

# Couleurs
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}   TP01 - Suite de tests complète${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""

TOTAL_EXERCISES=3
EXERCISES_PASSED=0
EXERCISES_FAILED=0

# Fonction pour lancer un test
run_test() {
    local ex_number=$1
    local ex_dir="Exos/ex${ex_number}"
    local test_script="${ex_dir}/test_ex${ex_number}.sh"

    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}Exercice ${ex_number}${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""

    if [ -f "$test_script" ]; then
        cd "$ex_dir" || exit 1
        bash "test_ex${ex_number}.sh"
        EXIT_CODE=$?
        cd - > /dev/null || exit 1

        if [ $EXIT_CODE -eq 0 ]; then
            ((EXERCISES_PASSED++))
        else
            ((EXERCISES_FAILED++))
        fi
        echo ""
    else
        echo -e "${YELLOW}⚠️  Script de test non trouvé : $test_script${NC}"
        echo ""
        ((EXERCISES_FAILED++))
    fi
}

# Lancer tous les tests
run_test 1
run_test 2
run_test 3

# Résumé global
echo -e "${BLUE}============================================${NC}"
echo -e "${BLUE}   Résumé global${NC}"
echo -e "${BLUE}============================================${NC}"
echo ""
echo -e "Total d'exercices : $TOTAL_EXERCISES"
echo -e "${GREEN}Exercices validés : $EXERCISES_PASSED${NC}"
echo -e "${RED}Exercices à améliorer : $EXERCISES_FAILED${NC}"
echo ""

if [ $EXERCISES_FAILED -eq 0 ]; then
    echo -e "${GREEN}🎉 Félicitations ! Tous les exercices passent les tests !${NC}"
    echo -e "${GREEN}   Votre TP est prêt à être rendu.${NC}"
    exit 0
else
    echo -e "${YELLOW}⚠️  Certains exercices nécessitent encore du travail.${NC}"
    echo -e "${YELLOW}   Continuez à améliorer vos scripts !${NC}"
    exit 1
fi
