import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_image_editor/flutter_simple_image_editor.dart';
import 'package:flutter_simple_image_editor/material/app_color.dart';

class ImageEditor extends StatefulWidget {
  final Uint8List imagebyte;
  final void Function(Uint8List imgBytes) onConfirm;
  const ImageEditor(
      {super.key, required this.imagebyte, required this.onConfirm});

  @override
  State<ImageEditor> createState() => _ImageEditorState();
}

class _ImageEditorState extends State<ImageEditor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.dark0,
      body: FlutterSimpleImageEditor(
        imageBytes: widget.imagebyte,
        onConfirm: widget.onConfirm,
        onError: () {},
        cropActive: (value) {
          log('crop mode active is : $value');
        },
      ),
    );
  }
}
