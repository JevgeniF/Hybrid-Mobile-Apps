import React, { useContext, useState } from "react";
import {
  StyleSheet, 
  Text, 
  View,
  useWindowDimensions
} from "react-native";
import { Counter } from "./src/components/Counter";
import { AppContext, AppContextProvider, IAppContext, initialContext } from "./src/context/appContext";
import { NavigationContainer } from "@react-navigation/native";
import { createStackNavigator } from "@react-navigation/stack";
import { Home } from "./src/screens/Home";
import { TStackParamlist } from "./src/types/types";
import { Info } from "./src/screens/Info";

const Stack = createStackNavigator<TStackParamlist>();

const App = () => {

  const calculateCounter = (counter: number, change: number) => {
    let newCounter = counter + change;
    newCounter = 
      newCounter > 7 ? 0 : 
        (newCounter < 0 ? 7 : newCounter);
    return newCounter;
  }

  const updateCounter = (change: number) => {  
    setState((prevState) => ({
      ...prevState,
      counter: calculateCounter(prevState.counter, change ),
    }));
  }
  
  const initialState: IAppContext = {
    ...initialContext,
    updateCounter: updateCounter,
  }

  const [state, setState] = useState(initialState);

  return (
    <NavigationContainer>
      <AppContextProvider value = {state}>
        <Stack.Navigator>
          <Stack.Screen
          name = "Home"
          component = {Home}
          />
          <Stack.Screen
          name = "Info"
          component = {Info}
          />
        </Stack.Navigator>
      </AppContextProvider>
    </NavigationContainer>
  );
};

export default App;
