import { test as base, createBdd } from 'playwright-bdd';

type TestFixtures = {
  appBaseUrl: string;
  oidcAuthority: string;
  testUserEmail: string;
  testUserPassword: string;
};

/**
 * Fixtures de base partagées par tous les tests E2E MyAccounting.
 * Étendre cette fixture pour ajouter des fixtures de test spécifiques.
 */
export const test = base.extend<TestFixtures>({
  appBaseUrl: async ({}, use) => {
    await use(process.env.BASE_URL ?? 'https://my-accounting-beta.popsalon.app');
  },
  oidcAuthority: async ({}, use) => {
    await use(process.env.OIDC_AUTHORITY ?? 'https://auth-beta.popsalon.app');
  },
  testUserEmail: async ({}, use) => {
    const username = process.env.TEST_USER_EMAIL;
    if (!username) {
      throw new Error('TEST_USER_EMAIL is required for real OIDC E2E tests.');
    }
    await use(username);
  },
  testUserPassword: async ({}, use) => {
    const password = process.env.TEST_USER_PASSWORD;
    if (!password) {
      throw new Error('TEST_USER_PASSWORD is required for real OIDC E2E tests.');
    }
    await use(password);
  },
});

export const { Given, When, Then } = createBdd(test);
