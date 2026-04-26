# Product Brief - Comptabilité Personnelle et Locative (Rachel)

## 1. résumé executif
- **Idée en une phrase** : Construire une application personnelle de Comptabilité locative et privée, adaptée a la situation de Rachel, pour centraliser les documents, les actions administratives et les transactions bancaires.
- **Type de produit** : Outil personnel, usage prive, non commercial.
- **Vision** : Avoir une Comptabilité claire, continue et fiable tout au long de l'année pour simplifier la fin d'année fiscale et optimiser les declarations.

## 2. Cible et contexte
- **Cible client** : Rachel uniquement.
- **Persona de reference** : [personas.md](personas.md) (`Rachel`).
- **Contexte d'usage** : Comptabilité personnelle + revenus et dépenses lies aux loyers.
- **Contrainte cle** : Le systeme doit refleter la realite quotidienne (documents recus au fil de l'eau, obligations administratives ponctuelles, suivi bancaire continu).

## 3. Probleme principal
Les pieces justificatives et obligations arrivent en continu (recus, permis, taxes, échéances, transactions bancaires). Sans un systeme unique de suivi, il existe un risque eleve :
- d'oubli d'actions importantes ;
- de perte de documents ;
- d'erreurs de classement ou de declaration ;
- de surcharge au moment de la fin d'année.

## 4. Résultat attendu (outcomes)
### Pendant l'année
- Scanner et stocker les documents directement depuis l'application mobile (photo rapide), au fur et a mesure de leur reception.
- Exemples cibles : coupon de caisse (depense déductible liee au loyer), permis de conduire, taxes municipales.
- Generer et maintenir une fiche d'actions a faire (ex. payer un permis, envoyer les taxes municipales a la banque, autrès échéances).
- Recevoir automatiquement les transactions bancaires pertinentes pour eviter la saisie manuelle repetitive.

### Fin d'année
- Produire un rapport clair des revenus et dépenses.
- Montrer explicitement :
  - ce qui a ete declare ;
  - ou cela a ete declare ;
  - quelles dépenses sont reparties sur plusieurs années.

## 5. Objectifs produit
- **Fiabilite** : reduire les oublis et les pertes documentaires.
- **Continuite** : maintenir la Comptabilité a jour de façon progressive, sans rattrapage massif de fin d'année.
- **Lisibilite fiscale** : rendre les decisions et declarations comprenables et tracables.
- **Simplicite operationnelle** : minimiser les etapes manuelles dans les flux recurrents.

## 6. Hors perimêtre (pour cette phase)
- Vente du produit a des tiers.
- Multi-utilisateur, multi-entreprise, ou collaboration externe avancee.
- Positionnement marketing B2B/B2C.

## 7. Capacites prioritaires (MVP)
1. Capture documentaire mobile ultra-rapide (photo) avec stockage iCloud et classement multi-critères : année, fournisseur, type de paiement (credit/debit/argent comptant), montant, et classification de depense déductible (ex. bureau, renovation exterieur).
2. Liste d'actions administratives avec échéances et statut.
3. Ingestion automatique des transactions bancaires.
4. Production d'un rapport annuel de synthese (revenus/dépenses/declarations/repartitions pluriannuelles).

## 8. critères de succes
- Critere #1 : depuis le mobile, Rachel peut photographier et stocker un document en quelques operations seulement ; si ce flux n'est pas simple et rapide, l'application ne sera pas utilisee.
- Les documents sont stockes dans iCloud avec un classement qui permet une recherche et une recuperation faciles selon : année, fournisseur, type de paiement, montant, et classification de depense déductible.
- Les actions administratives recurrentes sont suivies avec un statut clair.
- Les transactions bancaires sont alimentees automatiquement avec un minimum de correction manuelle.
- Le rapport annuel est suffisamment clair pour preparer la declaration sans recompilation manuelle lourde.

## 9. Hypotheses et risques
- **Hypothese** : Les integrations bancaires necessaires sont disponibles et stables pour le contexte vise.
- **Risque** : Variabilite de qualite OCR/categorisation des documents heterogenes.
- **Risque** : Complexite des regles de repartition de dépenses sur plusieurs années.

## 10. Prochaines decisions a prendre
- Niveau d'automatisation attendu pour la categorisation initiale.
- Structure cible du rapport annuel (sections, niveau de detail, format).
- Regles minimales de repartition pluriannuelle a supporter dans la V1.
- Regles exactes de classement iCloud (nomenclature de dossiers/fichiers, tags/metaDonnées, strategie de recherche).

## 11. Sources
- [project-context.md](../project-context.md)
- [personas.md](personas.md)


