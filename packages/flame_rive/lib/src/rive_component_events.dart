part of 'rive_component.dart';

/// Extension for Rive Event Listening functionality.
///
/// Provides methods to add and remove event listeners on the state machine.
extension RiveComponentEvents on RiveComponent {
  bool addEventListener(void Function(Event event) listener) {
    if (_stateMachine != null) {
      _stateMachine!.addEventListener(listener);
      return true;
    }
    return false;
  }

  bool removeEventListener(void Function(Event event) listener) {
    if (_stateMachine != null) {
      _stateMachine!.removeEventListener(listener);
      return true;
    }
    return false;
  }

  void removeAllEventListeners() {
    _stateMachine?.removeAllEventListeners();
  }
}
