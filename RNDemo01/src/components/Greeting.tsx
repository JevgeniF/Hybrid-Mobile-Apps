import React from "react";
import { Text } from "react-native";

export interface IProps {
    name: string;
}

export const Greeting = (props: IProps) => {
    return (<Text>Greeting, {props.name}</Text>)
};
