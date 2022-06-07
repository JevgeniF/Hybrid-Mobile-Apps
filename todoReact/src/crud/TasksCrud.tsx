import AsyncStorage from '@react-native-async-storage/async-storage';
import {Task} from '../models/Task';
import {Priority} from '../models/Priority';
import Client from '../api/Client';

const apiUrl = new Client().defaultUrl;

export async function getTasks() {
  let tasks: Task[];
  try {
    const token = await AsyncStorage.getItem('@token');
    const requestData = {
      method: 'GET',
      headers: {
        Authorization: 'Bearer ' + token,
      },
    };

    let response = await fetch(apiUrl + 'TodoTasks', requestData);
    tasks = await response.json();
  } catch (e) {
    console.log(e);
  }
  return tasks;
}

export async function postTask(task: Task) {
  try {
    const token = await AsyncStorage.getItem('@token');
    const requestData = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer ' + token,
      },
      body: JSON.stringify({
        taskName: task.taskName,
        todoCategoryId: task.todoCategoryId,
        todoPriorityId: task.todoPriorityId,
      }),
    };

    let response = await fetch(apiUrl + 'TodoTasks', requestData);
    if (response.status === 201) {
      console.log('taskAdded');
    }
  } catch (e) {
    console.log(e);
  }
}

export async function putTaskDone(task: Task) {
  const completed = !task.isCompleted;

  try {
    const token = await AsyncStorage.getItem('@token');
    const requestData = {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer ' + token,
      },
      body: JSON.stringify({
        id: task.id,
        taskName: task.taskName,
        dueDt: task.dueDt,
        isCompleted: completed,
        todoCategoryId: task.todoCategoryId,
        todoPriorityId: task.todoPriorityId,
      }),
    };

    let response = await fetch(apiUrl + 'TodoTasks/' + task.id, requestData);
    if (response.status === 204) {
      console.log('isCompletedChanged');
    }
  } catch (e) {
    console.log(e);
  }
}

export async function putPriority(task: Task, priorities: Priority[]) {
  let priorityId;
  priorities.forEach(priority => {
    if (priority.id !== task.todoPriorityId) {
      priorityId = priority.id;
    }
  });

  try {
    const token = await AsyncStorage.getItem('@token');
    const requestData = {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer ' + token,
      },
      body: JSON.stringify({
        id: task.id,
        taskName: task.taskName,
        dueDt: task.dueDt,
        isCompleted: task.isCompleted,
        todoCategoryId: task.todoCategoryId,
        todoPriorityId: priorityId,
      }),
    };

    let response = await fetch(apiUrl + 'TodoTasks/' + task.id, requestData);
    if (response.status === 204) {
      console.log('importanceChanged');
    }
  } catch (e) {
    console.log(e);
  }
}

export async function putNameAndCategory(
  task: Task,
  name: string,
  categoryId: string,
) {
  try {
    const token = await AsyncStorage.getItem('@token');
    const requestData = {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer ' + token,
      },
      body: JSON.stringify({
        id: task.id,
        taskName: name,
        dueDt: task.dueDt,
        isCompleted: task.isCompleted,
        todoCategoryId: categoryId,
        todoPriorityId: task.todoPriorityId,
      }),
    };

    let response = await fetch(apiUrl + 'TodoTasks/' + task.id, requestData);
    if (response.status === 204) {
      console.log('Details Changed');
    } else {
      console.log(response);
    }
  } catch (e) {
    console.log(e);
  }
}

export async function putDate(task: Task, date: Date) {
  try {
    const token = await AsyncStorage.getItem('@token');
    const requestData = {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer ' + token,
      },
      body: JSON.stringify({
        id: task.id,
        taskName: task.taskName,
        dueDt: date,
        isCompleted: task.isCompleted,
        todoCategoryId: task.todoCategoryId,
        todoPriorityId: task.todoPriorityId,
      }),
    };

    let response = await fetch(apiUrl + 'TodoTasks/' + task.id, requestData);
    if (response.status === 204) {
      console.log('Date Changed');
    } else {
      console.log(response);
    }
  } catch (e) {
    console.log(e);
  }
}

export async function deleteTask(task: Task) {
  try {
    const token = await AsyncStorage.getItem('@token');
    const requestData = {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer ' + token,
      },
      body: JSON.stringify({
        id: task.id,
      }),
    };

    let response = await fetch(apiUrl + 'TodoTasks/' + task.id, requestData);
    if (response.status === 200) {
      console.log('TaskDeleted');
    }
  } catch (e) {
    console.log(e);
  }
}
