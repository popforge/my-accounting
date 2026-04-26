// Story 1.0 - Classement iCloud et recherche multi-critères
// AC1 : Classement standardisé — exemple de builder de document
// Ce fichier est un point de départ — enrichir au fil des stories.

namespace MyAccounting.Tests.Unit.Builders;

/// <summary>
/// Builder de données de test pour un document MyAccounting.
/// Toujours partir de valeurs par défaut valides.
/// </summary>
public class DocumentBuilder
{
    private string _nom = "2026-01-15_EDF_facture energie_45.00.pdf";
    private string _dossier = "!Facturette";
    private int _annee = 2026;
    private string _fournisseur = "EDF";
    private string _categorieDepense = "energie";
    private decimal _montant = 45.00m;

    public DocumentBuilder AvecNom(string nom)
    {
        _nom = nom;
        return this;
    }

    public DocumentBuilder AvecDossier(string dossier)
    {
        _dossier = dossier;
        return this;
    }

    public DocumentBuilder AvecAnnee(int annee)
    {
        _annee = annee;
        return this;
    }

    public DocumentBuilder AvecFournisseur(string fournisseur)
    {
        _fournisseur = fournisseur;
        return this;
    }

    public DocumentBuilder AvecCategorieDepense(string categorie)
    {
        _categorieDepense = categorie;
        return this;
    }

    public DocumentBuilder AvecMontant(decimal montant)
    {
        _montant = montant;
        return this;
    }

    // TODO : remplacer object par le vrai type Document une fois le domaine créé
    public object Construire() => new
    {
        Nom = _nom,
        Dossier = _dossier,
        Annee = _annee,
        Fournisseur = _fournisseur,
        CategorieDepense = _categorieDepense,
        Montant = _montant,
    };
}
