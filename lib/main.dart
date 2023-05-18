import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:media_kit/media_kit.dart';

/// Provides [Player], [Media], [Playlist] etc.
import 'package:media_kit_video/media_kit_video.dart';
import 'package:http/http.dart' as http;
import 'package:rtsp_stream_test/authorization.dart';
import 'package:rtsp_stream_test/authorization_response.dart';
import 'dart:convert';

import 'package:rtsp_stream_test/camera.dart';

import 'my_http_overrides.dart';
import 'auth/secrets.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(
    const MaterialApp(home: MyScreen()),
  );
}

class MyScreen extends StatefulWidget {
  const MyScreen({Key? key}) : super(key: key);

  @override
  State<MyScreen> createState() => MyScreenState();
}

class MyScreenState extends State<MyScreen> {
  /// Create a [Player].
  final Player player = Player();
  String token = "";

  /// Store reference to the [VideoController].
  VideoController? controller;

  @override
  initState() {
    _setAuthorizationTokenForControl();
    super.initState();
    Future.microtask(() async {
      /// Create a [VideoController] to show video output of the [Player].
      controller = await VideoController.create(player);

      /// Play any media source.
      await player
          .open(Media('rtsp://$cameraUser:$cameraPassword@$cameraIp:554/stream1'));
      setState(() {});
    });
  }

  @override
  void dispose() {
    Future.microtask(() async {
      /// Release allocated resources back to the system.
      await controller?.dispose();
      await player.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// Use [Video] widget to display the output.
    return Stack(children: [
      Video(
        /// Pass the [controller].
        controller: controller,
      ),
      SizedBox(
        width: 140,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: moveCameraUp,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.withOpacity(0.05)),
              child: const Icon(CupertinoIcons.arrow_up),
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: moveCameraLeft,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.withOpacity(0.05)),
                  child: const Icon(CupertinoIcons.arrow_left),
                ),
                ElevatedButton(
                  onPressed: moveCameraRight,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow.withOpacity(0.05)),
                  child: const Icon(CupertinoIcons.arrow_right),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: moveCameraDown,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow.withOpacity(0.05)),
              child: const Icon(CupertinoIcons.arrow_down),
            ),
          ],
        ),
      )
    ]);
  }

  _setAuthorizationTokenForControl() async {
    token = (await getToken())!;
    setState(() {});
  }

  Future<String?> getToken() async {
    debugPrint("Move up");
    Map<String, dynamic> request = Authorization(
            method: "login",
            params: Params(
                hashed: "true",
                password: hashedAdminPassword,
                username: "admin"))
        .toJson();
    var response = await http.post(Uri.parse('https://$cameraIp:443'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(request));
    debugPrint(response.body);
    var authorization =
        AuthorizationResponse.fromJson(jsonDecode(response.body));
    debugPrint("Get Token:${response.body}");
    return authorization.result?.stok;
  }

  moveCameraUp() async {
    debugPrint("Move up");
    Map<String, dynamic> camera =
        Camera(method: "do", motor: Motor(move: Move(xCoord: "0", yCoord: "5")))
            .toJson();
    var response =
        await http.post(Uri.parse('https://$cameraIp:443/stok=$token/ds'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(camera));
  }

  moveCameraLeft() {
    Map<String, dynamic> camera = Camera(
            method: "do", motor: Motor(move: Move(xCoord: "-5", yCoord: "0")))
        .toJson();
    http.post(Uri.parse('https://$cameraIp:443/stok=$token/ds'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(camera));
  }

  moveCameraRight() {
    Map<String, dynamic> camera =
        Camera(method: "do", motor: Motor(move: Move(xCoord: "5", yCoord: "0")))
            .toJson();
    http.post(Uri.parse('https://$cameraIp/stok=$token/ds'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(camera));
  }

  moveCameraDown() {
    Map<String, dynamic> camera = Camera(
            method: "do", motor: Motor(move: Move(xCoord: "0", yCoord: "-5")))
        .toJson();
    http.post(Uri.parse('https://$cameraIp:443/stok=$token/ds'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(camera));
  }
}
