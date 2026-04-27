<template>
  <main class="page">
    <h1>MyAccounting</h1>
    <p>Authentification OIDC active.</p>
    <button type="button" class="btn" @click="logout">Se deconnecter</button>
  </main>
</template>

<script setup lang="ts">
import { useAuth } from '@popforge/cluster-core'

const { logout } = useAuth()
</script>

<style scoped>
.page {
  min-height: 100vh;
  display: grid;
  place-content: center;
  gap: 0.75rem;
  text-align: center;
}

.btn {
  padding: 0.65rem 1rem;
}
</style>
