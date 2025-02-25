// Günlük Veriler sayfası
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../controllers/data_controller.dart';
import '../controllers/shared_controller.dart';
import '../widgets/save_button.dart';

// Günlük Veriler sayfasının ana widget'ı
class DailyPage extends StatelessWidget {
  final DataController controller = Get.find<DataController>(); // DataController'ı Getx ile al
  final SharedController sharedController = Get.find<SharedController>(); // SharedController'ı Getx ile al

  DailyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Günlük Sağlık Verileri',
          style: AppTextStyles.body,
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColors.backgroundColor,
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView( // Ekranın kaydırılabilir olması için kullanıldı
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Uyku süresi kartı
              _buildCard(
                context,
                icon: FontAwesomeIcons.bed, // İkon
                iconSize: 30.0, // İkon boyutu
                title: ' Uyku Süresi (Saat)', // Kart başlığı
                description: () => 'Normalde: 7-9 saat', // Kart açıklaması
                reactiveValue: () => '${controller.userData.value.sleepHours.toStringAsFixed(1)} saat', // Dinamik veri
                sliderValue: controller.userData.value.sleepHours.obs, // Slider değeri
                min: 0.0, // Slider minimum değeri
                max: 24.0, // Slider maksimum değeri
                divisions: 24, // Slider adımları
                onChanged: (value) { // Değer değiştirildiğinde çalışacak fonksiyon
                  controller.userData.update((val) {
                    val?.sleepHours = value;
                  });
                },
              ),
              const SizedBox(height: 20), // Boşluk

              // Sigara kullanımı kartını oluştur
              _buildCard(
                context,
                icon: FontAwesomeIcons.smoking, // İkon
                iconSize: 30.0, // İkon boyutu
                title: ' Sigara Kullanımı (Adet)', // Kart başlığı
                description: () => _getCigaretteRiskLevel(controller.userData.value.cigarettes), // Risk seviyesi açıklaması
                reactiveValue: () => '${controller.userData.value.cigarettes} adet', // Dinamik veri
                sliderValue: controller.userData.value.cigarettes.toDouble().obs, // Slider değeri
                min: 0.0, // Slider minimum değeri
                max: 50.0, // Slider maksimum değeri
                divisions: 100, // Slider adımları
                onChanged: (value) { // Değer değiştirildiğinde çalışacak fonksiyon
                  controller.userData.update((val) {
                    val?.cigarettes = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 20), // Boşluk

              // Alkol tüketimi kartını oluştur
              _buildCard(
                context,
                icon: FontAwesomeIcons.wineGlass, // İkon
                iconSize: 30.0, // İkon boyutu
                title: 'Alkol Tüketimi (Birim)', // Kart başlığı
                description: () => 'Önerilen: Kadınlar için günde 1, erkekler için günde 2 içki sınırı', // Açıklama
                reactiveValue: () => '${controller.userData.value.alcoholUnits} birim', // Dinamik veri
                sliderValue: controller.userData.value.alcoholUnits.toDouble().obs, // Slider değeri
                min: 0.0, // Slider minimum değeri
                max: 100.0, // Slider maksimum değeri
                divisions: 100, // Slider adımları
                onChanged: (value) { // Değer değiştirildiğinde çalışacak fonksiyon
                  controller.userData.update((val) {
                    val?.alcoholUnits = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 20), // Boşluk

              // Su tüketimi kartını oluştur
              _buildCard(
                context,
                icon: FontAwesomeIcons.glassWater, // İkon
                iconSize: 30.0, // İkon boyutu
                title: 'Su Tüketimi (Bardak)', // Kart başlığı
                description: () => 'Erkekler: 13 bardak, Kadınlar: 9 bardak', // Açıklama
                reactiveValue: () => '${controller.userData.value.waterIntake.toStringAsFixed(1)} bardak', // Dinamik veri
                sliderValue: controller.userData.value.waterIntake.obs, // Slider değeri
                min: 0.0, // Slider minimum değeri
                max: 50.0, // Slider maksimum değeri
                divisions: 50, // Slider adımları
                onChanged: (value) { // Değer değiştirildiğinde çalışacak fonksiyon
                  controller.userData.update((val) {
                    val?.waterIntake = value;
                  });
                },
              ),
              const SizedBox(height: 20), // Boşluk

              // Kaydetme butonu
              SaveButton(
                label: 'Günlük', // Buton etiketi
                onPressed: () {
                  sharedController.updateDailyData(
                    sleepHours: controller.userData.value.sleepHours, // Güncel uyku süresi
                    cigaretteUsage: controller.userData.value.cigarettes, // Güncel sigara kullanımı
                    alcoholConsumption: controller.userData.value.alcoholUnits, // Güncel alkol tüketimi
                    waterIntake: controller.userData.value.waterIntake, // Güncel su tüketimi
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Sigara kullanımı için risk seviyesini döndüren fonksiyon
  String _getCigaretteRiskLevel(int cigarettes) {
    if (cigarettes < 6) {
      return 'Düşük Risk';
    } else if (cigarettes < 11) {
      return 'Orta Risk';
    } else if (cigarettes < 21) {
      return 'Yüksek Risk';
    } else {
      return 'Çok Yüksek Risk';
    }
  }

  // Kart widget'ını oluşturan yardımcı fonksiyon
  Widget _buildCard(
      BuildContext context, {
        required IconData icon, // Karttaki ikon
        required double iconSize, // İkonun boyutu
        required String title, // Kart başlığı
        required String Function() description, // Açıklama fonksiyonu
        required String Function() reactiveValue, // Dinamik değer fonksiyonu
        required RxDouble sliderValue, // Slider değeri
        required double min, // Slider minimum değeri
        required double max, // Slider maksimum değeri
        required int divisions, // Slider adımları
        required ValueChanged<double> onChanged, // Değer değiştirildiğinde çalışacak fonksiyon
      }) {
    RxBool isExpanded = false.obs; // Kartın açılıp kapanma durumu

    return GestureDetector(
      onTap: () {
        isExpanded.toggle(); // Kartın açılıp kapanmasını sağlar
      },
      child: Container(
        padding: const EdgeInsets.all(16.0), // İçerik için boşluk
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryColor, AppColors.accentColor], // Renk geçişi
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20), // Yuvarlatılmış köşeler
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.4), // Gölge rengi
              spreadRadius: 3, // Gölgenin yayılma oranı
              blurRadius: 8, // Gölgenin bulanıklık oranı
              offset: const Offset(0, 4), // Gölgenin konumu
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Sol hizalama
          children: [
            Row(
              children: [
                Icon(icon, size: iconSize, color: Colors.white), // İkon
                const SizedBox(width: 10), // Boşluk
                Expanded(
                  child: Text(
                    title, // Kart başlığı
                    style: AppTextStyles.heading.copyWith(fontSize: 18, color: Colors.white),
                  ),
                ),
                Obx(() => Icon(
                  isExpanded.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, // Açılıp kapanma ikonu
                  color: Colors.white70,
                )),
              ],
            ),
            Obx(() {
              if (!isExpanded.value) return const SizedBox.shrink(); // Kart kapalıysa boşluk göster
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Sol hizalama
                children: [
                  const SizedBox(height: 10), // Boşluk
                  Text(description(), style: const TextStyle(color: Colors.white70)), // Açıklama metni
                  const SizedBox(height: 10), // Boşluk
                  Obx(() => SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white, // Aktif iz rengi
                      inactiveTrackColor: Colors.white.withOpacity(0.5), // Pasif iz rengi
                      trackHeight: 6.0, // İz yüksekliği
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12.0), // Thumb şekli
                      overlayColor: AppColors.accentColor.withOpacity(0.2), // Overlay rengi
                      thumbColor: Colors.white, // Thumb rengi
                      valueIndicatorShape: const PaddleSliderValueIndicatorShape(), // Değer göstergesi şekli
                      valueIndicatorTextStyle: const TextStyle(color: Colors.black), // Gösterge metin rengi
                      valueIndicatorColor: Colors.white, // Gösterge rengi
                    ),
                    child: Slider(
                      value: sliderValue.value, // Slider değeri
                      min: min, // Minimum değer
                      max: max, // Maksimum değer
                      divisions: divisions, // Adım sayısı
                      label: reactiveValue(), // Etiket
                      onChanged: (newValue) { // Değer değiştiğinde çalışacak fonksiyon
                        sliderValue.value = newValue;
                        onChanged(newValue);
                      },
                    ),
                  )),
                  Obx(() => Text(
                    reactiveValue(), // Dinamik değer
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  )),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
