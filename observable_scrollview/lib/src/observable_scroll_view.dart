import 'package:flutter/material.dart';

/// Scroll direction enum
enum ObservableScrollDirection { up, down, idle }

class ObservableScrollView extends StatefulWidget {
  final List<Widget> children;

  /// Callbacks
  final ValueChanged<double>? onOffsetChanged;
  final ValueChanged<ObservableScrollDirection>? onDirectionChanged;
  final VoidCallback? onTopReached;
  final VoidCallback? onBottomReached;

  /// Scroll config
  final EdgeInsets padding;
  final ScrollPhysics physics;

  const ObservableScrollView({
    super.key,
    required this.children,
    this.onOffsetChanged,
    this.onDirectionChanged,
    this.onTopReached,
    this.onBottomReached,
    this.padding = EdgeInsets.zero,
    this.physics = const BouncingScrollPhysics(),
  });

  @override
  State<ObservableScrollView> createState() => _ObservableScrollViewState();
}

class _ObservableScrollViewState extends State<ObservableScrollView> {
  final ScrollController _controller = ScrollController();

  double _lastOffset = 0;
  ObservableScrollDirection _direction =
      ObservableScrollDirection.idle;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
  }

  void _handleScroll() {
    final offset = _controller.offset;

    /// Offset callback
    widget.onOffsetChanged?.call(offset);

    /// Direction detection
    if (offset > _lastOffset &&
        _direction != ObservableScrollDirection.down) {
      _direction = ObservableScrollDirection.down;
      widget.onDirectionChanged?.call(_direction);
    } else if (offset < _lastOffset &&
        _direction != ObservableScrollDirection.up) {
      _direction = ObservableScrollDirection.up;
      widget.onDirectionChanged?.call(_direction);
    }

    /// Top reached
    if (_controller.position.pixels <=
        _controller.position.minScrollExtent) {
      widget.onTopReached?.call();
    }

    /// Bottom reached
    if (_controller.position.pixels >=
        _controller.position.maxScrollExtent) {
      widget.onBottomReached?.call();
    }

    _lastOffset = offset;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _controller,
      padding: widget.padding,
      physics: widget.physics,
      children: widget.children,
    );
  }
}
