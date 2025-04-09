// import 'dart:ui' as ui;  // Importing the correct package for platformViewRegistry
// import 'package:flutter/material.dart';
// import 'dart:html' as html;

// class TwitchEmbedPage extends StatefulWidget {
//   final double height;
//   final double width;
  
//   const TwitchEmbedPage({ required this.width,required this.height});

//   @override
//   State<TwitchEmbedPage> createState() => _TwitchEmbedPageState();
// }

// class _TwitchEmbedPageState extends State<TwitchEmbedPage> {
//   void initState() {
//     super.initState();

//     // Registering the Twitch Player div with the Flutter HtmlElementView.
//     ui.platformViewRegistry.registerViewFactory(
//       'twitch-player-html',
//       (int viewId) => html.IFrameElement()
//         ..src = 'https://player.twitch.tv/?channel=huudan99&parent=localhost'
//         ..style.border = 'none'
//         ..allowFullscreen = true,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return  SizedBox(
//       width: widget.width,
//       height: widget.height,
//       child: HtmlElementView(
//         viewType: 'twitch-player-html',
//       ),
//     );
//   }
// }