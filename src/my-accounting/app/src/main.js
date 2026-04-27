import { createApp } from 'vue';
import { createPinia } from 'pinia';
import { createOidcManager } from '@popforge/cluster-core';
import App from './App.vue';
import router from './router';
createOidcManager({
    authority: import.meta.env.VITE_OIDC_AUTHORITY,
    clientId: import.meta.env.VITE_OIDC_CLIENT_ID,
    scope: 'openid email profile roles',
});
createApp(App).use(createPinia()).use(router).mount('#app');
