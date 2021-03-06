import 'dart:async';
import 'dart:ui';
import 'dart:ui' as ui show TextStyle;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Util {
  void fullScreen() {
    SystemChrome.setEnabledSystemUIOverlays([]);
  }

  Future<Size> initialDimensions() async {
    // https://github.com/flutter/flutter/issues/5259
    // "In release mode we start off at 0x0 but we don't in debug mode"
    return await new Future<Size>(() {
      if (window.physicalSize.isEmpty) {
        var completer = new Completer<Size>();
        window.onMetricsChanged = () {
          if (!window.physicalSize.isEmpty) {
            completer.complete(window.physicalSize / window.devicePixelRatio);
          }
        };
        return completer.future;
      }
      return window.physicalSize / window.devicePixelRatio;
    });
  }

  Paragraph text(String text,
      {double fontSize = 24.0,
        Color color = Colors.white,
        fontFamily: 'Arial',
        double maxWidth = 180.0}) {
    ParagraphBuilder paragraph = new ParagraphBuilder(new ParagraphStyle());
    paragraph.pushStyle(new ui.TextStyle(
        color: color, fontSize: fontSize, fontFamily: fontFamily));
    paragraph.addText(text);
    return paragraph.build()
      ..layout(new ParagraphConstraints(width: maxWidth));
  }

  void addGestureRecognizer(GestureRecognizer recognizer) {
    GestureBinding.instance.pointerRouter.addGlobalRoute((PointerEvent e) {
      if (e is PointerDownEvent) {
        recognizer.addPointer(e);
      }
    });
  }

}
