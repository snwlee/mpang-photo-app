import 'package:flutter/material.dart';

import '../screens/home_screen.dart';

class PhotoUploadStatusScreen extends StatefulWidget {
  const PhotoUploadStatusScreen({super.key});

  @override
  _PhotoUploadStatusScreenState createState() =>
      _PhotoUploadStatusScreenState();
}

class _PhotoUploadStatusScreenState extends State<PhotoUploadStatusScreen>
    with SingleTickerProviderStateMixin {
  bool isUploading = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    // Simulate upload completion after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isUploading = false;
      });
      _controller.stop();
    });
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
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4754F0)),
                    strokeWidth: 3,
                  ),
                ),
              )
            else
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white),
              ),
            const SizedBox(height: 20),
            Text(
              isUploading ? '사진을 업로드 중입니다...' : '사진 업로드 완료!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              isUploading
                  ? '사진 업로드가 완료될 때까지\n잠시만 기다려주세요.'
                  : '업로드하신 사진이\n슬라이드에 적용 되었어요.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: isUploading ? const Color(0xFF4754F0) : Colors.white,
                backgroundColor: isUploading ? const Color(0xFFE8EAFF) : const Color(0xFF4754F0),
                minimumSize: const Size(200, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () async {
                if (isUploading) {
                  await Future.delayed(const Duration(seconds: 2));
                  setState(() {
                    isUploading = false;
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
