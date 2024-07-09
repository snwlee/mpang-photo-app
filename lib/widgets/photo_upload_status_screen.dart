import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class PhotoUploadStatusScreen extends StatefulWidget {
  final Future<bool> Function() uploadFunction;

  const PhotoUploadStatusScreen({super.key, required this.uploadFunction});

  @override
  _PhotoUploadStatusScreenState createState() =>
      _PhotoUploadStatusScreenState();
}

class _PhotoUploadStatusScreenState extends State<PhotoUploadStatusScreen>
    with SingleTickerProviderStateMixin {
  bool isUploading = true;
  bool uploadSuccess = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    _uploadImage();
  }

  Future<void> _uploadImage() async {
    try {
      bool result = await widget.uploadFunction();
      setState(() {
        isUploading = false;
        uploadSuccess = result;
      });
    } catch (e) {
      setState(() {
        isUploading = false;
        uploadSuccess = false;
      });
    }
    _controller.stop();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isUploading)
              AnimatedBuilder(
                animation: _controller,
                builder: (_, child) {
                  return Transform.rotate(
                    angle: _controller.value * 2 * 3.14,
                    child: child,
                  );
                },
                child: const SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFF4754F0)),
                    strokeWidth: 3,
                  ),
                ),
              )
            else if (uploadSuccess)
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white),
              )
            else
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white),
              ),
            const SizedBox(height: 20),
            Text(
              isUploading
                  ? '사진을 업로드 중입니다...'
                  : (uploadSuccess ? '사진 업로드 완료!' : '사진 업로드 실패'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              isUploading
                  ? '사진 업로드가 완료될 때까지\n잠시만 기다려주세요.'
                  : (uploadSuccess
                      ? '업로드하신 사진이\n슬라이드에 적용 되었어요.'
                      : '사진 업로드에 실패했습니다.\n다시 시도해 주세요.'),
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor:
                    isUploading ? const Color(0xFF4754F0) : Colors.white,
                backgroundColor: isUploading
                    ? const Color(0xFFE8EAFF)
                    : const Color(0xFF4754F0),
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                if (isUploading) {
                  setState(() {
                    isUploading = false;
                    uploadSuccess = false;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('업로드 중단됨')),
                  );
                } else {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route<dynamic> route) => false,
                  );
                }
              },
              child: Text(isUploading ? '업로드 중단' : '확인'),
            ),
          ],
        ),
      ),
    );
  }
}
