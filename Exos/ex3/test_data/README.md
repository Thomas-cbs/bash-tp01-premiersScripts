# Fichiers de test pour l'Exercice 3

Ce dossier contient des fichiers de test pour l'exercice 3 du TP.

## Contenu

- **7 fichiers .txt** avec des noms mal formatés (espaces, majuscules)
- **3 autres fichiers** (jpg, png, sh) qui ne doivent PAS être renommés

## Utilisation

Testez votre script avec ce dossier :

```bash
cd Exos/ex3
./renommer_fichiers.sh test_data
```

## Restaurer les fichiers originaux

Après vos tests, restaurez les fichiers à leur état initial :

```bash
git restore Exos/ex3/test_data/
```

Ou :

```bash
git checkout Exos/ex3/test_data/
```

## Fichiers attendus après traitement

Les 7 fichiers .txt doivent être renommés au format :
`backup_AAAAMMJJ_nom_en_minuscules.txt`

Exemple : `Mon Document.txt` → `backup_20251117_mon_document.txt`

Les autres fichiers (image.jpg, photo.png, script.sh) doivent rester intacts.
