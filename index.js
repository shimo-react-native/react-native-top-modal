import React, { Component, Children } from 'react';
import PropTypes from 'prop-types';
import { StyleSheet, requireNativeComponent, I18nManager, View } from 'react-native';

const RNTopModal = requireNativeComponent('RNTopModal');

const styles = StyleSheet.create({
  topModal: {
    position: 'absolute',
    overflow: 'hidden',
    opacity: 0,
    backgroundColor: 'transparent'
  }
});

export default class extends Component {
  static displayName = 'TopModal';
  static propTypes = {
    /**
     * The `visible` prop determines whether your topModal is visible.
     */
    visible: PropTypes.bool
  };

  static defaultProps = {
    visible: true
  };

  render() {
    const { style, visible, children } = this.props;

    if (visible === false) {
      return null;
    }

    return (
      <RNTopModal
        style={styles.topModal}
        {...this.props}>
        <View style={style}>
          {children}
        </View>
      </RNTopModal>
    );
  }
}

