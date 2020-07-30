import 'dart:async';

import 'package:flutter/material.dart';

class CustomScrollbar extends StatefulWidget {
  CustomScrollbar({
    Key key,
    @required this.child,
    @required this.controller,
    this.heightFraction = 0.20,
    this.scrollBarWidth = 10.0,
    this.color = Colors.red,
    this.backgroundColor = Colors.black12,
    this.showScrollbar = false,
  })  : assert(child != null),
        assert(controller != null),
        assert(heightFraction != null &&
            heightFraction < 1.0 &&
            heightFraction > 0.0),
        super(key: key);

  final Widget child;
  final ScrollController controller;
  final double heightFraction;
  final double scrollBarWidth;
  final Color color;
  final Color backgroundColor;
  final bool showScrollbar;

  @override
  _CustomScrollbarState createState() => _CustomScrollbarState();
}

class _CustomScrollbarState extends State<CustomScrollbar> {
  double _scrollPosition = 0;
  bool _isUpdating;
  Timer timer;

  Size get _screenSize => MediaQuery.of(context).size;
  double get _scrollerHeight => _screenSize.height * widget.heightFraction;
  double get _distanceFromTop => widget.controller.hasClients
      ? ((_screenSize.height *
              _scrollPosition /
              widget.controller.position.maxScrollExtent) -
          (_scrollerHeight *
              _scrollPosition /
              widget.controller.position.maxScrollExtent))
      : 0;

  static const _kDuration = Duration(milliseconds: 300);

  @override
  void initState() {
    widget.controller.addListener(_scrollListener);
    _isUpdating = false;
    super.initState();
  }

  void _scrollListener() {
    setState(() => _scrollPosition = widget.controller.position.pixels);
  }

  double get _opacity {
    var _val = 0.0;

    if (widget.showScrollbar) {
      _val = 1.0;
    } else {
      if (widget.controller.hasClients && _isUpdating) {
        _val = 1.0;
      }
    }

    return _val;
  }

  @override
  Widget build(BuildContext context) {
    //
    return Stack(
      children: [
        widget.child,
        AnimatedOpacity(
          duration: _kDuration,
          opacity: _opacity,
          child: Container(
            alignment: Alignment.centerRight, // TRY REMOVING
            color: widget.backgroundColor,
            height: _screenSize.height,
            margin: EdgeInsets.only(
              left:
                  _screenSize.width - widget.scrollBarWidth + 2, //PLAY WITH +2
            ),
            width: widget.scrollBarWidth + 2,
            child: Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                child: Container(
                  height: _scrollerHeight,
                  width: widget.scrollBarWidth,
                  margin: EdgeInsets.fromLTRB(1.0, _distanceFromTop, 1.0, 0),
                  decoration: BoxDecoration(
                    color: widget.color,
                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
