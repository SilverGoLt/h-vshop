import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'
import './font.css'

// Pinia Setup
const pinia = createPinia()


createApp(App)
.use(pinia)
.mount('#app')