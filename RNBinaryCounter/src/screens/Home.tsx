import React from "react";
import {
    StyleSheet, 
    Text, 
    View,
    useWindowDimensions,
    Button
  } from "react-native";
import { Counter } from "../components/Counter";
import { NativeStackScreenProps} from "@react-navigation/native-stack";
import { TStackParamlist } from "../types/types";

type Props = NativeStackScreenProps<TStackParamlist, 'Home'>;

export const Home = ({route, navigation}: Props) => {
const window = useWindowDimensions();
  const isPortrait = () => window.height > window.width;
  const orientationStyle = () => isPortrait() ? 'column' : 'row';

    return (
    <View style={{
        ...styles.root,
        flexDirection: orientationStyle()
        }}>
          <Counter bitNo = {2}/>
          <Counter bitNo = {1}/>
          <Counter bitNo = {0}/>
          <Button title = "Next screen" onPress = {() => {navigation.navigate('Info')}}/>
        </View>
    );
}

const styles = StyleSheet.create({
    root: {
      //backgroundColor: '#f00',
      flex: 1,
      width: '100%',
      height: '100%',
      flexDirection: 'column',
      justifyContent: 'space-around',
      alignItems: 'center',
    }
  });