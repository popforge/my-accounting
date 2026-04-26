# Runbook - Rebuild index documentaire

## Objectif

Définir la procédure opérationnelle pour reconstruire l'index documentaire PostgreSQL lorsque l'index est indisponible, corrompu ou incomplet.

## Portee

- Application : MyAccounting
- Source de vérité documentaire : iCloud Drive
- Cible de reconstruction : index documentaire PostgreSQL

## Conditions de declenchement

- Échec de recherche sur des documents pourtant présents dans iCloud
- Table index vide ou corrompue
- Incohérence massive entre documents sources et résultats de recherche

## Prerequis

- Accès à l'environnement cible (beta ou production)
- Accès opérationnel à PostgreSQL
- Accès de lecture au chemin iCloud source
- Fenêtre de maintenance validée (si nécessaire)

## Procédure

1. Vérifier l'incident et confirmer que le problème vient bien de l'index.
2. Mettre l'import/sync incrémental en pause pendant la reconstruction.
3. Sauvegarder un snapshot logique de l'index actuel (optionnel mais recommandé en diagnostic).
4. Purger ou recréer les tables d'index selon le mécanisme prévu par l'application.
5. Lancer un import complet depuis la racine iCloud configurée.
6. Surveiller la progression et relever les erreurs de parsing/fichiers non conformes.
7. Relancer une passe incrémentale à la demande pour capter les derniers changements.
8. Réouvrir la recherche et valider le retour au fonctionnement nominal.

## Validation post-rebuild

- Le nombre de documents indexés est cohérent avec iCloud
- Les filtres clés (année, fournisseur, type de paiement, montant, catégorie) retournent des résultats attendus
- Un échantillon de documents critiques est retrouvable en moins de quelques secondes

## Gestion des erreurs

- Si des fichiers restent non importables, les lister dans un rapport d'anomalies
- Corriger les cas de nommage non conforme puis relancer un import incrémental

## Journalisation minimale

Conserver la trace de :
- date/heure du rebuild
- environnement cible
- nombre total de documents indexés
- nombre d'erreurs résiduelles
- action corrective prévue

## RTO/RPO cibles (à affiner)

- RTO cible : 4 h
- RPO cible : 24 h (selon la fréquence des imports incrémentaux)
