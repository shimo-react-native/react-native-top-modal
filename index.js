import React, {Component, Children} from 'react';
import PropTypes from 'prop-types';
import {StyleSheet, requireNativeComponent, I18nManager, View, Platform} from 'react-native';

const RNTopModal = requireNativeComponent(Platform.OS === 'ios' ? 'RNTopModal' : 'TopModal');
const TopModalContentView = requireNativeComponent('TopModalContentView');

const styles = StyleSheet.create({
  topModal: {
    position: 'absolute',
    overflow: 'hidden',
    top: 0,
    right: 0,
    bottom: 0,
    left: 0
  }
});

export default class extends Component {
  static displayName = 'TopModal';
  static propTypes = {
    /**
     * The `visible` prop determines whether your topModal is visible.
     */
    visible: PropTypes.bool,
    /**
     * The `keyWindow` prop determines whether the window for your topModal will be key window in iOS.
     */
    keyWindow: PropTypes.bool
  };

  static defaultProps = {
    visible: true,
    keyWindow: false
  };

  render() {
    const {style, visible, keyWindow, children, props} = this.props;

    if (visible === false) {
      return null;
    }

    return (
      <RNTopModal
        style={styles.topModal}
        keyWindow>
        {
          Platform.OS === 'android' ? (
            <TopModalContentView
              style={style}
            >
              {children}
            </TopModalContentView>
          ) : (
            <View style={style}>
              {children}
            </View>
          )
        }
      </RNTopModal>
    )
  }
}

