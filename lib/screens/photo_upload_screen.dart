import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/photo_upload_status_screen.dart';

class PhotoUploadScreen extends StatefulWidget {
  const PhotoUploadScreen({super.key});

  @override
  State<StatefulWidget> createState() => _PhotoUploadScreenState();
}

class _PhotoUploadScreenState extends State<PhotoUploadScreen> {
  Uint8List? _imageBytes;
  String? _imageName;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    setState(() {
      if (result != null) {
        _imageBytes = result.files.single.bytes;
        _imageName = result.files.single.name;
      } else {
        if (kDebugMode) {
          print('사진을 선택해주세요.');
        }
      }
    });
  }

  Future<bool> _uploadImage() async {
    if (_imageBytes == null) return false;

    final url = Uri.parse('YOUR_API_ENDPOINT_HERE');
    var request = http.MultipartRequest('POST', url);
    request.files.add(http.MultipartFile.fromBytes('file', _imageBytes!,
        filename: _imageName));

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF07104E),
        title: const Text('사진 업로드', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              '사진 미리보기',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _imageBytes == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '사진을 선택해주세요.',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF07104E)),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Icon(
                              Icons.arrow_downward,
                              size: 42,
                              color: Color(0xFF07104E),
                            )
                          ],
                        )
                      : Image.memory(_imageBytes!),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: const Color(0xFF4754F0),
                backgroundColor: const Color(0xFFE8EAFF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: _pickImage,
              child: const Text('사진 선택'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFF4754F0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('사진 업로드'),
              onPressed: () async {
                if (_imageBytes == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('사진을 선택해주세요.')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PhotoUploadStatusScreen(uploadFunction: _uploadImage),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
