<template>
  <v-navigation-drawer
    v-model="showDrawer"
    :temporary="isMobile"
    :expand-on-hover="!isMobile"
    :rail="!isMobile"
    :permanent="!isMobile"
    class="modern-nav"
    @click="isMobile ? $emit('toggleDrawer') : null"
  >
    <v-list-item
      height="68"
      prepend-avatar="@/assets/logo.svg"
      title="S-UI"
      subtitle="sing-box"
      class="sui-brand"
    >
      <template
        v-if="isMobile"
        #append
      >
        <v-btn
          icon="mdi-close"
          variant="text"
          size="small"
        />
      </template>
    </v-list-item>

    <v-divider class="mx-3 my-2" />

    <v-list
      density="compact"
      nav
      class="px-0"
    >
      <v-list-item
        v-for="item in menu"
        :key="item.title"
        link
        :to="item.path"
        :active="router.currentRoute.value.path == item.path"
      >
        <template #prepend>
          <v-icon :icon="item.icon" />
        </template>
        <v-list-item-title>{{ $t(item.title) }}</v-list-item-title>
      </v-list-item>
    </v-list>

    <template #append>
      <v-divider class="mx-3 mb-2" />
      <v-list-item
        prepend-icon="mdi-logout"
        :title="$t('menu.logout')"
        class="mb-2"
        @click="Logout"
      />
    </template>
  </v-navigation-drawer>
</template>

<script lang="ts" setup>
import { computed } from 'vue'
import router from '@/router'
import { logout } from '@/plugins/httputil'

const props = defineProps<{ isMobile: boolean, displayDrawer: boolean }>()
defineEmits<{ toggleDrawer: [] }>()

const showDrawer = computed((): boolean => {
  return props.displayDrawer
})

const menu = [
  { title: 'pages.home', icon: 'mdi-view-dashboard-outline', path: '/' },
  { title: 'pages.inbounds', icon: 'mdi-cloud-download-outline', path: '/inbounds' },
  { title: 'pages.clients', icon: 'mdi-account-group-outline', path: '/clients' },
  { title: 'pages.outbounds', icon: 'mdi-cloud-upload-outline', path: '/outbounds' },
  { title: 'pages.endpoints', icon: 'mdi-cloud-tags-outline', path: '/endpoints' },
  { title: 'pages.services', icon: 'mdi-server-outline', path: '/services' },
  { title: 'pages.tls', icon: 'mdi-certificate-outline', path: '/tls' },
  { title: 'pages.basics', icon: 'mdi-tune-variant', path: '/basics' },
  { title: 'pages.rules', icon: 'mdi-routes', path: '/rules' },
  { title: 'pages.dns', icon: 'mdi-dns-outline', path: '/dns' },
  { title: 'pages.admins', icon: 'mdi-account-tie-outline', path: '/admins' },
  { title: 'pages.settings', icon: 'mdi-cog-outline', path: '/settings' },
]

const Logout = async () => {
  logout()
}
</script>
