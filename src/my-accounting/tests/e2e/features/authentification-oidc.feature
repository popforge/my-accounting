# language: fr
@epic-0 @story-0-0 @area-authentification @component-oidc
Fonctionnalité: Authentification OIDC avec Popforge.Auth
  En tant que Rachel
  Je veux pouvoir me connecter à mon application avec mon compte Popforge
  Et être assurée qu'aucun contenu n'est accessible sans session valide
  Afin d'avoir un accès sécurisé dès la première utilisation

  @acceptance @p0
  Scénario: Accès à une route protégée sans session active
    Étant donné que je ne suis pas authentifiée
    Quand j'accède à la page de recherche de documents
    Alors je suis redirigée vers la page de connexion Popforge.Auth
    Et aucune page de l'application n'est affichée

  @acceptance @p0
  Scénario: Retour sur l'application après connexion réussie
    Étant donné que je viens de me connecter sur Popforge.Auth
    Quand je suis redirigée vers l'application via le callback "/auth/callback"
    Alors je suis sur la page d'accueil de l'application
    Et ma session est active
