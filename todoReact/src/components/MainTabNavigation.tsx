/* eslint-disable @typescript-eslint/no-unused-vars,react-native/no-inline-styles */
// @ts-ignore
import React from 'react';
import {createNativeStackNavigator} from '@react-navigation/native-stack';
import TasksScreen from '../screens/TasksScreen';
import ToDoListsScreen from '../screens/ToDoListsScreen';
import Icon from 'react-native-vector-icons/MaterialIcons';
import {createMaterialBottomTabNavigator} from '@react-navigation/material-bottom-tabs';

const TasksStack = createNativeStackNavigator();
const ToDoListsStack = createNativeStackNavigator();
const Tab = createMaterialBottomTabNavigator();

const MainTabScreen = () => (
  <Tab.Navigator barStyle={{backgroundColor: '#7700ff'}}>
    <Tab.Screen
      name="TasksTab"
      component={TasksStackScreen}
      options={{
        tabBarLabel: 'Tasks',
        tabBarIcon: ({color}) => <Icon name="check" color={color} size={25} />,
      }}
    />
    <Tab.Screen
      name="ListsTab"
      component={ToDoListsStackScreen}
      options={{
        tabBarLabel: 'ToDo Lists',
        tabBarIcon: ({color}) => <Icon name="list" color={color} size={25} />,
      }}
    />
  </Tab.Navigator>
);

const TasksStackScreen = ({navigation}) => (
  <TasksStack.Navigator
    screenOptions={{
      headerShown: false,
    }}>
    <TasksStack.Screen
      name="Tasks"
      initialParams={{id: 0, name: 'All Tasks'}}
      component={TasksScreen}
    />
  </TasksStack.Navigator>
);

const ToDoListsStackScreen = ({navigation}) => (
  <ToDoListsStack.Navigator
    screenOptions={{
      headerShown: false,
    }}>
    <ToDoListsStack.Screen name="Lists" component={ToDoListsScreen} />
  </ToDoListsStack.Navigator>
);

export default MainTabScreen;
