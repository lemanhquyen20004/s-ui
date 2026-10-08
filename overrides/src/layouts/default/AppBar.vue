<template>
  <v-app-bar
    :elevation="0"
    class="modern-app-bar"
  >
    <v-btn
      v-if="isMobile"
      icon="mdi-menu"
      variant="text"
      class="ml-1"
      @click="$emit('toggleDrawer')"
    />
    <span
      v-else
      style="width: 24px"
    />
    <v-app-bar-title class="align-center text-center">
      <span class="d-inline-flex align-center ga-2">
        <v-icon
          icon="mdi-shield-check-outline"
          color="primary"
          size="small"
        />
        <span>{{ $t(<string>route.name) }}</span>
      </span>
    </v-app-bar-title>

    <v-chip
      v-if="maintenance"
      v-tooltip="$t('setting.maintenanceOnHint')"
      color="warning"
      variant="tonal"
      density="comfortable"
      prepend-icon="mdi-wrench"
      class="mr-2"
    >
      {{ $t('setting.maintenance') }}
    </v-chip>

    <v-btn
      v-tooltip="$t('donate')"
      icon
      variant="text"
      href="https://donate.alireza0.dev"
      target="_blank"
      rel="noopener"
      class="donate-btn"
    >
      <v-icon
        icon="mdi-heart"
        color="red"
        size="1.4em"
      />
    </v-btn>

    <v-menu>
      <template #activator="{ props }">
        <v-btn
          icon
          variant="text"
          v-bind="props"
        >
          <v-icon>mdi-translate</v-icon>
        </v-btn>
      </template>
      <v-list>
        <v-list-item
          v-for="lang in languages"
          :key="lang.value"
          :active="isActiveLocale(lang.value)"
          @click="changeLocale(lang.value)"
        >
          <v-list-item-title>{{ lang.title }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>

    <v-menu>
      <template #activator="{ props }">
        <v-btn
          icon
          variant="text"
          class="mr-1"
          v-bind="props"
        >
          <v-icon>mdi-theme-light-dark</v-icon>
        </v-btn>
      </template>
      <v-list>
        <v-list-item
          v-for="th in themes"
          :key="th.value"
          :prepend-icon="th.icon"
          :active="isActiveTheme(th.value)"
          @click="changeTheme(th.value)"
        >
          <v-list-item-title>{{ $t(`theme.${th.value}`) }}</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-menu>
  </v-app-bar>
</template>

<script lang="ts" setup>
import { useLocale } from 'vuetify'
import { useRoute } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { languages } from '@/locales'
import { useThemeSwitcher } from '@/composables/useThemeSwitcher'
import { computed } from 'vue'
import Data from '@/store/modules/data'

defineProps<{ isMobile: boolean }>()
defineEmits<{ toggleDrawer: [] }>()

const route = useRoute()
const { locale: i18nLocale } = useI18n()
const vuetifyLocale = useLocale()
const { themes, changeTheme, isActiveTheme } = useThemeSwitcher()

const changeLocale = (l: string) => {
  i18nLocale.value = l
  vuetifyLocale.current.value = l
  localStorage.setItem('locale', l)
  window.location.reload()
}
const isActiveLocale = (l: string) => i18nLocale.value === l
const maintenance = computed((): boolean => Data().maintenance)
</script>
