import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class ShareContentApp extends StatefulWidget {
  const ShareContentApp({Key? key}) : super(key: key);

  @override
  _ShareContentAppState createState() => _ShareContentAppState();
}

class _ShareContentAppState extends State<ShareContentApp> {

  Future<void> urlImage() async {
    try {
      const imageUrl = 'https://www.pixelstalk.net/wp-content/uploads/2016/06/Trees-in-the-fall-pictures-desktop.jpg';
      final uri = Uri.parse(imageUrl);
      final response = await http.get(uri);
      final bytes = response.bodyBytes;

      final temp = await getTemporaryDirectory();
      final path = '${temp.path}/image.png';
      await File(path).writeAsBytes(bytes);
      await Share.shareFiles([path]);
    } on SocketException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Share Content App',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Share Data',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            MaterialButton(
              color: Colors.red,
              minWidth: 270,
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'SHARE',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              onPressed: () async {
                await Share.share('Hey, how are you?');
                await Share.share('Today is a holiday', subject: 'Regarding Holiday');
                await Share.share('Check out this video https://youtu.be/4AoFA19gbLo');

                final file = await FilePicker.platform.pickFiles(type: FileType.video);
                if (file != null) {
                  final filePath = file.files.first.path!;
                  await Share.shareFiles([filePath]);
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
