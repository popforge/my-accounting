import { createClusterFixtures } from '@popforge/cluster-core/testing'

// Fixtures de base partagées par tous les tests E2E MyAccounting.
// La logique générique (appBaseUrl, oidcAuthority, testUserEmail, testUserPassword)
// vit dans @popforge/cluster-core/testing — MyAccounting consomme, ne duplique pas.
export const { test, Given, When, Then } = createClusterFixtures({
  appBaseUrl: 'https://my-accounting-beta.popsalon.app',
  oidcAuthority: 'https://auth-beta.popsalon.app',
})