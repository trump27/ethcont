import Vue from 'vue'
import VueRouter from 'vue-router'
Vue.use(VueRouter)

const router = new VueRouter()

router.map({
  '/': { component: require('./components/Deploy.vue') },
  '/deploy': { component: require('./components/Deploy.vue') },
  '/dev': { component: require('./components/Dev.vue') },
  '*': { component: require('./components/Deploy.vue') }
})

const App = Vue.extend(require('./App.vue'))
router.start(App, '#app')
