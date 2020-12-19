import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:camera/camera.dart';
import 'package:photo_view/photo_view.dart';
import 'package:image_picker/image_picker.dart';

class Home extends StatefulWidget {
  List<CameraDescription> cameras;

  Home({this.cameras});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<CameraDescription> cameras;
  CameraController controller;
  double opacity = 50;
  PhotoViewController photoViewController;

  final picker = ImagePicker();
  String _image_path = "assets/art1.jpg";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    photoViewController = PhotoViewController();

    cameras = widget.cameras;

    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });

  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    print(pickedFile.path);

    setState(() {
      _image_path = pickedFile.path;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    photoViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      backgroundColor: Colors.black,
//      appBar: AppBar(
//        title: Text('Live camera sketch App'),
//      ),
      body: (!controller.value.isInitialized) ? Container() : Column(
        children: [

          Expanded(
            flex: 10,
            child: Stack(
              children: [
                Transform.scale(
                  scale: controller.value.aspectRatio / deviceRatio,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio:
                      controller.value.aspectRatio,
                      child: CameraPreview(controller),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 80),
                  child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                      ),
                      child: Opacity(
                        opacity: opacity / 100,
                        child: PhotoView(
                          controller: photoViewController,
                          enableRotation: true,
                          imageProvider: AssetImage(_image_path),
                          backgroundDecoration: BoxDecoration(
                            color: null,
                          ),
                        ),
                      )
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 500,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              color: Colors.black,
              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FlatButton.icon(
                          onPressed: () {
                            photoViewController.scale = photoViewController.initial.scale;
                            photoViewController.rotation = photoViewController.initial.rotation;
                          },
                          label: Text(
                            'RESET',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          icon: Icon(
                            Icons.settings_backup_restore,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        FlatButton.icon(
                          onPressed: getImage,
                          label: Text(
                            'NEW IMAGE',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          icon: Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
//                  SizedBox(height: 5,),
                  Slider.adaptive(
                    value: opacity,
                    onChanged: (newOpacity) {
                      setState(() {
                        opacity = newOpacity;
                      });
                    },
//              label: 'Adjust Opacity',
//              label: '$opacity',
                    activeColor: Colors.orange,
                    inactiveColor: Colors.orange[100],
                    min: 1,
                    max: 100,
                    divisions: 100,

                  ),
                  SizedBox(height: 5,),
                  Text(
                    'Opacity: ${(opacity / 100).toStringAsFixed(1)}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
