<template>
  <div>
    <transition name="fade">
    <input v-if="currentCategory.categoryName !== 'All todos'" type="text" class="task-input" placeholder="Add new todo" v-model="newTask"
           @keyup.enter="addTask"/>
      </transition>
    <div class = "tasks-list">
      <transition-group name="fade" enter-active-class="animate__animated animate__fadeInUp"
                        leave-active-class="animate__animated animate__fadeOutDown">
        <task-item v-for="task in tasksFiltered" :key="task.id" :task="task" :checkAll="!anyRemaining">
        </task-item>
      </transition-group>
    </div>

    <div class="bottom-container">
      <task-items-remaining />
      <task-list-check-all />
    </div>
    <div class="bottom-container">
      <task-list-filter />
      <task-list-clear-completed />
    </div>
  </div>
</template>

<script>
import TaskItem from './TaskItem'
import TaskItemsRemaining from './TaskItemsRemaining'
import TaskListCheckAll from './TaskListCheckAll'
import TaskListFilter from './TaskListFilter'
import TaskListClearCompleted from './TaskListClearCompleted'

export default {
  name: 'tasks-list',
  components: {
    TaskListClearCompleted,
    TaskListFilter,
    TaskListCheckAll,
    TaskItemsRemaining,
    TaskItem
  },
  data () {
    return {
      newTask: '',
      beforeEditCache: '',
      filter: 'all'
    }
  },
  async created () {
    await this.$store.dispatch('getPriorities')
    await this.$store.dispatch('getCategories')
    await this.$store.dispatch('getTasks')
  },
  computed: {
    currentCategory () {
      return this.$store.getters.currentCategory
    },
    anyRemaining () {
      return this.$store.getters.anyRemaining
    },
    tasksFiltered () {
      return this.$store.getters.tasksFiltered
    }
  },
  methods: {
    addTask () {
      if (this.newTask.trim().length === 0) {
        return
      }

      this.$store.dispatch('addTask',
        {
          taskName: this.newTask
        })
      this.newTask = ''
    }
  }
}
</script>

<style lang="scss">
@import url("https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css");
.task-input {
  width: 100%;
  min-height: 40px;
  padding: 10px 18px;
  font-size: 18px;
  margin-bottom: 16px;
  border: 1px solid grey;
  border-radius: 5px;

  &:focus {
    outline: 0;
  }
}
.tasks-list {
  box-shadow: 0 5px 5px 0 rgba(0, 0, 0, 0.2);
  overflow: auto;
  max-height: 60vh;
  background-color: white;
}
.bottom-container {
  background-color: rgba(245, 245, 245, 0.5);
  display: flex;
  align-items: center;
  justify-content: space-between;
  font-size: 16px;
  padding: 14px 40px 14px 40px;
  border-bottom: 1px solid lightgrey;
  box-shadow: 0 5px 5px 0 rgba(0, 0, 0, 0.1);
}
button {
  font-size: 14px;
  background-color: white;
  appearance: none;
  border: 1px solid lightgrey;
  border-radius: 5px;
  margin: 0 0 0 2px;
  padding: 5px;
  &:hover {
    background: #0D47A1;
    color: white;
  }
  &:focus {
    outline: none;
  }
}
.active {
  background: #0D47A1;
  color: white;
}
</style>
