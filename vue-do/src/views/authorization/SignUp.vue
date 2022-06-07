<template>
  <div class="login-form">
    <h2 class="login-heading">Sign Up</h2>
    <form action="#" @submit.prevent="signUp">
      <div class="form-control">
        <div class="error"><span v-if="firstNameError" class="errorMessage">{{nameErrorMessage}}</span></div>
        <input type="text" name="firstName" id="firstName" class="login-input" v-model="firstName"
               placeholder="First Name" v-on:change="isFirstNameValid">
      </div>
      <div class="form-control">
        <div class="error"><span v-if="lastNameError" class="errorMessage">{{nameErrorMessage}}</span></div>
        <input type="text" name="lastName" id="lastName" class="login-input" v-model="lastName"
               placeholder="Last Name" v-on:change="isLastNameValid">
      </div>
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
        <button type="submit" class="btn-submit">Sign Up</button>
      </div>

    </form>
  </div>
</template>

<script>
export default {
  name: 'sign-up',
  data () {
    return {
      firstName: '',
      firstNameError: false,
      lastName: '',
      lastNameError: false,
      nameErrorMessage: 'The field should contain at least one character',
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
    isFirstNameValid () {
      this.firstNameError = this.firstName.trim() === ''
    },
    isLastNameValid () {
      this.lastNameError = this.lastName.trim() === ''
    },
    isEmailValid () {
      this.emailError = !this.emailPattern.test(this.email)
    },
    isPasswordValid () {
      this.passwordError = !this.passwordPattern.test(this.password)
    },
    signUp () {
      if (!this.emailError && !this.passwordError && !this.firstNameError && !this.lastNameError) {
        this.$store.dispatch('signUp', {
          firstName: this.firstName,
          lastName: this.lastName,
          email: this.email,
          password: this.password
        })
          .then(() => {
            this.$store.dispatch('addCategory', 'Default')
            this.$store.dispatch('addPriority', {
              priorityName: 'Normal',
              prioritySort: 0
            })
            this.$store.dispatch('addPriority', {
              priorityName: 'Important',
              prioritySort: 1
            })
            this.$router.push({ name: 'todos' })
          })
          .catch(error => {
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
