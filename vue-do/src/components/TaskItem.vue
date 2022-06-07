<template>
  <div class="task-item">
    <div class="task-item-description">
      <font-awesome-icon icon="star" class="star-button" :class="{ important: todoPriorityId === importantPriorityId }"
                         @click="changePriority"/>
      <div class="data-container">
        <div v-if="!editingName" @click="editTask"
             class="task-item-name" :class="{completed: isCompleted}">{{ taskName }}</div>
        <input v-else class="task-item-edit" type="text" v-model="taskName" @blur="doneEdit"
               @keyup.enter="doneEdit" @keyup.esc="cancelEdit" v-focus>
        <div v-if="dueDt !== null" class="task-item-date" :class="{ 'completed-info': isCompleted }">
          Due date: {{dueDtInLocalTime}}</div>
        <div class="task-item-category" :class="{ 'completed-info': isCompleted }" @click="showMovingModal">
          List: {{getCategoryName}}</div>
      </div>
    </div>
    <div class="end-buttons">
      <font-awesome-icon icon="bell" class="bell-button" @click="settingNewDate=true"
                         :class="{ dateset : dueDt !== null, 'completed-info': isCompleted }"/>
      <input class="complete-item" type="checkbox" v-model="isCompleted" @change="doneEdit"/>
      <div class="remove-item" @click="removeTask(task.id)">
        &times;
      </div>
    </div>
    <div v-if="movingFromCategory" class="modal-container">
      <div class="modal-outside" @click="hideMovingModal"></div>
      <div class="modal">
        <h4 class="modal-title">Move to:</h4>
        <div class="drop-down">
          <div class="select-container">
            <div class="select" @click="showDropDownMenu">
              <span class="drop-down-current-category">{{ getCategoryName }}</span>
              <font-awesome-icon class="caret-down" icon="caret-down" color="grey"/>
            </div>
          </div>
          <div class="drop-down-menu" :class="{'drop-down-menu-shown' : dropDownShown}">
            <div class="drop-down-menu-item" v-for="category in categories" :key="category.id"
                 @click="editTaskCategory(category.id)">
              <span>{{ category.categoryName }}</span>
              <font-awesome-icon class="category-checkmark" v-if="category.categoryName === getCategoryName"
                                 icon="check" color="grey"/>
            </div>
          </div>
        </div>
        <button class="modal-button" @click="confirmMoving">Move</button>
      </div>
    </div>
    <div v-if="settingNewDate" class="modal-container">
      <div class="modal-outside" @click="settingNewDate=false"></div>
      <div class="modal">
        <h4 class="modal-title">Set due date</h4>
        <Datepicker v-if="settingNewDate" v-model="date" />
        <button class="modal-button" @click="confirmNewDate">Set</button>
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment'
import Datepicker from 'vue3-date-time-picker'
import 'vue3-date-time-picker/dist/main.css'

// noinspection JSUnusedGlobalSymbols
export default {
  name: 'task-item',
  props: {
    task: {
      type: Object,
      required: true
    },
    checkAll: {
      type: Boolean,
      required: true
    }
  },
  // eslint-disable-next-line vue/no-unused-components
  components: { Datepicker },
  data () {
    return {
      id: this.task.id,
      taskName: this.task.taskName,
      dueDt: this.task.dueDt,
      isCompleted: this.task.isCompleted,
      todoCategoryId: this.task.todoCategoryId,
      todoPriorityId: this.task.todoPriorityId,
      editingName: this.task.editingName,
      beforeEditCache: '',
      categoryName: '',
      importantPriorityId: this.$store.state.importantPriorityId,
      movingFromCategory: false,
      dropDownShown: false,
      settingNewDate: false,
      tempTodoCategoryId: '',
      date: new Date()
    }
  },
  computed: {
    // eslint-disable-next-line vue/return-in-computed-property
    dueDtInLocalTime () {
      if (this.dueDt != null) {
        const localTimeIso = moment.utc(this.dueDt).toISOString(false)
        // eslint-disable-next-line vue/no-side-effects-in-computed-properties
        this.date = new Date(localTimeIso)
        return moment.utc(this.dueDt).local().format('DD-MM-YY HH:mm').toString()
      }
    },
    // eslint-disable-next-line vue/no-async-in-computed-properties
    getCategoryName () {
      if (this.$store.state.categories) {
        const index = this.$store.state.categories.findIndex(category => category.id === this.todoCategoryId)
        return this.$store.state.categories[index].categoryName
      } else return ''
    },
    categories () {
      return this.$store.getters.categoriesList
    }
  },
  directives: {
    focus: {
      mounted (el) {
        el.focus()
      }
    }
  },
  watch: {
    checkAll () {
      this.isCompleted = this.checkAll ? true : this.task.isCompleted
    }
  },
  methods: {
    confirmNewDate () {
      this.dueDt = moment.utc(this.date).toISOString(false)
      this.settingNewDate = false
      this.updateItemInList()
    },
    confirmMoving () {
      this.movingFromCategory = false
      this.updateItemInList()
    },
    editTaskCategory (categoryId) {
      this.todoCategoryId = categoryId
      this.dropDownShown = !this.dropDownShown
    },
    showDropDownMenu () {
      this.dropDownShown = !this.dropDownShown
    },
    showMovingModal () {
      this.tempTodoCategoryId = this.todoCategoryId
      this.movingFromCategory = true
    },
    hideMovingModal () {
      this.todoCategoryId = this.tempTodoCategoryId
      this.movingFromCategory = false
    },
    removeTask (id) {
      this.$store.dispatch('removeTask', id)
    },
    editTask () {
      this.beforeEditCache = this.taskName
      this.editingName = true
    },
    doneEdit () {
      if (this.taskName.trim().length === 0) {
        this.taskName = this.beforeEditCache
      }
      this.editingName = false
      this.updateItemInList()
    },
    cancelEdit () {
      this.taskName = this.beforeEditCache
      this.editingName = false
    },
    changePriority () {
      if (this.todoPriorityId === this.$store.state.priorities[0].id) {
        this.todoPriorityId = this.$store.state.priorities[1].id
      } else {
        this.todoPriorityId = this.$store.state.priorities[0].id
      }
      this.updateItemInList()
    },
    updateItemInList () {
      this.$store.dispatch('updateTask', {
        id: this.id,
        taskName: this.taskName,
        taskSort: this.taskSort,
        createdDt: this.createdDt,
        dueDt: this.dueDt,
        isCompleted: this.isCompleted,
        isArchived: this.isArchived,
        todoCategoryId: this.todoCategoryId,
        todoPriorityId: this.todoPriorityId,
        syncDt: this.syncDt
      })
    }
  }
}
</script>

<style scoped lang="scss">
.task-item {
  min-height: 40px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  border-bottom: 1px solid lightgrey;
  animation-duration: 0.3s;
}
.task-item-description {
  display: flex;
  align-items: center;
}
.star-button {
  vertical-align: center;
  color: lightgrey;
  margin: 0 0 2px 10px;
}
.important {
  color: orange;
}
.data-container {
  display: flex;
  flex-direction: column;
}
.task-item-name {
  font-size: 18px;
  padding: 5px 5px 5px 10px;
  font-weight: bold;
}
.completed {
  text-decoration: line-through;
  color: grey;
}
.task-item-edit {
  height: 35px;
  font-size: 18px;
  color: #2c3e50;
  width: 100%;
  padding: 5px 5px 5px 5px;
  border: 0;
  border-bottom: 1px solid lightgrey;
  font-family: 'Avenir', Helvetica, Arial, sans-serif
}
.task-item-date {
  padding: 0 0 0 10px;
  font-size: 14px;
  font-weight: bold;
  font-style: italic;
  color: red;
}
.completed-info {
  color: grey;
}
.task-item-category {
  padding: 5px 5px 5px 10px;
  font-size: 14px;
}
.end-buttons {
  display: flex;
  align-items: center;
  justify-content: space-between;
}
.bell-button {
  cursor: pointer;
  color: lightgrey;
  horiz-align: left;
  margin-left: 10px;
  margin-right: 10px;
}
.dateset {
  color: red;
}
.complete-item {
  cursor: pointer;
  horiz-align: left;
  margin-left: 10px;
  margin-right: 10px;
}
.remove-item {
  cursor: pointer;
  margin-left: 10px;
  margin-right: 10px;
  font-size: 18px;
  &:hover {
    color: red;
  }
}
</style>
