<template>
  <div class="category-delete">
    <button v-if="categoryTasksQuantity === 0" class="delete-category-button" @click="deleteCategory">Delete Empty
      List
    </button>
  </div>
</template>
<script>
export default {
  name: 'delete-empty-category-button',
  props: {
    currentCategoryId: {
      type: String,
      required: true
    }
  },
  computed: {
    categoryTasksQuantity () {
      if (this.currentCategoryId !== '') {
        return this.$store.state.tasks.filter(task => task.todoCategoryId === this.currentCategoryId).length
      }
      return this.$store.state.tasks.length
    }
  },
  methods: {
    deleteCategory () {
      this.$store.dispatch('deleteCategory')
    }
  }
}
</script>
<style scoped lang="scss">
.category-delete {
  margin-left: 15px;
}
</style>
