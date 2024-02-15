import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_image_editor/material/app_color.dart';
import 'package:flutter_simple_image_editor/material/app_text_style.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_image_editor_example/image_editor.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Simple Image Editor Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Simple Image Editor Example '),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String imgPath = '';
  Uint8List? imgUint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.dark0,
      appBar: AppBar(
        backgroundColor: AppColor.blue0,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: imgUint != null,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 500,
                  child: Image.memory(
                    imgUint ?? Uint8List(0),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              CupertinoButton(
                onPressed: () async {
                  try {
                    final image = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (image == null && !(await Permission.camera.isGranted)) {
                      await Permission.camera.request();
                    }
                    if (image != null) {
                      final imageBytes = await image.readAsBytes();
                      setState(() {
                        imgUint = imageBytes;
                      });
                    }
                  } catch (e) {
                    log('Select Image Error :: ${e.toString()}');
                  }
                },
                child: Container(
                  height: 50,
                  width: 200,
                  decoration: const BoxDecoration(color: AppColor.blue0),
                  child: Center(
                    child: Text(
                      'Take a photo',
                      style: AppTextStyle.body1.copyWith(
                        color: AppColor.green0,
                      ),
                    ),
                  ),
                ),
              ),
              CupertinoButton(
                  child: Container(
                    width: 200,
                    height: 50,
                    color: AppColor.green0,
                  ),
                  onPressed: () {
                    MaterialPageRoute route = MaterialPageRoute(
                      builder: (context) => ImageEditor(
                        imagebyte: imgUint!,
                        onConfirm: (imgBytes) {
                          setState(() {
                            imgUint = imgBytes;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                    Navigator.push(context, route);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
