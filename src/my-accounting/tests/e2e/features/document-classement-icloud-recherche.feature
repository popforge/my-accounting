# language: fr
@draft @epic-1 @story-1-0 @area-documents @component-classement
Fonctionnalité: Classement iCloud et recherche multi-critères
  En tant que Rachel
  Je veux que chaque document capturé soit classé automatiquement dans iCloud selon des règles claires
  Et retrouvable avec des filtres combinés
  Afin de retrouver mes pièces en quelques secondes sans fouiller manuellement

  Contexte:
    Soit les documents suivants dans mon index :
      | nomFichier                                           | annee | fournisseur | typeDepense    | montant | categorieDepense |
      | 2026-01-15_EDF_facture energie_45.00.pdf             | 2026  | EDF         | debit          | 45.00   | energie          |
      | 2026-02-01_Rona_materiel renovation_128.50.pdf        | 2026  | Rona        | credit         | 128.50  | renovation       |
      | 2025-12-20_Metro_epicerie_67.30.pdf                   | 2025  | Metro       | argent_comptant| 67.30   | alimentation     |
      | 2026-03-10_Desjardins_taxes municipales_1200.00.pdf  | 2026  | Desjardins  | debit          | 1200.00 | taxes            |

  @acceptance @p0
  Scénario: Classement standardisé d'un document à l'enregistrement
    Quand j'ouvre la fiche du document "2026-01-15_EDF_facture energie_45.00.pdf"
    Alors je vois les informations de classement suivantes :
      | Champ            | Valeur    |
      | Année            | 2026      |
      | Fournisseur      | EDF       |
      | Type de dépense  | Débit     |
      | Montant          | 45,00 $   |
      | Catégorie        | énergie   |

  @acceptance @p0
  Scénario: Recherche multi-critères combinée
    Quand je filtre les documents avec l'année "2026" et le type de dépense "debit"
    Alors je vois 3 documents dans les résultats
    Et je ne vois pas le document "2025-12-20_Metro_epicerie_67.30.pdf"

  @acceptance @p1
  Scénario: Résultats de recherche affichent les informations de classement
    Quand je filtre les documents avec la catégorie "energie"
    Alors je vois 1 document dans les résultats
    Et chaque résultat affiche le fournisseur, l'année, la catégorie et le montant

  @acceptance @p1
  Scénario: Modification du classement d'un document
    Quand je modifie le classement du document "2026-02-01_Rona_materiel renovation_128.50.pdf"
      Et je change la catégorie pour "bureau"
    Alors le document apparaît dans les résultats quand je filtre par catégorie "bureau"
    Et le document n'apparaît plus dans les résultats quand je filtre par catégorie "renovation"

  @acceptance @p2
  Plan du scénario: Recherche par fournisseur (recherche partielle)
    Quand je filtre les documents avec le fournisseur "<terme>"
    Alors je vois "<nb>" document(s) dans les résultats

    Exemples:
      | terme | nb |
      | EDF   | 1  |
      | ron   | 1  |
      | des   | 1  |
