/* eslint-disable react-native/no-inline-styles */
// @ts-ignore
import React, {useContext, useState} from 'react';
import {
  StyleSheet,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import IconFa from 'react-native-vector-icons/FontAwesome';
import IconFe from 'react-native-vector-icons/Feather';
import * as Animatable from 'react-native-animatable';
import {AuthContext} from '../context/context';
import Toast from 'react-native-simple-toast';
import {useTheme} from '@react-navigation/native';

const SignUpScreen = ({navigation}) => {
  const {colors} = useTheme();

  const [data, setData] = useState({
    name: '',
    lastName: '',
    email: '',
    password: '',
    isNameOk: false,
    isLastNameOk: false,
    isEmailPattern: false,
    isPasswordPattern: false,
    secureTextEntry: true,
  });

  const {signUp} = useContext(AuthContext);

  const nameInputChange = (value: string) => {
    if (value.trim().length >= 2) {
      setData({
        ...data,
        name: value,
        isNameOk: true,
      });
    } else {
      setData({
        ...data,
        name: value,
        isNameOk: false,
      });
    }
  };

  const lastNameInputChange = (value: string) => {
    if (value.trim().length >= 2) {
      setData({
        ...data,
        lastName: value,
        isLastNameOk: true,
      });
    } else {
      setData({
        ...data,
        lastName: value,
        isLastNameOk: false,
      });
    }
  };

  const emailInputChange = (value: string) => {
    let emailPattern = /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w\w+)+$/;
    if (value.match(emailPattern)) {
      setData({
        ...data,
        email: value,
        isEmailPattern: true,
      });
    } else {
      setData({
        ...data,
        email: value,
        isEmailPattern: false,
      });
    }
  };

  const passwordInputChange = (value: string) => {
    let passwordPattern =
      /^(?=.*?[A-Z])(?=(.*[a-z])+)(?=(.*[\d])+)(?=(.*[\W])+)(?!.*\s).{6,}$/;
    if (value.match(passwordPattern)) {
      setData({
        ...data,
        password: value,
        isPasswordPattern: true,
      });
    } else {
      setData({
        ...data,
        password: value,
        isPasswordPattern: false,
      });
    }
  };

  const togglePasswordVisibility = () => {
    setData({
      ...data,
      secureTextEntry: !data.secureTextEntry,
    });
  };

  const signUpHandle = (
    name: string,
    lastName: string,
    email: string,
    password: string,
  ) => {
    if (!data.isNameOk) {
      Toast.show('Name is too short. Min 2 letters.');
    } else if (!data.isLastNameOk) {
      Toast.show('Last name is too short. Min 2 letters.');
    } else if (!data.isEmailPattern) {
      Toast.show('Email address is not valid.');
    } else if (data.password.length < 6) {
      Toast.show('Password is too short. Min 6 characters.');
    } else if (!data.isPasswordPattern) {
      Toast.show(
        'Password must have at least one digit, one capital letter and one special character.',
      );
    } else {
      signUp(name, lastName, email, password);
    }
  };

  return (
    <View style={{...styles.container}}>
      <View style={{...styles.header}}>
        <Text style={{...styles.textHeader}}>Please register...</Text>
      </View>
      <Animatable.View
        animation="fadeInUpBig"
        style={{...styles.footer, backgroundColor: colors.background}}>
        <View style={{flexDirection: 'row', justifyContent: 'space-between'}}>
          <View style={{width: '45%'}}>
            <Text style={{...styles.textFooter, color: colors.text}}>Name</Text>
            <View style={{...styles.action}}>
              <IconFa name="user-o" size={20} color={colors.text} />
              <TextInput
                style={{...styles.textInput, color: colors.text}}
                placeholder="min 2 letters"
                onChangeText={value => nameInputChange(value)}
              />
              {data.isNameOk ? (
                <IconFe name="check-circle" color="green" size={20} />
              ) : null}
            </View>
          </View>
          <View style={{width: '45%'}}>
            <Text style={{...styles.textFooter, color: colors.text}}>
              Last Name
            </Text>
            <View style={{...styles.action}}>
              <IconFa name="user-o" size={20} color={colors.text} />
              <TextInput
                style={{...styles.textInput, color: colors.text}}
                placeholder="min 2 letters"
                autoCapitalize="none"
                onChangeText={value => lastNameInputChange(value)}
              />
              {data.isLastNameOk ? (
                <IconFe name="check-circle" color="green" size={20} />
              ) : null}
            </View>
          </View>
        </View>
        <Text style={{...styles.textFooter, color: colors.text}}>Email</Text>
        <View style={{...styles.action}}>
          <IconFe name="mail" size={20} color={colors.text} />
          <TextInput
            style={{...styles.textInput, color: colors.text}}
            placeholder="your e-mail"
            autoCapitalize="none"
            onChangeText={value => emailInputChange(value)}
          />
          {data.isEmailPattern ? (
            <IconFe name="check-circle" color="green" size={20} />
          ) : null}
        </View>
        <Text style={{...styles.textFooter, marginTop: 10, color: colors.text}}>
          Password
        </Text>
        <View style={{...styles.action}}>
          <IconFe name="lock" size={20} color={colors.text} />
          <TextInput
            style={{...styles.textInput, color: colors.text}}
            placeholder="min 6 chars, 1 uppercase, 1 number, 1 special"
            autoCapitalize="none"
            secureTextEntry={data.secureTextEntry}
            onChangeText={value => passwordInputChange(value)}
          />
          {data.isPasswordPattern ? (
            <IconFe name="check-circle" color="green" size={20} />
          ) : null}
          <TouchableOpacity onPress={togglePasswordVisibility}>
            {data.secureTextEntry ? (
              <IconFe name="eye-off" color="gray" size={20} />
            ) : (
              <IconFe name="eye" color="gray" size={20} />
            )}
          </TouchableOpacity>
        </View>
        <View
          style={{
            ...styles.button,
            flexDirection: 'row',
            justifyContent: 'space-evenly',
          }}>
          <TouchableOpacity
            style={{...styles.signIn}}
            onPress={() => {
              signUpHandle(data.name, data.lastName, data.email, data.password);
            }}>
            <LinearGradient
              colors={['#a749ff', '#1f00c4']}
              style={{...styles.signIn}}>
              <Text style={{...styles.textSign}}>Sign Up</Text>
            </LinearGradient>
          </TouchableOpacity>
          <TouchableOpacity
            onPress={() => navigation.goBack()}
            style={{...styles.signIn, borderColor: '#6c00f8', borderWidth: 1}}>
            <Text style={{...styles.textSign, color: '#6c00f8'}}>Sign In</Text>
          </TouchableOpacity>
        </View>
      </Animatable.View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#6c00f8',
  },
  header: {
    flex: 1,
    justifyContent: 'flex-end',
    paddingHorizontal: 20,
    paddingBottom: 25,
  },
  footer: {
    flex: 5,
    backgroundColor: '#ffffff',
    borderTopLeftRadius: 30,
    borderTopRightRadius: 30,
    paddingHorizontal: 20,
    paddingVertical: 15,
  },
  textHeader: {
    color: '#ffffff',
    fontWeight: 'bold',
    fontSize: 30,
  },
  textFooter: {
    color: '#05375a',
    fontSize: 15,
  },
  action: {
    flexDirection: 'row',
    marginTop: 5,
    borderBottomWidth: 1,
    borderBottomColor: '#f2f2f2',
    paddingBottom: 5,
  },
  actionError: {
    flexDirection: 'row',
    marginTop: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#FF0000',
    paddingBottom: 5,
  },
  textInput: {
    flex: 1,
    marginTop: -12,
    paddingLeft: 10,
    color: '#05375a',
  },
  button: {
    alignItems: 'center',
    marginTop: 10,
  },
  signIn: {
    width: 140,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
    borderRadius: 15,
    flexDirection: 'row',
  },
  textSign: {
    color: 'white',
    fontSize: 18,
    fontWeight: 'bold',
  },
});

export default SignUpScreen;
