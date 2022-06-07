import React from 'react';

import {
  StyleSheet, Text, View,
} from 'react-native';

import {
  Colors,
} from 'react-native/Libraries/NewAppScreen';
import { Counter } from './components/Counter';
import { CounterDisplay} from './components/CounterDisplay'
import { Greeting } from './components/Greeting';

const App = () => { 
  return (
    <View>
      <Greeting name = "Jevgeni" />
      <Counter count = {1} />
    </View>
  );
};

const styles = StyleSheet.create({  
});

export default App;
