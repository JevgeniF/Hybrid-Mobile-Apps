import React, { useContext } from 'react';
import { StyleSheet, Text, View } from "react-native";
import { AppContext } from '../context/appContext';

export interface Props {
  bitNo: number,
}

export const CounterDisplay = (props: Props) => {

  const context = useContext(AppContext)
  return (
    <View style={styles.textContainer}>
      <Text style={styles.text}>{context.getBit(context.counter, props.bitNo)}</Text>
    </View>);
}

const styles = StyleSheet.create({
  textContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    alignContent: 'center',
    flexDirection: 'row',
    width: 100,
    backgroundColor: '#000',
  },
  text: {
    width: 100,
    color: '#fff',
    fontSize: 50,
    fontWeight: 'bold',
    textAlign: 'center',
  }
})
