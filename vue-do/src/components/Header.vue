<template>
  <div class="header" >
    <h2 class="header-title">Todo list:</h2>
    <div class="header-content">
      <div class="drop-down">
        <div class="select-container">
          <div class="select" @click="showDropDownMenu">
            <span class="drop-down-current-category">{{ currentCategory.categoryName }}</span>
            <font-awesome-icon class="caret-down" icon="caret-down" color="grey"/>
          </div>
        </div>
        <div class="drop-down-menu" :class="{'drop-down-menu-shown' : dropDownShown}">
          <div class="drop-down-menu-item" @click="changeCategory('')">
            <span>All todos</span>
            <font-awesome-icon v-if="currentCategory.categoryName === 'All todos'" icon="check" color="grey"/>
          </div>
          <div class="drop-down-menu-item" v-for="category in categories" :key="category.id"
               @click="changeCategory(category.id)">
            <span>{{ category.categoryName }}</span>
            <font-awesome-icon class="category-checkmark" v-if="category.categoryName === currentCategory.categoryName"
                               icon="check" color="grey"/>
          </div>
          <div class="drop-down-menu-item-add" @click="showAddCategoryModal">Add new list</div>
        </div>
      </div>
      <div class="end-buttons">
        <div v-if="currentCategory.id !== ''" class="category-edit">
          <font-awesome-icon icon="edit" @click="showEditCategoryModal" color="grey"/>
        </div>
        <delete-empty-category-button :currentCategoryId="currentCategory.id"/>
      </div>
    </div>
    <div v-if="addingCategory" class="modal-container">
      <div class="modal-outside" @click="cancelAdd"></div>
      <div class="modal">
        <h4 class="modal-title">Add new list</h4>
        <span v-if="error" class="errorMessage">{{errorMessage}}</span>
        <input class="modal-input" type="text" v-model="newCategoryName"
               @keyup.enter="doneAdd" @keyup.esc="showAddCategoryModal" v-focus />
        <button class="modal-button" @click="doneAdd">Add</button>
      </div>
    </div>
    <div v-if="editingCategory" class="modal-container">
      <div class="modal-outside" @click="cancelEdit"></div>
      <div class="modal">
        <h4 class="modal-title">Edit list name</h4>
        <span v-if="error" class="errorMessage">{{errorMessage}}</span>
        <input class="modal-input" type="text" v-model="currentCategory.categoryName"
               @keyup.enter="doneEdit" @keyup.esc="cancelEdit" v-focus />
        <button class="modal-button" @click="doneEdit">Edit</button>
      </div>
    </div>
  </div>
</template>

<script>
import DeleteEmptyCategoryButton from './DeleteEmptyCategoryButton'

export default {
  name: 'Header',
  components: { DeleteEmptyCategoryButton },
  data () {
    return {
      dropDownShown: false,
      addingCategory: false,
      editingCategory: false,
      newCategoryName: '',
      tempCategoryName: '',
      error: false,
      errorMessage: ''
    }
  },
  computed: {
    currentCategory () {
      return this.$store.getters.currentCategory
    },
    categories () {
      return this.$store.getters.categoriesList
    }
  },
  methods: {
    showDropDownMenu () {
      this.dropDownShown = !this.dropDownShown
    },
    changeCategory (id) {
      this.$store.commit('changeCategory', id)
      this.dropDownShown = false
    },
    showAddCategoryModal () {
      this.addingCategory = !this.addingCategory
      this.dropDownShown = false
    },
    showEditCategoryModal () {
      this.editingCategory = !this.editingCategory
      this.dropDownShown = false
      this.tempCategoryName = this.currentCategory.categoryName
    },
    cancelEdit () {
      this.editingCategory = false
      this.$store.commit('restoreCurrentCategoryName', this.tempCategoryName)
      this.error = false
    },
    cancelAdd () {
      this.addingCategory = false
      this.error = false
      this.newCategoryName = ''
    },
    doneAdd () {
      if (this.newCategoryName === '') {
        this.error = true
        this.errorMessage = 'List name can\'t be empty'
      } else if (this.categories.filter((category) => (this.newCategoryName === category.categoryName)).length > 0) {
        console.log(this.categories.filter((category) => (this.newCategoryName === category.categoryName)))
        this.error = true
        this.errorMessage = 'List already exists'
      } else {
        this.$store.dispatch('addCategory', this.newCategoryName)
        this.addingCategory = false
        this.error = false
        this.newCategoryName = ''
      }
    },
    doneEdit () {
      if (this.currentCategory.categoryName !== '') {
        this.$store.dispatch('editCategory')
        this.editingCategory = false
        this.error = false
      } else {
        this.error = true
        this.errorMessage = 'List name can\'t be empty'
      }
    }
  },
  directives: {
    focus: {
      mounted (el) {
        el.focus()
      }
    }
  }
}
</script>

<style scoped lang="scss">
.header {
  border-bottom: 1px solid lightgrey;
  padding-bottom: 10px;
  margin-bottom: 15px;
  box-shadow: 0 5px 5px 0 rgba(0, 0, 0, 0.1);
  background-color: #BBDEFB
}
.header-content {
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 16px;
  padding: 0 40px 0 40px;
}
.header-title {
  color: grey;
  font-size: 16px;
  margin-bottom: 5px;
  padding: 10px 40px 0 40px;
}
.end-buttons {
  display: flex;
  align-items: center;
}
</style>
