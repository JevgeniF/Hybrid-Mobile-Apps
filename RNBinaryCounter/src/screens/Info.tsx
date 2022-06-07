import { NativeStackScreenProps } from "@react-navigation/native-stack";
import React, { useContext } from "react";
import { Button, Text, View } from "react-native";
import { AppContext } from "../context/appContext";
import { TStackParamlist} from "../types/types"

type Props = NativeStackScreenProps<TStackParamlist, 'Info'>;

export const Info = ({ route, navigation }: Props) => {

    const context = useContext(AppContext);
    
    return (
        <View>
            <Text>{context.counter.toString()}</Text>
            <Button title = "Back" onPress = {() => {navigation.goBack()}}/>
        </View>
    );
}