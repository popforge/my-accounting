import { expect } from '@playwright/test';
import { Given, When, Then } from '../support/fixtures/base.fixtures';

let currentAppBaseUrl = '';
let currentOidcAuthority = '';
let redirectedToAuth = false;
let callbackSeen = false;

Given('que je ne suis pas authentifiée', async ({ page, appBaseUrl, oidcAuthority }) => {
  currentAppBaseUrl = appBaseUrl;
  currentOidcAuthority = oidcAuthority;
  redirectedToAuth = false;
  callbackSeen = false;

  await page.context().clearCookies();
  await page.goto(`${appBaseUrl}/`, { waitUntil: 'domcontentloaded' });
  await page.evaluate(() => {
    localStorage.clear();
    sessionStorage.clear();
  });
});

When('j\'accède à la page de recherche de documents', async ({ page, appBaseUrl, oidcAuthority }) => {
  currentAppBaseUrl = appBaseUrl;
  currentOidcAuthority = oidcAuthority;

  // Network-first: subscribe before triggering navigation.
  const authRedirect = page.waitForURL((url) => url.toString().startsWith(oidcAuthority), {
    timeout: 20000,
  });

  await page.goto(`${appBaseUrl}/`, { waitUntil: 'domcontentloaded' });
  await authRedirect;
  redirectedToAuth = true;
});

Then('je suis redirigée vers la page de connexion Popforge.Auth', async ({ page }) => {
  expect(redirectedToAuth).toBeTruthy();
  expect(page.url().startsWith(currentOidcAuthority)).toBeTruthy();
});

Then('aucune page de l\'application n\'est affichée', async ({ page }) => {
  const currentUrl = page.url();
  expect(currentUrl.startsWith(currentAppBaseUrl)).toBeFalsy();
});

Given('que je viens de me connecter sur Popforge.Auth', async ({ page, appBaseUrl, oidcAuthority, testUserEmail, testUserPassword }) => {
  currentAppBaseUrl = appBaseUrl;
  currentOidcAuthority = oidcAuthority;
  callbackSeen = false;

  const authRedirect = page.waitForURL((url) => url.toString().startsWith(oidcAuthority), {
    timeout: 30000,
  });
  await page.goto(`${appBaseUrl}/`, { waitUntil: 'domcontentloaded' });
  await authRedirect;

  const emailInput = page.locator('input[name="Input.Email"], input[type="email"], #Input_Email').first();
  const passwordInput = page.locator('input[name="Input.Password"], input[type="password"], #Input_Password').first();
  await emailInput.fill(testUserEmail);
  await passwordInput.fill(testUserPassword);

  const callbackPromise = page.waitForURL((url) => url.pathname.includes('/auth/callback'), {
    timeout: 30000,
  });

  const submit = page.locator('button[type="submit"], input[type="submit"]').first();
  await submit.click();

  try {
    await callbackPromise;
    callbackSeen = true;
  } catch {
    // Some implementations immediately replace callback URL to /.
    callbackSeen = page.url().startsWith(appBaseUrl);
  }
});

When('je suis redirigée vers l\'application via le callback "/auth/callback"', async ({ page, appBaseUrl }) => {
  // Ensure final navigation settles on the app domain.
  await page.waitForURL((url) => url.toString().startsWith(appBaseUrl), { timeout: 30000 });
});

Then('je suis sur la page d\'accueil de l\'application', async ({ page, appBaseUrl }) => {
  expect(page.url().startsWith(appBaseUrl)).toBeTruthy();
});

Then('ma session est active', async ({ page, appBaseUrl }) => {
  expect(callbackSeen).toBeTruthy();
  await page.goto(`${appBaseUrl}/`, { waitUntil: 'domcontentloaded' });
  expect(page.url().startsWith(currentOidcAuthority)).toBeFalsy();
});
