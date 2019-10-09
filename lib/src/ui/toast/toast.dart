import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum Length { LENGTH_SHORT, LENGTH_LONG }
enum Gravity { BOTTOM, CENTER, TOP }

class Toast {
  static void show(
    String msg,
    BuildContext context, {
    Length duration = Length.LENGTH_SHORT,
    Gravity gravity = Gravity.CENTER,
  }) {
    ToastView.dismiss();
    ToastView.createView(msg, context, duration, gravity);
  }
}

class ToastView {
  static final ToastView _singleton = new ToastView._internal();

  factory ToastView() {
    return _singleton;
  }

  ToastView._internal();

  static OverlayState overlayState;
  static OverlayEntry _overlayEntry;
  static bool _isVisible = false;

  static void createView(String msg, BuildContext context, Length duration, Gravity gravity) async {
    overlayState = Overlay.of(context);

    _overlayEntry = new OverlayEntry(
      builder: (BuildContext context) => ToastWidget(
          widget: Container(
            width: MediaQuery.of(context).size.width,
            child: Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.width / 6,
                  width: MediaQuery.of(context).size.width / 3,
                  decoration: BoxDecoration(
                    color: const Color(0xf4222222),
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child: Text(msg, softWrap: true, style: TextStyle(fontSize: 16, color: Colors.white)),
                )),
          ),
          gravity: gravity),
    );
    _isVisible = true;
    overlayState.insert(_overlayEntry);
    await new Future.delayed(Duration(seconds: duration == Length.LENGTH_SHORT ? 1 : 2));
    dismiss();
  }

  static dismiss() async {
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    _overlayEntry?.remove();
  }
}

class ToastWidget extends StatelessWidget {
  ToastWidget({
    Key key,
    @required this.widget,
    @required this.gravity,
  }) : super(key: key);

  final Widget widget;
  final Gravity gravity;

  @override
  Widget build(BuildContext context) {
    return new Positioned(
        top: gravity == Gravity.TOP ? 60 : null,
        bottom: gravity == Gravity.BOTTOM ? 60 : null,
        child: Material(
          color: Colors.transparent,
          child: widget,
        ));
  }
}
