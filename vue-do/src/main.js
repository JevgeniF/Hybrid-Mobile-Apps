import { createApp } from 'vue'
import Master from './layouts/Master'
import { library } from '@fortawesome/fontawesome-svg-core'
import { faStar, faBell, faCheck, faCaretDown, faEdit } from '@fortawesome/free-solid-svg-icons'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import 'animate.css/animate.min.css'
import { store } from './store/store'
import router from './router'
import './registerServiceWorker'

library.add(faStar, faBell, faCheck, faCaretDown, faEdit)

router.beforeEach((to, from, next) => {
  // noinspection JSUnresolvedVariable
  if (to.matched.some(record => record.meta.requiresAuthentication)) {
    if (!store.getters.loggedIn) {
      next({
        name: 'sign-in'
      })
    } else {
      next()
    }
  } else { // noinspection JSUnresolvedVariable
    if (to.matched.some(record => record.meta.requiresVisitor)) {
      if (store.getters.loggedIn) {
        next({
          name: 'todos'
        })
      } else {
        next()
      }
    }
  }
})

createApp(Master)
  .component('font-awesome-icon', FontAwesomeIcon)
  .use(store)
  .use(router)
  .mount('#app')
