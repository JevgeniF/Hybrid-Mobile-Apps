<template>
  <div class="login-form">
    <h4 class="login-heading">Settings</h4>

      <div class="form-control">
        <button type="submit" class="btn-submit" @click="logOut">Sign Out</button>
      </div>
  </div>
</template>

<script>
export default {
  name: 'settings',
  methods: {
    logOut () {
      this.$store.dispatch('signOut')
      this.$router.push({ name: 'sign-in' })
    }
  }
}
</script>
