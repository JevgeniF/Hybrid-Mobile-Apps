<!--suppress XmlHighlighting -->
<template>
  <div><label>Mark all <input type="checkbox" :checked="!anyRemaining" @change="markAll"></label></div>
</template>

<script>

export default {
  name: 'task-list-check-all',
  computed: {
    anyRemaining () {
      return this.$store.getters.anyRemaining
    }
  },
  methods: {
    markAll () {
      // noinspection JSDeprecatedSymbols
      this.$store.dispatch('markAll', event.target.checked)
    }
  }
}
</script>
