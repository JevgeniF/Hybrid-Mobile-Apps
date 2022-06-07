/* eslint-disable no-shadow,react-native/no-inline-styles */
// @ts-ignore
import React, {useContext, useEffect, useState} from 'react';
import {StyleSheet, View} from 'react-native';
import {DrawerContentScrollView, DrawerItem} from '@react-navigation/drawer';
import {
  Avatar,
  Caption,
  Drawer,
  Switch,
  Text,
  Title,
  TouchableRipple,
  useTheme,
} from 'react-native-paper';
import Icon from 'react-native-vector-icons/MaterialIcons';
import {AuthContext, ThemeContext} from '../context/context';
import AsyncStorage from '@react-native-async-storage/async-storage';

export function DrawerComponent(props) {
  const {signOut} = useContext(AuthContext);
  const {toggleTheme} = useContext(ThemeContext);

  const paperTheme = useTheme();

  const [user, setUser] = useState({
    name: '',
    lastName: '',
    email: '',
  });

  useEffect(() => {
    function getUserData() {
      AsyncStorage.getItem('@user').then(stringUser => {
        let user = JSON.parse(stringUser);
        setUser({
          ...user,
          name: user.firstName,
          lastName: user.lastName,
          email: user.email,
        });
      });
    }

    getUserData();
  }, []);

  return (
    <View style={{flex: 1}}>
      <DrawerContentScrollView {...props}>
        <View style={{...styles.root}}>
          <View style={{...styles.userInfo}}>
            <View style={{flexDirection: 'row', marginTop: 15}}>
              <Avatar.Image
                source={require('../../assets/userImage.png')}
                size={50}
              />
              <View style={{...styles.userTitle}}>
                <Title style={{...styles.title}}>
                  {user.name} {user.lastName}
                </Title>
                <Caption style={{...styles.caption}}>{user.email}</Caption>
              </View>
            </View>
          </View>
        </View>
        <Drawer.Section style={{...styles.drawerSection}}>
          <DrawerItem
            icon={({color, size}) => (
              <Icon name="check" color={color} size={size} />
            )}
            label="Tasks"
            onPress={() => {
              props.navigation.navigate('Tasks');
            }}
          />
          <DrawerItem
            icon={({color, size}) => (
              <Icon name="list" color={color} size={size} />
            )}
            label="ToDo Lists"
            onPress={() => {
              props.navigation.navigate('ToDo Lists');
            }}
          />
        </Drawer.Section>
        <Drawer.Section title="Preferences">
          <TouchableRipple
            onPress={() => {
              toggleTheme();
            }}>
            <View style={{...styles.preference}}>
              <Text>Dark Theme</Text>
              <View pointerEvents="none">
                <Switch value={paperTheme.dark} />
              </View>
            </View>
          </TouchableRipple>
        </Drawer.Section>
      </DrawerContentScrollView>
      <Drawer.Section style={{...styles.bottomDrawerSection}}>
        <DrawerItem
          icon={({color, size}) => (
            <Icon name="logout" color={color} size={size} />
          )}
          label="Sign Out"
          onPress={() => {
            signOut();
          }}
        />
      </Drawer.Section>
    </View>
  );
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
  },

  userInfo: {
    paddingLeft: 20,
  },

  userTitle: {
    marginLeft: 15,
    flexDirection: 'column',
  },

  title: {
    fontSize: 16,
    marginTop: 3,
    fontWeight: 'bold',
  },

  caption: {
    fontSize: 14,
    lineHeight: 14,
  },

  drawerSection: {
    marginTop: 15,
  },

  bottomDrawerSection: {
    marginBottom: 15,
    borderTopColor: '#f4f4f4',
    borderTopWidth: 1,
  },

  preference: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingVertical: 12,
    paddingHorizontal: 16,
  },
});
