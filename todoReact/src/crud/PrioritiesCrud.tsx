import AsyncStorage from '@react-native-async-storage/async-storage';
import {Priority} from '../models/Priority';
import Client from '../api/Client';

const apiUrl = new Client().defaultUrl;

export async function getPriorities() {
  let priorities: Priority[];
  try {
    const token = await AsyncStorage.getItem('@token');
    const requestData = {
      method: 'GET',
      headers: {
        Authorization: 'Bearer ' + token,
      },
    };

    let response = await fetch(apiUrl + 'TodoPriorities', requestData);
    priorities = await response.json();
  } catch (e) {
    console.log(e);
  }
  return priorities;
}

export async function postPriority(priority: Priority) {
  try {
    const token = await AsyncStorage.getItem('@token');
    const requestData = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer ' + token,
      },
      body: JSON.stringify({
        priorityName: priority.priorityName,
        prioritySort: priority.prioritySort,
      }),
    };

    let response = await fetch(apiUrl + 'TodoPriorities', requestData);
    if (response.status === 201) {
      console.log('priority added');
    }
  } catch (e) {
    console.log(e);
  }
}
