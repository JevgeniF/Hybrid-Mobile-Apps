import React from "react";
import { Text } from "react-native";

export interface IProps {
    counterValue: number;
}

export const CounterDisplay = (props: IProps) => {
    const formatNumber = (n: number, places: number = 3, padChar: string = '0'): string => {
        let txt = n.toString();
        while (txt.length < places) {
            txt = padChar + txt;
        }
        return txt;
    }
    return (<Text>Count: {formatNumber(props.counterValue)}</Text>)
};
