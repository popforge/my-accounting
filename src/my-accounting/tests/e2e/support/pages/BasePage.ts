import { Page } from '@playwright/test';

/**
 * Page Object de base pour MyAccounting.
 * Toutes les pages héritent de cette classe.
 */
export abstract class BasePage {
  constructor(protected readonly page: Page) {}

  async attendreChargement(): Promise<void> {
    await this.page.waitForLoadState('networkidle');
  }
}
