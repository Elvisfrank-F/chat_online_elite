import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';


class MostrePage extends StatefulWidget {
  final String url;
  const MostrePage({super.key, required this.url});

  @override
  State<MostrePage> createState() => _MostrePageState();
}

class _MostrePageState extends State<MostrePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body:  Center(
        child: InteractiveViewer(
          maxScale: 1000000000.0,
          minScale: 0.5,
          child: Image(image: CachedNetworkImageProvider(widget.url),
          ),
        ),
      ),
    );
  }
}
