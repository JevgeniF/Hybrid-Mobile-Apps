import React, { useContext } from 'react';
import { Button, StyleSheet, View } from "react-native";
import { AppContext, AppContextProvider } from '../context/appContext';

export interface Props {

}

export const CounterButtons = (props: Props) => {

  const context = useContext(AppContext);
  return (
    <View style={styles.buttonsContainer}>
      <View style={styles.singleButtonContainer}>
        <Button title="-" onPress={() => {context.updateCounter(-1);}}></Button>
      </View>
      <View style={styles.singleButtonContainer}>
        <Button title="+" onPress={() => {context.updateCounter(+1)}}></Button>
      </View>
    </View>);
}

const styles = StyleSheet.create({
  buttonsContainer: {
    //backgroundColor: '#0f0',
    flex: 1,
    flexDirection: 'row',
    justifyContent: 'space-around',
  },
  singleButtonContainer: {
    minHeight: 50,
    minWidth: 50,
  }
})
