import React from 'react';
import { StyleSheet, View } from "react-native";
import { CounterDisplay } from "./CounterDisplay";
import { CounterButtons } from "./CounterButtons";

export interface Props {
  bitNo: number
}

export const Counter = (props: Props) => {
  return (
    <View style={styles.counterContainer}>
      <CounterDisplay bitNo={props.bitNo}/>
      <CounterButtons />
    </View>
  );
}

const styles = StyleSheet.create({
  counterContainer: {
    flex: 1,
    flexDirection: 'column',
    alignItems: 'center',
    justifyContent: 'space-between',
    //backgroundColor: '#0f0',
  }
})
