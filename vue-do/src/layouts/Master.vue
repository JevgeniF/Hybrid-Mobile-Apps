<template>
<div id="app">
  <ul class = "nav">
    <li v-if="loggedIn"><router-link :to="{ name: 'todos' }">Todos</router-link></li>
    <li v-if="loggedIn"><router-link :to="{ name: 'settings' }">Settings</router-link></li>
    <li v-if="!loggedIn"><router-link :to="{ name: 'sign-in' }">SignIn</router-link></li>
    <li v-if="!loggedIn"><router-link :to="{ name: 'sign-up' }">SignUp</router-link></li>
  </ul>
  <router-view />
</div>
</template>

<script>
export default {
  name: 'master',
  computed: {
    loggedIn () {
      return this.$store.getters.loggedIn
    }
  }
}
</script>

<style lang="scss">
* {
  box-sizing: border-box;
  margin: 0;
  padding: 0;
}
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  color: #2c3e50;
  font-size: 18px;
  height: 100vh;
  width: 100vw;
  background-color: #e1f5fe;
}
.flex-center {
  display: flex;
  justify-content: center;
}
.nav {
  display: flex;
  list-style: none;
  padding: 15px 0;
  justify-content: center;
  background: #F5F8FA;
  border-bottom: 1px solid lightgrey;
  margin: 0 0 24px;
}
.nav a {
  color: #636b6f;
  padding: 0 9px;
  font-size: 14px;
  font-weight: 600;
  text-decoration: none;
  text-transform: uppercase;
}
.login-heading {
  padding-top: 20px;
  margin: 20px 40px;
  font-size: 18px;
  color: grey;
}
.form-control {
  margin-bottom: 24px;
}
.mb-more {
  margin-bottom: 42px;
}
.login-form {
  max-width: 500px;
  margin: auto;
  background-color: white;
  box-shadow: 0 5px 5px 0 rgba(0, 0, 0, 0.2);
}
.login-input {
  width: 80%;
  margin: 20px 40px 0 40px;
  font-size: 18px;
  padding: 10px;
  outline: 0;
  border-radius: 5px;
  border: 1px solid lightgrey;
}
.btn-submit {
  width: 80%;
  margin: 0 40px 20px 40px;
  padding: 14px 12px;
  font-size: 18px;
  background: #2196F3;
  color: white;
  border-radius: 5px;
  cursor: pointer;
&:hover {
   background: darken(#0D47A1, 10%);
 }
}
.modal-container {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}
.modal-outside {
  position: absolute;
  z-index: 99;
  width: 100%;
  height: 100%;
  background-color: rgba(0, 0, 0, 0.45);
  animation: fade-in 0.1s ease-out forwards;
}
.modal {
  position: center;
  text-align: center;
  z-index: 100;
  padding: 10px 40px 10px 40px;
  background: white;
  border-radius: 5px;
  font-size: 18px;
  animation: zoom-in 0.2s ease-out forwards;
}
.modal-title {
  font-weight: bold;
  align-self: center;
  margin-bottom: 7px;
}
.modal-input {
  margin-top: 7px;
  width: 100%;
  min-height: 40px;
  padding: 10px 18px;
  font-size: 18px;
  margin-bottom: 16px;
  border: 1px solid grey;
  border-radius: 5px;
}
.modal-button {
  width: 70px;
  height: 30px;
  margin-top: 10px;
  margin-bottom: 20px;
}
.select-container {
  display: inline-block;
  cursor: pointer;
}
.select {
  display: flex;
  align-items: center;
}
.drop-down {
  position: relative;
  font-size: 18px;
  font-weight: bold;
  padding-bottom: 10px;
}
.drop-down-current-category {
  margin-right: 15px;
}
.drop-down-menu {
  position: absolute;
  z-index: 10;
  top: 50%;
  visibility: hidden;
  opacity: 0;
  left: -5px;
  min-width: 200px;
  background: white;
  box-shadow: 0 5px 5px 0 rgba(0, 0, 0, 0.1);
  border-radius: 5px;
}
.drop-down-menu-shown {
  visibility: visible;
  opacity: 1;
  top: 100%;
  transition: 0.1s ease-in-out;
}
.drop-down-menu-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  border-bottom: 1px solid lightgrey;
  font-weight: bold;
  font-size: 18px;
  cursor: pointer;

  &:hover {
    background-color: lightgrey;
  }
}
.drop-down-menu-item-add {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  border-bottom: 1px solid lightgrey;
  font-size: 18px;
  color: gray;
  cursor: pointer;

  &:hover {
    background-color: lightgrey;
  }
}
.drop-down-menu-add {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 20px;
  border-bottom: 1px solid lightgrey;
  font-weight: bold;
  font-size: 18px;
}
.errorMessage {
  color: red;
  font-size: 12px;
  font-weight: bold;
  padding-bottom: 0;
}
//CSS transitions
.fade-enter-active, .fade-leave-active {
  transition: opacity 0.2s;
}
.fade-enter, .fade-leave-to {
  opacity: 0;
}
</style>
