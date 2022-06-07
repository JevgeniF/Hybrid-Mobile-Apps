<template>
  <Header />
 <TasksList />
</template>

<script>
import Header from '../components/Header'
import TasksList from '../components/TasksList'
export default {
  name: 'main-view',
  components: {
    Header,
    TasksList
  }
}
</script>
