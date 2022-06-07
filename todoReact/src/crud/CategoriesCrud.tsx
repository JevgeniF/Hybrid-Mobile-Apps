import AsyncStorage from '@react-native-async-storage/async-storage';
import {Category} from '../models/Category';
import Client from '../api/Client';
import Toast from 'react-native-simple-toast';

const apiUrl = new Client().defaultUrl;

export async function getCategories() {
  let categories: Category[];
  try {
    const token = await AsyncStorage.getItem('@token');
    const requestData = {
      method: 'GET',
      headers: {
        Authorization: 'Bearer ' + token,
      },
    };

    let response = await fetch(apiUrl + 'TodoCategories', requestData);
    categories = await response.json();
  } catch (e) {
    console.log(e);
  }
  return categories;
}

export async function postCategory(category: Category) {
  try {
    const token = await AsyncStorage.getItem('@token');
    const requestData = {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer ' + token,
      },
      body: JSON.stringify({
        categoryName: category.categoryName,
      }),
    };

    let response = await fetch(apiUrl + 'TodoCategories', requestData);
    if (response.status === 201) {
      console.log('category added');
    }
  } catch (e) {
    console.log(e);
  }
}

export async function putName(category: Category, name: string) {
  try {
    const token = await AsyncStorage.getItem('@token');
    const requestData = {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer ' + token,
      },
      body: JSON.stringify({
        id: category.id,
        categoryName: name,
      }),
    };

    let response = await fetch(
      apiUrl + 'TodoCategories/' + category.id,
      requestData,
    );
    if (response.status === 204) {
      console.log('List Name Changed');
    } else {
      console.log(response);
    }
  } catch (e) {
    console.log(e);
  }
}

export async function deleteCategory(category: Category) {
  try {
    const token = await AsyncStorage.getItem('@token');
    const requestData = {
      method: 'DELETE',
      headers: {
        'Content-Type': 'application/json',
        Authorization: 'Bearer ' + token,
      },
      body: JSON.stringify({
        id: category.id,
      }),
    };

    let response = await fetch(
      apiUrl + 'TodoCategories/' + category.id,
      requestData,
    );
    if (response.status === 200) {
      console.log('ListDeleted');
    } else if (response.status === 500) {
      Toast.show('Category is not empty. Remove task first.');
    }
  } catch (e) {
    console.log(e);
  }
}
