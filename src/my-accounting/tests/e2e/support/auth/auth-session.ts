// Réexporte depuis @popforge/cluster-core/testing
// Le code générique OIDC vit dans Shared — MyAccounting consomme, ne duplique pas.
export {
  fetchOidcToken,
  getOidcBearerHeader,
  type OidcTokenConfig,
  type OidcToken,
} from '@popforge/cluster-core/testing'