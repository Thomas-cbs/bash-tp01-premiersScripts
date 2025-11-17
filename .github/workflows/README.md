# Workflows GitHub Actions

Ce dossier contient deux workflows complémentaires :

## 1. `autograding.yml` - Tests détaillés

- Lance tous les tests individuellement
- Affiche des logs détaillés pour chaque exercice
- Utile pour le debugging
- S'exécute sur `push` et `pull_request`

## 2. `classroom.yml` - Intégration GitHub Classroom

- Utilise l'action officielle `education/autograding`
- Synchronise les scores avec GitHub Classroom
- Met à jour le gradebook automatiquement
- Ne s'exécute que pour les vrais étudiants (pas le bot)

## Pour les étudiants

Les deux workflows s'exécutent automatiquement à chaque `git push`.

Consultez l'onglet **Actions** de votre dépôt pour :
- Voir si vos tests passent ✅ ou échouent ❌
- Consulter les logs détaillés
- Identifier les problèmes à corriger

## Pour les enseignants

Les résultats sont visibles dans :
- GitHub Classroom → Assignment → Étudiant → Note automatique
- L'onglet Actions de chaque dépôt étudiant
