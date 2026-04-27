import { createRouter, createWebHistory } from 'vue-router';
import { addOidcGuard, addOidcRoutes } from '@popforge/cluster-core';
const HomePage = () => import('../views/HomePage.vue');
const router = createRouter({
    history: createWebHistory(),
    routes: [
        {
            path: '/',
            name: 'home',
            component: HomePage,
            meta: { requiresAuth: true },
        },
    ],
});
addOidcRoutes(router);
addOidcGuard(router);
export default router;
