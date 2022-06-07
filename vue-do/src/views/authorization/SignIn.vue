<template>
  <div class="login-form">
    <h4 class="login-heading">Sign In</h4>
    <form action="#" @submit.prevent="signIn">

      <div class="form-control">
        <div class="error"><span v-if="emailError" class="errorMessage">{{emailErrorMessage}}</span></div>
        <input type="email" name="email" id="email" class="login-input" v-model="email" placeholder="Email"
               v-on:change="isEmailValid">
      </div>

      <div class="form-control mb-more">
        <div class="error"><span v-if="passwordError" class="errorMessage">{{passwordErrorMessage}}</span></div>
        <input type="password" name="password" id="password" class="login-input" v-model="password"
               placeholder="Password" v-on:change="isPasswordValid">
      </div>

      <div class="form-control">
        <div class="error" v-if="signInError">
          <span v-if="signInError" class="errorMessage">{{signInErrorMessage}}</span>
        </div>
        <button type="submit" class="btn-submit">Sign In</button>
      </div>

    </form>
  </div>
</template>

<script>
export default {
  name: 'sign-in',
  data () {
    return {
      email: '',
      password: '',
      emailPattern: /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w\w+)+$/,
      emailError: false,
      emailErrorMessage: 'The email has invalid email pattern',
      passwordPattern: /^(?=.*?[A-Z])(?=(.*[a-z])+)(?=(.*[\d])+)(?=(.*[\W])+)(?!.*\s).{6,}$/,
      passwordError: false,
      passwordErrorMessage: 'The password must be min 6 characters long and have 1 uppercase letter, 1 number and 1 ' +
        'special character',
      signInError: false,
      signInErrorMessage: 'Please check credentials and try again'
    }
  },
  methods: {
    isEmailValid () {
      this.emailError = !this.emailPattern.test(this.email)
    },
    isPasswordValid () {
      this.passwordError = !this.passwordPattern.test(this.password)
    },
    signIn () {
      if (!this.emailError && !this.passwordError) {
        this.$store.dispatch('signIn', {
          email: this.email,
          password: this.password
        })
          .then(() => {
            this.signInError = false
            this.$router.push({ name: 'todos' })
          })
          .catch(error => {
            this.signInError = true
            console.log(error)
          })
      }
    }
  }
}
</script>

<style lang="scss">
.error {
  margin-left: 40px;
  margin-bottom: 0;
}
</style>
