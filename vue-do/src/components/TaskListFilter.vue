<!--suppress JSUnresolvedVariable -->
<template>
  <div>
    <button :class="{ active: filter === 'all' }" @click="changeFilter('all')">All</button>
    <button :class="{ active: filter === 'active' }" @click="changeFilter('active')">Active</button>
    <button :class="{ active: filter === 'important' }" @click="changeFilter('important')">Important</button>
    <button :class="{ active: filter === 'due' }" @click="changeFilter('due')">Due</button>
  </div>
</template>

<script>
export default {
  name: 'task-list-filter',
  computed: {
    filter () {
      return this.$store.state.filter
    }
  },
  methods: {
    changeFilter (filter) {
      this.$store.dispatch('changeFilter', filter)
    }
  }
}
</script>
