// @ts-ignore
import React from 'react';
import {
  Dimensions,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from 'react-native';
import LinearGradient from 'react-native-linear-gradient';
import Icon from 'react-native-vector-icons/MaterialIcons';
import * as Animatable from 'react-native-animatable';
import {useTheme} from '@react-navigation/native';

const LandingScreen = ({navigation}) => {
  const {colors} = useTheme();

  return (
    <View style={{...styles.container}}>
      <View style={{...styles.header}}>
        <Animatable.Image
          animation="jello"
          duration={3000}
          source={require('../../assets/logo.png')}
          style={{...styles.logo}}
          resizeMode="stretch"
        />
      </View>
      <Animatable.View
        animation="fadeInUpBig"
        style={{...styles.footer, backgroundColor: colors.background}}>
        <Text style={{...styles.title}}>Don't forget anymore...</Text>
        <Text style={{...styles.text, color: colors.text}}>
          Sign in with your account
        </Text>
        <View style={{...styles.button}}>
          <TouchableOpacity onPress={() => navigation.navigate('SignInScreen')}>
            <LinearGradient
              colors={['#a749ff', '#1f00c4']}
              style={{...styles.signIn}}>
              <Text style={{...styles.textSign}}>Sign In</Text>
              <Icon name="arrow-right" color="#ffffff" size={20} />
            </LinearGradient>
          </TouchableOpacity>
        </View>
      </Animatable.View>
    </View>
  );
};

const {height} = Dimensions.get('screen');
const height_logo = height * 0.25;

// noinspection JSSuspiciousNameCombination
const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#6c00f8',
  },
  header: {
    flex: 2,
    justifyContent: 'center',
    alignItems: 'center',
  },
  footer: {
    flex: 1,
    backgroundColor: '#ffffff',
    borderTopLeftRadius: 30,
    borderTopRightRadius: 30,
    paddingVertical: 25,
    paddingHorizontal: 30,
  },
  logo: {
    width: height_logo,
    height: height_logo,
  },
  title: {
    color: '#6c00f8',
    fontSize: 30,
    fontWeight: 'bold',
  },
  text: {
    color: 'grey',
    marginTop: 5,
  },
  button: {
    alignItems: 'flex-end',
    marginTop: 15,
  },
  signIn: {
    backgroundColor: '#6c00f8',
    width: 150,
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

export default LandingScreen;
