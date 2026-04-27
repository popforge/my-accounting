import { request } from '@playwright/test';

export interface AuthSessionConfig {
  authority: string;
  clientId: string;
  scope: string;
  username: string;
  password: string;
  clientSecret?: string;
}

export interface AuthSessionToken {
  accessToken: string;
  idToken?: string;
  tokenType: string;
  expiresIn: number;
}

export async function fetchOidcToken(config: AuthSessionConfig): Promise<AuthSessionToken> {
  const api = await request.newContext();

  try {
    const body = new URLSearchParams({
      grant_type: 'password',
      client_id: config.clientId,
      username: config.username,
      password: config.password,
      scope: config.scope,
    });

    if (config.clientSecret && config.clientSecret.trim().length > 0) {
      body.set('client_secret', config.clientSecret);
    }

    const response = await api.post(`${config.authority}/connect/token`, {
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      data: body.toString(),
    });

    if (!response.ok()) {
      const details = await response.text();
      throw new Error(`OIDC token request failed (${response.status()}): ${details}`);
    }

    const payload = await response.json();

    return {
      accessToken: payload.access_token as string,
      idToken: payload.id_token as string | undefined,
      tokenType: (payload.token_type as string) ?? 'Bearer',
      expiresIn: (payload.expires_in as number) ?? 3600,
    };
  } finally {
    await api.dispose();
  }
}
