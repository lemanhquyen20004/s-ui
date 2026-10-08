<template>
  <v-container
    fluid
    class="sui-login-shell d-flex align-center justify-center pa-4"
  >
    <v-row
      justify="center"
      align="center"
      class="ma-0"
    >
      <v-col
        cols="12"
        sm="9"
        md="6"
        lg="4"
        xl="3"
      >
        <v-card class="sui-login-card pa-2 pa-sm-4">
          <v-card-text class="pa-5 pa-sm-7">
            <div class="text-center mb-7">
              <v-img
                :src="logoUrl"
                class="sui-login-logo mb-4"
              />
              <div class="sui-login-title">
                S-UI
              </div>
              <div class="sui-login-subtitle mt-1">
                {{ $t('login.title') }}
              </div>
            </div>

            <v-form
              ref="form"
              @submit.prevent="login"
            >
              <v-text-field
                v-model="username"
                :label="$t('login.username')"
                :rules="usernameRules"
                prepend-inner-icon="mdi-account-outline"
                variant="outlined"
                required
              />
              <v-text-field
                v-model="password"
                :label="$t('login.password')"
                :rules="passwordRules"
                prepend-inner-icon="mdi-lock-outline"
                type="password"
                variant="outlined"
                required
              />
              <v-btn
                :loading="loading"
                type="submit"
                color="primary"
                size="large"
                block
                class="mt-2"
              >
                {{ $t('actions.submit') }}
              </v-btn>
            </v-form>

            <div class="d-flex align-center ga-2 mt-5">
              <v-select
                v-model="$i18n.locale"
                density="comfortable"
                hide-details
                variant="outlined"
                :items="languages"
                prepend-inner-icon="mdi-translate"
                @update:model-value="changeLocale"
              />
              <v-menu>
                <template #activator="{ props }">
                  <v-btn
                    v-bind="props"
                    icon="mdi-theme-light-dark"
                    variant="tonal"
                    color="primary"
                    size="large"
                    :aria-label="$t('theme.auto')"
                  />
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
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang="ts" setup>
import { ref } from 'vue'
import { useLocale } from 'vuetify'
import { i18n, languages } from '@/locales'
import { useRouter } from 'vue-router'
import HttpUtil from '@/plugins/httputil'
import { setAuthenticated } from '@/plugins/auth'
import { useThemeSwitcher } from '@/composables/useThemeSwitcher'
import logoUrl from '@/assets/logo.svg'

const locale = useLocale()
const { themes, changeTheme, isActiveTheme } = useThemeSwitcher()

const username = ref('')
const usernameRules = [
  (value: string) => {
    if (value?.length > 0) return true
    return i18n.global.t('login.unRules')
  },
]

const password = ref('')
const passwordRules = [
  (value: string) => {
    if (value?.length > 0) return true
    return i18n.global.t('login.pwRules')
  },
]

const loading = ref(false)
const router = useRouter()

const login = async () => {
  if (username.value === '' || password.value === '') return
  loading.value = true
  const response = await HttpUtil.post('api/login', { user: username.value, pass: password.value })
  if (response.success) {
    setAuthenticated()
    setTimeout(() => {
      loading.value = false
      router.push('/')
    }, 500)
  } else {
    loading.value = false
  }
}

const changeLocale = (l: string | null) => {
  locale.current.value = l ?? 'en'
  localStorage.setItem('locale', locale.current.value)
}
</script>
