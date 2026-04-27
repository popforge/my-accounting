/// <reference types="vite/client" />

declare interface ImportMetaEnv {
  readonly VITE_OIDC_AUTHORITY: string
  readonly VITE_OIDC_CLIENT_ID: string
}

declare interface ImportMeta {
  readonly env: ImportMetaEnv
}
