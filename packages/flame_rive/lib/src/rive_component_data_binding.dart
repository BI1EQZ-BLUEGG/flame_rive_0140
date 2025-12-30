part of 'rive_component.dart';

extension RiveComponentDataBinding on RiveComponent {
  ViewModelInstanceNumber? getNumber(String path) {
    return _viewModelInstance?.number(path);
  }

  ViewModelInstanceString? getString(String path) {
    return _viewModelInstance?.string(path);
  }

  ViewModelInstanceBoolean? getBoolean(String path) {
    return _viewModelInstance?.boolean(path);
  }

  ViewModelInstanceTrigger? getTrigger(String path) {
    return _viewModelInstance?.trigger(path);
  }

  ViewModelInstanceColor? getColor(String path) {
    return _viewModelInstance?.color(path);
  }

  ViewModelInstanceEnum? getEnum(String path) {
    return _viewModelInstance?.enumerator(path);
  }

  ViewModelInstanceList? getList(String path) {
    return _viewModelInstance?.list(path);
  }

  ViewModelInstanceAssetImage? getImage(String path) {
    return _viewModelInstance?.image(path);
  }

  ViewModelInstance? getViewModel(String path) {
    return _viewModelInstance?.viewModel(path);
  }

  bool setNumber(String path, double value) {
    final prop = getNumber(path);
    if (prop != null) {
      prop.value = value;
      return true;
    }
    return false;
  }

  bool setString(String path, String value) {
    final prop = getString(path);
    if (prop != null) {
      prop.value = value;
      return true;
    }
    return false;
  }

  bool setBool(String path, bool value) {
    final prop = getBoolean(path);
    if (prop != null) {
      prop.value = value;
      return true;
    }
    return false;
  }

  bool fire(String path) {
    final prop = getTrigger(path);
    if (prop != null) {
      prop.trigger();
      return true;
    }
    return false;
  }

  bool setColor(String path, Color value) {
    final prop = getColor(path);
    if (prop != null) {
      prop.value = value;
      return true;
    }
    return false;
  }

  bool setEnum(String path, String value) {
    final prop = getEnum(path);
    if (prop != null) {
      prop.value = value;
      return true;
    }
    return false;
  }

  bool setImage(String path, RenderImage? value) {
    final prop = getImage(path);
    if (prop != null) {
      prop.value = value;
      return true;
    }
    return false;
  }
}
