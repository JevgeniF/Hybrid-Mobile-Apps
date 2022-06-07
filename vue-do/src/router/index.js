// noinspection JSCheckFunctionSignatures

import { createRouter, createWebHistory } from 'vue-router'
import App from '../App'
import Settings from '../views/Settings'
import SignIn from '../views/authorization/SignIn'
import SignUp from '../views/authorization/SignUp'

const routes = [
  {
    path: '/todos',
    name: 'todos',
    component: App,
    meta: { requiresAuthentication: true }
  },
  {
    path: '/settings',
    name: 'settings',
    component: Settings,
    meta: { requiresAuthentication: true }
  },
  {
    path: '/',
    name: 'sign-in',
    component: SignIn,
    meta: { requiresVisitor: true }
  },
  {
    path: '/signUp',
    name: 'sign-up',
    component: SignUp,
    meta: { requiresVisitor: true }
  },
  {
    path: '/logOut',
    name: 'sign-out'
    // component: SignOut
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
