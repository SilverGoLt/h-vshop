import { createApp } from 'vue'
import App from './App.vue'
import './font.css'

/* import the fontawesome core */
import { library } from '@fortawesome/fontawesome-svg-core'

/* import font awesome icon component */
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

/* import specific icons */
import { faSignal, faWifi, faBattery } from '@fortawesome/free-solid-svg-icons'

import { faFacebookMessenger } from '@fortawesome/free-brands-svg-icons'

/* add icons to the library */
library.add(faSignal, faWifi, faBattery, faFacebookMessenger)

createApp(App)
.component("font-awesome-icon", FontAwesomeIcon)
.mount('#app')