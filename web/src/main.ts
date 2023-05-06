import { createApp } from 'vue'
import { createPinia } from 'pinia'
//@ts-ignore
import { MotionPlugin } from '@vueuse/motion'
import './style.css'
import App from './App.vue'

const pinia = createPinia()

createApp(App)
.use(pinia)
.use(MotionPlugin)
.mount('#app')
