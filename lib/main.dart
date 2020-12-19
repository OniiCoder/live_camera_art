import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:live_camera_art/pages/home.dart';

List<CameraDescription> cameras = [];

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(cameras: cameras,),
  ));
}

