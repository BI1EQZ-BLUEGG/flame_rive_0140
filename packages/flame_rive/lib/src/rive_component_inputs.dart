part of 'rive_component.dart';

/// Extension for legacy State Machine Input functionality.
///
/// These methods are deprecated. Use Data Binding (ViewModel) instead.
extension RiveComponentInputs on RiveComponent {
  /// Gets a boolean input from the state machine by name.
  ///
  /// Deprecated: Use [RiveComponentDataBinding.getBoolean] with Data Binding instead.
  @Deprecated('Use Data Binding instead of state machine inputs')
  BooleanInput? getBoolInput(String name) {
    // ignore: deprecated_member_use
    return _stateMachine?.boolean(name);
  }

  /// Gets a number input from the state machine by name.
  ///
  /// Deprecated: Use [RiveComponentDataBinding.getNumber] with Data Binding instead.
  @Deprecated('Use Data Binding instead of state machine inputs')
  NumberInput? getNumberInput(String name) {
    // ignore: deprecated_member_use
    return _stateMachine?.number(name);
  }

  /// Gets a trigger input from the state machine by name.
  ///
  /// Deprecated: Use [RiveComponentDataBinding.getTrigger] with Data Binding instead.
  @Deprecated('Use Data Binding instead of state machine inputs')
  TriggerInput? getTriggerInput(String name) {
    // ignore: deprecated_member_use
    return _stateMachine?.trigger(name);
  }

  /// Fires a trigger input by name.
  ///
  /// Deprecated: Use [RiveComponentDataBinding.fire] with Data Binding instead.
  @Deprecated('Use Data Binding instead of state machine inputs')
  void fireTrigger(String name) {
    // ignore: deprecated_member_use
    _stateMachine?.trigger(name)?.fire();
  }

  /// Sets a boolean input value by name.
  ///
  /// Deprecated: Use [RiveComponentDataBinding.setBool] with Data Binding instead.
  @Deprecated('Use Data Binding instead of state machine inputs')
  void setBoolInput(String name, bool value) {
    // ignore: deprecated_member_use
    final input = _stateMachine?.boolean(name);
    if (input != null) {
      input.value = value;
    }
  }

  /// Sets a number input value by name.
  ///
  /// Deprecated: Use [RiveComponentDataBinding.setNumber] with Data Binding instead.
  @Deprecated('Use Data Binding instead of state machine inputs')
  void setNumberInput(String name, double value) {
    // ignore: deprecated_member_use
    final input = _stateMachine?.number(name);
    if (input != null) {
      input.value = value;
    }
  }

  /// Gets all inputs from the state machine.
  ///
  /// Deprecated: Use Data Binding instead.
  @Deprecated('Use Data Binding instead of state machine inputs')
  List<Input> get inputs {
    // ignore: deprecated_member_use
    return _stateMachine?.inputs ?? [];
  }
}

