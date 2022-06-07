<template>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <div id="app" class="container">
    <Main/>
  </div>
</template>

<script>
import Main from './views/Main'

export default {
  name: 'App',
  components: {
    Main
  }
}
</script>

<style>
* {
  box-sizing: border-box;
}

.container {
  max-width: 600px;
  margin: 0 auto;
}
</style>
