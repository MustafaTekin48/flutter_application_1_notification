import 'package:flutter/material.dart';

import 'edit_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> diaryEntries; // Günlük girişlerini buradan alacağız

  HomeScreen({required this.diaryEntries});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Duyguya göre arka plan rengini döndüren fonksiyon
  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'mutlu':
        return Color(0xFFFFF3B0);
      case 'heyecanlı':
        return Color(0xFFFFD1A4);
      case 'normal':
        return Color(0xFFB2E0A8);
      case 'üzgün':
        return Color(0xFFAEC6FF);
      case 'kızgın':
        return Color(0xFFFFB3B3);
      case 'korkulu':
        return Color(0xFFD1B3FF);
      default:
        return Colors.black;
    }
  }

  // Rating'e göre opacity hesaplayan fonksiyon
  double _getOpacityFromRating(int rating) {
    return (rating / 10).clamp(0.2, 1.0); // 2'den 10'a kadar 0.2 - 1 arası opacity
  }

  // Girişi düzenle ve güncelle
  void _editEntry(int index) async {
    final updatedEntry = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditEntryPage(entry: widget.diaryEntries[index]),
      ),
    );

    if (updatedEntry != null) {
      setState(() {
        widget.diaryEntries[index] = updatedEntry; // Girişi güncelle
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.diaryEntries.isEmpty // Günlük listesi boş mu?
          ? Center(
        child: Text(
          'Henüz günlük eklemediniz.',
          style: TextStyle(fontSize: 18, color: Colors.grey), // Boş günlük mesajı
        ),
      )
          : ListView.builder(
        itemCount: widget.diaryEntries.length,
        itemBuilder: (context, index) {
          final entry = widget.diaryEntries[index];
          final emotion = entry['emotion'];
          final reason = entry['reason'];
          final rating = entry['rating'];
          final opacity = _getOpacityFromRating(rating); // Opacity değeri rating'e göre hesaplanıyor
          final date = DateTime.now(); // Burada gerçek tarih kullanılabilir

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: _getEmotionColor(emotion).withOpacity(opacity), // Duyguya göre renk ve opacity
            child: ListTile(
              title: Text(
                '${date.hour}:${date.minute} - ${entry['emotion']} ${entry['rating']}/10',
                style: TextStyle(color: Colors.black),
              ),
              subtitle: Text(
                entry['reason'],
                style: TextStyle(color: Colors.black),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit, color: Colors.black),
                onPressed: () => _editEntry(index), // Düzenleme fonksiyonu
              ),
            ),
          );
        },
      ),
    );
  }
}
