import 'dart:ui' as ui; // Import the correct library for Flutter Web
import 'package:flutter/material.dart';
import 'dart:html' as html; // This is needed for embedding HTML elements

class IframeWidget extends StatelessWidget {
  final double width;
  final double height;
  final String url;
  final int index; // Add an index to differentiate each iframe

  IframeWidget({Key? key, required this.url, required this.index,required this.width,required this.height})
      : super(key: key) {
    // Generate a unique viewType based on the index
    final viewType = 'iframe-html-$index';

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewType,
      (int viewId) => html.IFrameElement()
         ..width = '${width.toInt()}'  // Convert to string
        ..height = '${height.toInt()}' // Convert to string
        ..src = url
        ..style.border = 'none',
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use the unique viewType
    return HtmlElementView(viewType: 'iframe-html-$index');
  }
}

