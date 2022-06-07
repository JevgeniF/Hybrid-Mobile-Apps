<template>
  <div>
    <transition name="fade">
      <button v-if="showClearFinishedButton" @click="clearFinished">Clear finished</button>
    </transition>
  </div>
</template>

<script>
export default {
  name: 'task-list-clear-completed',
  computed: {
    showClearFinishedButton () {
      return this.$store.getters.showClearFinishedButton
    }
  },
  methods: {
    clearFinished () {
      this.$store.dispatch('clearFinished')
    }
  }
}
</script>
