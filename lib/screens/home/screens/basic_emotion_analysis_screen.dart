import 'package:flutter/material.dart';

class BasicEmotionAnalysisScreen extends StatelessWidget {
  const BasicEmotionAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Görüntülü Temel Duygu Analizi")),
      body: const Center(child: Text("Görüntülü Temel Duygu Analizi Ekranı")),
    );
  }
}
