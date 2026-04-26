## GitHub Repository Defaults (PopSalon)

- Owner GitHub: `my-accounting`
- Repository Name: `hub`
- Repos actuel: `https://github.com/popforge/my-accounting.git`
- Visibilite par defaut pour les repos PopSalon: `private`

## Overview
Ce projet sert au développement d'une application qui me permet de faire ma propre comptabilité personnelle et locative, en utilisant ou pas SigaFinance evo selon la solution qui sera la meilleure. L'objectif est d'avoir une solution qui me convient parfaitement, que je peux faire évoluer facilement au fil du temps, et qui me permet de mieux comprendre ma comptabilité pour optimiser mes déclarations et payer le moins d'impôts possible.

Je ne revendrai pas ce produit, je peux être la seule qui a accès. 

### Services tiers

Pour optimiser des coûts et ressources, j'utiliserai, si pertinent, des plateformes  déjà existantes pour d'autres projets. Actuellement j'ai ceci ; 

- **DNS** : Cloudflare, zone `popsalon.app`
- **TLS** : Let's Encrypt via certbot sur la VM
- **PostgreSQL** : Neon (https://console.neon.tech/)
- **Email** : Resend (https://resend.com/)
- **SMS** : Twilio
- **OIDC** : OpenIddict (.NET) — cluster `auth` (`auth.popsalon.app`)

