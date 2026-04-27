import { defineConfig, devices } from '@playwright/test';
import { defineBddConfig } from 'playwright-bdd';

const testDir = defineBddConfig({
  features: './features/*.feature',
  steps: ['./steps/**/*.ts', './support/fixtures/base.fixtures.ts'],
});

export default defineConfig({
  testDir,
  fullyParallel: false,
  forbidOnly: !!process.env.CI,
  retries: process.env.CI ? 1 : 0,
  workers: process.env.CI ? 1 : undefined,
  reporter: [
    ['html', { open: 'never' }],
    ['list'],
  ],
  use: {
    baseURL: process.env.BASE_URL ?? (process.env.CI ? 'https://my-accounting-beta.popsalon.app' : 'http://localhost:5175'),
    trace: 'on-first-retry',
    screenshot: 'only-on-failure',
    locale: 'fr-CA',
    timezoneId: 'America/Toronto',
  },
  projects: [
    {
      name: 'chromium',
      use: { ...devices['Desktop Chrome'] },
    },
  ],
});
