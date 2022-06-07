/* eslint-disable react-native/no-inline-styles */
import React, {useEffect, useState} from 'react';
import {
  DarkTheme as NavigationDarkTheme,
  DefaultTheme as NavigationDefaultTheme,
  NavigationContainer,
} from '@react-navigation/native';
import {createDrawerNavigator} from '@react-navigation/drawer';
import 'react-native-gesture-handler';
import MainTabScreen from './src/components/MainTabNavigation';
import {DrawerComponent} from './src/components/DrawerComponent';
import RootStackNavigation from './src/components/RootStackNavigation';
import {ActivityIndicator, Alert, LogBox, View} from 'react-native';
import {AuthContext, ThemeContext} from './src/context/context';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {
  DarkTheme as PaperDarkTheme,
  DefaultTheme as PaperDefaultTheme,
  Provider as PaperProvider,
} from 'react-native-paper';
import {Category} from './src/models/Category';
import {postCategory} from './src/crud/CategoriesCrud';
import {Priority} from './src/models/Priority';
import {postPriority} from './src/crud/PrioritiesCrud';

LogBox.ignoreAllLogs();
console.warn = () => {};

const Drawer = createDrawerNavigator();

const App = () => {
  const [isDarkTheme, setIsDarkTheme] = useState(false);

  const CustomDefaultTheme = {
    ...NavigationDefaultTheme,
    ...PaperDefaultTheme,
    colors: {
      ...NavigationDefaultTheme.colors,
      ...PaperDefaultTheme.colors,
      background: '#ffffff',
      text: '#333333',
      button: '#323232',
    },
  };

  const CustomDarkTheme = {
    ...NavigationDarkTheme,
    ...PaperDarkTheme,
    colors: {
      ...NavigationDarkTheme.colors,
      ...PaperDarkTheme.colors,
      background: '#333333',
      text: '#ffffff',
    },
  };

  const theme = isDarkTheme ? CustomDarkTheme : CustomDefaultTheme;

  const themeContext = React.useMemo(
    () => ({
      toggleTheme: () => {
        // eslint-disable-next-line no-shadow
        setIsDarkTheme(isDarkTheme => !isDarkTheme);
      },
    }),
    [],
  );

  const initialLoginState = {
    isLoading: true,
    userEmail: null,
    userFirstName: null,
    userLastName: null,
    userToken: null,
  };

  const loginReducer = (prevState, action) => {
    switch (action.type) {
      case 'RETRIEVE_TOKEN':
        return {
          ...prevState,
          user: action.user,
          userToken: action.token,
          isLoading: false,
        };
      case 'LOGIN':
        return {
          ...prevState,
          userEmail: action.email,
          userFirstName: action.firstName,
          userLastName: action.lastName,
          userToken: action.token,
          isLoading: false,
        };
      case 'LOGOUT':
        return {
          ...prevState,
          userEmail: null,
          userFirstName: null,
          userLastName: null,
          userToken: null,
          isLoading: false,
        };
      case 'REGISTER':
        return {
          ...prevState,
          userEmail: action.email,
          userFirstName: action.name,
          userLastName: action.lastName,
          userToken: action.token,
          isLoading: false,
        };
    }
  };

  const [loginState, dispatch] = React.useReducer(
    loginReducer,
    initialLoginState,
  );

  const authContext = React.useMemo(
    () => ({
      signIn: async (userEmail, password) => {
        const requestData = {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({
            email: userEmail,
            password: password,
          }),
        };
        try {
          let response = await fetch(
            'https://taltech.akaver.com/api/v1/Account/Login',
            requestData,
          );
          let responseJson = await response.json();
          if (response.status === 404) {
            Alert.alert('Invalid User!', 'Username or password is incorrect.');
          } else {
            await AsyncStorage.setItem('@token', responseJson.token);
            dispatch({
              type: 'LOGIN',
              email: userEmail,
              firstName: responseJson.firstName,
              lastName: responseJson.lastName,
              token: responseJson.token,
            });

            let userJson = JSON.stringify({
              email: userEmail,
              firstName: responseJson.firstName,
              lastName: responseJson.lastName,
            });
            await AsyncStorage.setItem('@user', userJson);
          }
        } catch (e) {
          console.log(e);
        }
      },
      signOut: async () => {
        try {
          await AsyncStorage.removeItem('@token');
        } catch (e) {
          console.log(e);
        }
        dispatch({
          type: 'LOGOUT',
        });
      },
      signUp: async (userFirstName, userLastName, userEmail, password) => {
        const requestData = {
          method: 'POST',
          headers: {'Content-Type': 'application/json'},
          body: JSON.stringify({
            email: userEmail,
            password: password,
            firstName: userFirstName,
            lastName: userLastName,
          }),
        };
        try {
          let response = await fetch(
            'https://taltech.akaver.com/api/v1/Account/Register',
            requestData,
          );
          let responseJson = await response.json();
          if (response.status === 400) {
            console.log('unexpected error in signup process');
          } else {
            await AsyncStorage.setItem('@token', responseJson.token);
            dispatch({
              type: 'REGISTER',
              email: userEmail,
              firstName: userFirstName,
              lastName: userLastName,
              token: responseJson.token,
            });

            let userJson = JSON.stringify({
              email: userEmail,
              firstName: userFirstName,
              lastName: userLastName,
            });
            await AsyncStorage.setItem('@user', userJson);

            let defaultCategory = new Category();
            defaultCategory.categoryName = 'Default';
            postCategory(defaultCategory);

            let normalPriority = new Priority();
            normalPriority.priorityName = 'Normal';
            postPriority(normalPriority);

            let importantPriority = new Priority();
            importantPriority.priorityName = 'Important';
            postPriority(importantPriority);
          }
        } catch (e) {
          console.log(e);
        }
      },
    }),
    [],
  );

  useEffect(() => {
    setTimeout(async () => {
      let userToken;
      let user;
      try {
        user = await AsyncStorage.getItem('@user');
        userToken = await AsyncStorage.getItem('@token');
      } catch (e) {
        console.log(e);
      }
      dispatch({type: 'RETRIEVE_TOKEN', user: user, token: userToken});
    }, 1000);
  }, []);

  if (loginState.isLoading) {
    return (
      <View style={{flex: 1, justifyContent: 'center', alignItems: 'center'}}>
        <ActivityIndicator size="large" />
      </View>
    );
  }
  return (
    <PaperProvider theme={theme}>
      <ThemeContext.Provider value={themeContext}>
        <AuthContext.Provider value={authContext}>
          <NavigationContainer theme={theme}>
            {loginState.userToken != null ? (
              <Drawer.Navigator
                drawerContent={props => <DrawerComponent {...props} />}>
                <Drawer.Screen name="ToDoReact" component={MainTabScreen} />
              </Drawer.Navigator>
            ) : (
              <RootStackNavigation />
            )}
          </NavigationContainer>
        </AuthContext.Provider>
      </ThemeContext.Provider>
    </PaperProvider>
  );
};

export default App;
