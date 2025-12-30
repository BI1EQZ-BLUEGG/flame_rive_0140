import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/widgets.dart' show Alignment;
import 'package:rive/rive.dart';

part 'rive_component_data_binding.dart';

part 'rive_component_events.dart';

part 'rive_component_inputs.dart';

class RiveComponent extends PositionComponent {
  /// Path to the .riv file asset.
  final String assetPath;

  /// The name of the artboard to use. If null, the default artboard is used.
  final String? artboardName;

  /// The name of the state machine to use. If null, the default state machine is used.
  final String? stateMachineName;

  /// The name of the animation to play (for simple animation without state machine).
  final String? animationName;

  /// How to fit the artboard into the component bounds.
  final Fit fit;

  /// Alignment of the artboard within the component bounds.
  final Alignment alignment;

  /// Whether to clip the artboard to the component bounds.
  /// When true, any content outside the component size will be clipped.
  final bool clipToBounds;

  /// Whether antialiasing is enabled for rendering.
  /// Note: In rive 0.14+, Flutter renderer has antialiasing enabled by default.
  final bool antialiasing;

  /// Callback when the artboard is loaded.
  final void Function(Artboard artboard)? onArtboardLoaded;

  /// Callback to access the state machine after it's created.
  final void Function(StateMachine stateMachine)? onStateMachineLoaded;

  /// Callback to access the view model instance after it's created.
  final void Function(ViewModelInstance viewModelInstance)? onViewModelLoaded;

  /// Callback when a Rive event is triggered.
  void Function(Event event)? onRiveEvent;

  ///MARK: Private

  /// The loaded Rive file.
  File? _riveFile;

  /// The artboard instance.
  Artboard? _artboard;

  /// The state machine (if using state machine).
  StateMachine? _stateMachine;

  /// Simple animation (if using simple animation).
  Animation? _animation;

  /// The view model instance for data binding.
  ViewModelInstance? _viewModelInstance;

  RiveComponent({
    required this.assetPath,
    this.artboardName,
    this.stateMachineName,
    this.animationName,
    this.fit = Fit.contain,
    this.alignment = Alignment.center,
    this.clipToBounds = false,
    this.antialiasing = true,
    this.onArtboardLoaded,
    this.onStateMachineLoaded,
    this.onViewModelLoaded,
    this.onRiveEvent,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
    super.key,
  });

  /// Creates a RiveComponent from a pre-loaded RiveFile.
  RiveComponent.fromFile({
    required File riveFile,
    this.artboardName,
    this.stateMachineName,
    this.animationName,
    this.fit = Fit.contain,
    this.alignment = Alignment.center,
    this.clipToBounds = true,
    this.antialiasing = true,
    this.onArtboardLoaded,
    this.onStateMachineLoaded,
    this.onViewModelLoaded,
    this.onRiveEvent,
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.priority,
    super.key,
  }) : assetPath = '' {
    _riveFile = riveFile;
  }

  // ==================== Getters ====================

  /// Whether the component is ready to render.
  // bool get isLoaded => _artboard != null;

  /// Gets the current artboard.
  Artboard? get artboard => _artboard;

  /// Gets the Rive file.
  File? get riveFile => _riveFile;

  /// Gets the state machine if available.
  StateMachine? get stateMachine => _stateMachine;

  /// Gets the view model instance if data binding is enabled.
  ViewModelInstance? get viewModelInstance => _viewModelInstance;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await _loadRiveFile();
  }

  Future<void> _loadRiveFile() async {
    if (_riveFile == null && assetPath.isNotEmpty) {
      _riveFile = await File.asset(
        assetPath,
        riveFactory: Factory.flutter,
      );
    }

    if (_riveFile == null) {
      throw Exception('Failed to load Rive file: $assetPath');
    }

    // Get the artboard
    if (artboardName != null) {
      _artboard = _riveFile!.artboard(artboardName!);
    } else {
      _artboard = _riveFile!.defaultArtboard();
    }

    if (_artboard == null) {
      throw Exception(
        'Artboard not found: ${artboardName ?? "default artboard"} in $assetPath',
      );
    }

    // Only use artboard size if user didn't set a size
    // Otherwise, use the user-provided size with fit/alignment
    if (size.isZero()) {
      size = Vector2(
        _artboard!.width,
        _artboard!.height,
      );
    }

    // Setup state machine or simple animation
    if (stateMachineName != null) {
      _stateMachine = _artboard!.stateMachine(stateMachineName!);
    } else if (animationName != null) {
      _animation = _artboard!.animationNamed(animationName!);
    } else {
      // Try to get default state machine
      _stateMachine = _artboard!.defaultStateMachine();
    }

    if (_stateMachine != null) {
      _setupDataBinding();
      if (onRiveEvent != null) {
        _stateMachine!.addEventListener(onRiveEvent!);
      }
      onStateMachineLoaded?.call(_stateMachine!);
    }
    onArtboardLoaded?.call(_artboard!);
  }

  void _setupDataBinding() {
    if (_riveFile == null || _artboard == null || _stateMachine == null) {
      return;
    }

    // Get the default view model for this artboard
    final viewModel = _riveFile!.defaultArtboardViewModel(_artboard!);
    if (viewModel == null) {
      return;
    }

    // Create the default instance
    _viewModelInstance = viewModel.createDefaultInstance();
    if (_viewModelInstance == null) {
      return;
    }

    // Bind the view model instance to the state machine
    _stateMachine!.bindViewModelInstance(_viewModelInstance!);

    // Notify callback
    onViewModelLoaded?.call(_viewModelInstance!);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_artboard == null) {
      return;
    }

    if (_stateMachine != null) {
      _stateMachine!.advanceAndApply(dt);

      // Handle view model callbacks if data binding is enabled
      _viewModelInstance?.handleCallbacks();

      // Process reported events
      _processReportedEvents();
    } else if (_animation != null) {
      _animation!.advanceAndApply(dt);
    } else {
      _artboard!.advance(dt);
    }
  }

  void _processReportedEvents() {
    if (_stateMachine == null) {
      return;
    }

    // Get and process reported events
    // Events are automatically dispatched to listeners registered via addEventListener
    // We just need to call reportedEvents() to trigger the dispatch and cleanup
    final events = _stateMachine!.reportedEvents();

    // Dispose events after processing
    for (final event in events) {
      event.dispose();
    }
  }

  @override
  void render(Canvas canvas) {
    if (_artboard == null) {
      return;
    }
    canvas.save();

    // Clip to component bounds if enabled
    if (clipToBounds) {
      canvas.clipRect(Rect.fromLTWH(0, 0, size.x, size.y));
    }

    // Apply antialiasing setting
    if (!antialiasing) {
      canvas.saveLayer(
        Rect.fromLTWH(0, 0, size.x, size.y),
        Paint()..isAntiAlias = false,
      );
    }

    final renderer = Renderer.make(canvas);
    try {
      final artboardBounds = _artboard!.bounds;
      final frame = AABB.fromValues(0, 0, size.x, size.y);
      renderer.align(
        fit,
        alignment,
        frame,
        artboardBounds,
        1.0,
      );
      _artboard!.draw(renderer);
    } finally {
      renderer.dispose();
      if (!antialiasing) {
        canvas.restore();
      }
      canvas.restore();
    }
  }

  @override
  void onRemove() {
    if (onRiveEvent != null && _stateMachine != null) {
      _stateMachine!.removeEventListener(onRiveEvent!);
    }

    _viewModelInstance?.dispose();
    _stateMachine?.dispose();
    _animation?.dispose();
    _artboard?.dispose();
    _riveFile?.dispose();

    super.onRemove();
  }
}
