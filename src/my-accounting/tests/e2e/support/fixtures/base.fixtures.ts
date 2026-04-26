import { test as base, createBdd } from 'playwright-bdd';

/**
 * Fixtures de base partagées par tous les tests E2E MyAccounting.
 * Étendre cette fixture pour ajouter des fixtures de test spécifiques.
 */
export const test = base.extend<{
  // Ajouter les fixtures de test ici au besoin
}>({});

export const { Given, When, Then, And } = createBdd(test);
