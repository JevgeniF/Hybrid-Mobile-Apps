import React, { useState } from "react";
import { Button } from "react-native";
import { CounterDisplay } from "./CounterDisplay";

export interface IProps {
    count: number;
}

export const Counter = (props: IProps): JSX.Element => {
    const [count, setStateCount] = useState(props.count);

    return (
        <>
        <Button title = "-" onPress = {() => {setStateCount(count - 1)}} />
        <CounterDisplay counterValue = {count} />
        <Button title = "+" onPress = {() => {setStateCount(count + 1)}} />
        </>
    );
};
