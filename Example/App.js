/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, {Component} from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  TouchableOpacity,
  NativeModules
} from 'react-native';
import TopModal from 'react-native-top-modal';

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#F5FCFF',
  },
  welcome: {
    fontSize: 20,
    textAlign: 'center',
    margin: 10,
  },
  button: {
    backgroundColor: 'red',
    width: 200,
    height: 50,
    justifyContent: 'center',
    alignItems: 'center'
  },
  modal: {
    backgroundColor: 'blue',
    position: 'absolute',
    top: 0,
    right: 0,
    bottom: 0,
    left: 0,
    justifyContent: 'center',
    alignItems: 'center'
  }
});

export default class App extends Component<{}> {
  constructor(props) {
    super(props);
    this.state = {
      modal: false
    };
  }

  _showModal = () => {
    this.setState({
      modal: true
    });
  };

  _hideModal = () => {
    this.setState({
      modal: false
    });
  };

  _renderModal = () => {
    return (
      <TopModal style={styles.modal}>
        <TouchableOpacity
          style={styles.button}
          onPress={this._hideModal}>
          <Text>
            Hide Modal
          </Text>
        </TouchableOpacity>
      </TopModal>
    )
  };

  render() {
    const {modal} = this.state;
    return (
      <View style={styles.container}>
        <Text style={styles.welcome}>
          Welcome to React Native!
        </Text>
        <TouchableOpacity
          style={styles.button}
          onPress={this._showModal}>
          <Text>
            Show Modal
          </Text>
        </TouchableOpacity>
        {modal && this._renderModal()}
      </View>
    );
  }
}
