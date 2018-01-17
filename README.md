# react-native-top-modal

The top modal for react native, include the keyboard.

## Installation

```bash
$ npm install react-native-top-modal --save
$ react-native link react-native-top-modal
```

## Usage

```javascript
import RNTopModal from 'react-native-top-modal';

export default class App extends Component<{}> {
  render() {
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
  }
}

```
