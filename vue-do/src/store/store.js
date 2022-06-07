import { createStore } from 'vuex'
import axios from 'axios'

axios.defaults.baseURL = 'https://taltech.akaver.com/api/v1/'

export const store = createStore({
  state: {
    filter: 'all',
    importantPriorityId: '',
    currentCategory: {
      id: '',
      categoryName: 'All todos',
      categorySort: 0,
      syncDt: ''
    },
    tasks: [],
    categories: null,
    priorities: [],
    user: {
      firstName: localStorage.getItem('userFirstName') || '',
      lastName: localStorage.getItem('userLastName') || '',
      email: localStorage.getItem('userEmail') || '',
      jwtToken: localStorage.getItem('jwtToken') || null
    }
  },
  getters: {
    loggedIn (state) {
      return state.user.jwtToken != null
    },
    currentCategory (state) {
      return state.currentCategory
    },
    categoriesList (state) {
      return state.categories
    },
    remaining (state) {
      const categoryTasks = state.currentCategory.id === ''
        ? state.tasks : state.tasks.filter(task => task.todoCategoryId === state.currentCategory.id)
      return categoryTasks.filter(task => !task.isCompleted).length
    },
    anyRemaining (state, getters) {
      return getters.remaining !== 0
    },
    tasksFiltered (state) {
      const categoryTasks = state.currentCategory.id === ''
        ? state.tasks : state.tasks.filter(task => task.todoCategoryId === state.currentCategory.id)
      if (state.filter === 'all') {
        return categoryTasks
      } else if (state.filter === 'active') {
        return categoryTasks.filter(task => !task.isCompleted)
      } else if (state.filter === 'important') {
        return categoryTasks.filter(task => task.todoPriorityId === state.importantPriorityId)
      } else if (state.filter === 'due') {
        return categoryTasks.filter(task => task.dueDt !== null)
      }
      return this.$store.state.tasks
    },
    showClearFinishedButton (state) {
      return state.tasks.filter(task => task.isCompleted).length > 0
    }
  },
  mutations: {
    // -------- corresponding to AUTH  --------------------
    signIn (state, user) {
      state.user = user
    },
    signUp (state, user) {
      state.user = user
    },
    signOut (state) {
      state.user = {
        firstName: '',
        lastName: '',
        email: '',
        jwtToken: null
      }
    },
    // -------- corresponding to TASK CRUD --------------------
    getTasks (state, tasks) {
      state.tasks = tasks
    },
    addTask (state, task) {
      state.tasks.push(task)
    },
    updateTask (state, task) {
      const index = state.tasks.findIndex(item => item.id === task.id)
      state.tasks.splice(index, 1, task)
    },
    removeTask (state, id) {
      const index = state.tasks.findIndex(item => item.id === id)
      state.tasks.splice(index, 1)
    },
    // -------- corresponding to CATEGORY CRUD --------------------
    addCategory (state, category) {
      state.categories.push(category)
      state.currentCategory = category
    },
    getCategories (state, categories) {
      state.categories = categories
    },
    editCategory (state) {
      const index = state.categories.findIndex(category => category.id === state.currentCategory.id)
      state.categories.splice(index, 1, state.currentCategory)
    },
    deleteCategory (state) {
      const index = state.categories.findIndex(category => category.id === state.currentCategory.id)
      state.categories.splice(index, 1)
      state.currentCategory = {
        id: '',
        categoryName: 'All todos',
        categorySort: 0,
        syncDt: ''
      }
    },
    // -------- corresponding to PRIORITIES CRUD --------------------
    getPriorities (state, priorities) {
      state.priorities = priorities
      if (priorities[0].priorityName === 'Important') {
        state.importantPriorityId = priorities[0].id
      } else {
        state.importantPriorityId = priorities[1].id
      }
    },
    // --------------- others -------------------------
    restoreCurrentCategoryName (state, categoryName) {
      state.currentCategory.categoryName = categoryName
    },
    changeCategory (state, id) {
      if (id !== '') {
        const index = state.categories.findIndex(category => category.id === id)
        state.currentCategory = state.categories[index]
      } else {
        state.currentCategory = {
          id: '',
          categoryName: 'All todos',
          categorySort: 0,
          syncDt: ''
        }
      }
    },
    changeFilter (state, filter) {
      state.filter = filter
    }
  },
  actions: {
    // -------------------- AUTH API ---------------------------------
    signIn (context, user) {
      return new Promise((resolve, reject) => {
        axios.post('Account/Login', {
          email: user.email,
          password: user.password
        },
        { headers: { 'Content-Type': 'application/json' } })
          .then(response => {
            const userExists = {
              firstName: response.data.firstName,
              lastName: response.data.firstName,
              email: user.email,
              jwtToken: response.data.token
            }
            localStorage.setItem('userFirstName', userExists.firstName)
            localStorage.setItem('userLastName', userExists.lastName)
            localStorage.setItem('userEmail', userExists.email)
            localStorage.setItem('jwtToken', userExists.jwtToken)
            context.commit('signIn', userExists)
            resolve(response)
          })
          .catch(error => {
            reject(error)
          })
      })
    },
    signUp (context, user) {
      return new Promise((resolve, reject) => {
        axios.post('Account/Register', user,
          { headers: { 'Content-Type': 'application/json' } })
          .then(response => {
            const newUser = user
            newUser.jwtToken = response.data.token
            localStorage.setItem('userFirstName', user.firstName)
            localStorage.setItem('userLastName', user.lastName)
            localStorage.setItem('userEmail', user.email)
            localStorage.setItem('jwtToken', newUser.jwtToken)
            context.commit('signUp', newUser)
            resolve(response)
          })
          .catch(error => {
            reject(error)
          })
      })
    },
    signOut (context) {
      if (context.getters.loggedIn) {
        localStorage.removeItem('userFirstName')
        localStorage.removeItem('userLastName')
        localStorage.removeItem('userEmail')
        localStorage.removeItem('jwtToken')
        context.commit('signOut')
      }
    },
    // -------------------- TASKS API CRUD ---------------------------------
    getTasks (context) {
      axios.get('TodoTasks',
        { headers: { Authorization: 'Bearer ' + context.state.user.jwtToken } })
        .then(response => {
          context.commit('getTasks', response.data)
        })
        .catch(error => { console.log(error) })
    },
    addTask (context, task) {
      axios.post('/TodoTasks',
        {
          taskName: task.taskName,
          dueDt: null,
          todoCategoryId: context.state.currentCategory.id,
          todoPriorityId: context.state.priorities[0].id
        },
        { headers: { Authorization: 'Bearer ' + context.state.user.jwtToken, 'Content-Type': 'application/json' } })
        .then(response => {
          context.commit('addTask', response.data)
        })
        .catch(error => { console.log(error) })
    },
    updateTask (context, task) {
      axios.put('TodoTasks/' + task.id, task,
        { headers: { Authorization: 'Bearer ' + context.state.user.jwtToken, 'Content-Type': 'application/json' } })
        .then(() => {
          context.commit('updateTask', task)
        })
        .catch(error => { console.log(error) })
    },
    removeTask (context, id) {
      axios.delete('TodoTasks/' + id,
        { headers: { Authorization: 'Bearer ' + context.state.user.jwtToken, 'Content-Type': 'application/json' } })
        .then(() => {
          context.commit('removeTask', id)
        })
        .catch(error => { console.log(error) })
    },
    markAll (context, checked) {
      context.state.tasks.forEach(task => {
        if (context.state.currentCategory.id !== '') {
          if (task.todoCategoryId === context.state.currentCategory.id) {
            task.isCompleted = checked
            axios.put('TodoTasks/' + task.id, task,
              { headers: { Authorization: 'Bearer ' + context.state.user.jwtToken, 'Content-Type': 'application/json' } })
              .then(() => {
                context.commit('updateTask', task)
              })
              .catch(error => { console.log(error) })
          }
        }
      })
    },
    clearFinished (context) {
      if (context.state.currentCategory.id !== '') {
        for (let i = 0; i < context.state.tasks.length; i++) {
          if (context.state.tasks[i].todoCategoryId === context.state.currentCategory.id && context.state.tasks[i].isCompleted) {
            axios.delete('TodoTasks/' + context.state.tasks[i].id,
              { headers: { Authorization: 'Bearer ' + context.state.user.jwtToken, 'Content-Type': 'application/json' } })
              .then(() => {
                context.commit('removeTask', context.state.tasks[i].id)
              })
              .catch(error => { console.log(error) })
          }
        }
      } else {
        for (let i = 0; i < context.state.tasks.length; i++) {
          if (context.state.tasks[i].isCompleted) {
            axios.delete('TodoTasks/' + context.state.tasks[i].id,
              { headers: { Authorization: 'Bearer ' + context.state.user.jwtToken, 'Content-Type': 'application/json' } })
              .then(() => {
                context.commit('removeTask', context.state.tasks[i].id)
              })
              .catch(error => { console.log(error) })
          }
        }
      }
    },
    // -------------------- CATEGORIES API CRUD ---------------------------------
    getCategories (context) {
      axios
        .get('TodoCategories',
          { headers: { Authorization: 'Bearer ' + context.state.user.jwtToken } })
        .then(response => {
          // console.log(response.data)
          context.commit('getCategories', response.data)
        })
        .catch(error => { console.log(error) })
    },
    addCategory (context, newCategoryName) {
      axios.post('TodoCategories',
        {
          categoryName: newCategoryName
        },
        { headers: { Authorization: 'Bearer ' + context.state.user.jwtToken, 'Content-Type': 'application/json' } })
        .then(response => {
          context.commit('addCategory', response.data)
        })
        .catch(error => { console.log(error) })
    },
    editCategory (context) {
      axios.put('TodoCategories/' + context.state.currentCategory.id,
        context.state.currentCategory,
        { headers: { Authorization: 'Bearer ' + context.state.user.jwtToken, 'Content-Type': 'application/json' } })
        .then(() => {
          context.commit('editCategory')
        })
        .catch(error => { console.log(error) })
    },
    deleteCategory (context) {
      axios.delete('TodoCategories/' + context.state.currentCategory.id,
        { headers: { Authorization: 'Bearer ' + context.state.user.jwtToken, 'Content-Type': 'application/json' } })
        .then(() => {
          context.commit('deleteCategory')
        })
        .catch(error => { console.log(error) })
    },
    // -------------------- PRIORITIES API CRUD ---------------------------------
    getPriorities (context) {
      axios
        .get('TodoPriorities',
          { headers: { Authorization: 'Bearer ' + context.state.user.jwtToken } })
        .then(response => {
          // console.log(response.data)
          context.commit('getPriorities', response.data)
        })
        .catch(error => { console.log(error) })
    },
    addPriority (context, priority) {
      axios.post('TodoPriorities',
        {
          priorityName: priority.priorityName,
          prioritySort: priority.prioritySort
        },
        { headers: { Authorization: 'Bearer ' + context.state.user.jwtToken, 'Content-Type': 'application/json' } })
        .then(() => {})
        .catch(error => { console.log(error) })
    },
    // ------------------  OTHERS ------------------------------------
    changeFilter (context, filter) {
      context.commit('changeFilter', filter)
    }
  }
})
