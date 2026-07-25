import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../utils/app_colors.dart';
import '_parts/onboarding_slide_data.dart';
import '_parts/page_fade_route.dart';
import 'pilih_peran_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  final List<OnboardingSlideData> _slides = const [
    OnboardingSlideData(
      title: 'Selamatkan Makanan,\nSelamatkan Bumi',
      body: 'MenuSisa membantu mengurangi food waste dengan menyalurkan makanan berkualitas yang masih layak konsumsi.',
      illustration: 'assets/images/slide_1.png',
    ),
    OnboardingSlideData(
      title: 'Harga Hemat,\nKualitas Nikmat',
      body: 'Dapatkan berbagai makanan lezat dengan harga miring. Hemat di kantong, tetap kenyang di perut.',
      illustration: 'assets/images/slide_2.png',
    ),
    OnboardingSlideData(
      title: 'Praktis dan Cepat',
      body: 'Temukan makanan favoritmu dengan mudah dan ambil pesanan dengan cepat.',
      illustration: 'assets/images/slide_3.png',
    ),
    OnboardingSlideData(
      title: 'Dukung Komunitas\nLokal',
      body: 'Setiap pembelianmu membantu pelaku usaha lokal dan menciptakan dampak positif bagi lingkungan sekitar.',
      illustration: 'assets/images/slide_4.png',
    ),
    OnboardingSlideData(
      title: 'Bersama MenuSisa,\nWujudkan Perubahan',
      body: 'Mulai dari hal kecil, kita bisa membawa perubahan besar untuk masa depan yang lebih baik.',
      illustration: 'assets/svg/logonotext.svg',
      showSkip: false,
      finalSlide: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 900;
              final maxContentWidth = isDesktop ? 600.0 : double.infinity;

              return Container(
                constraints: BoxConstraints(maxWidth: maxContentWidth),
                child: Column(
                  children: [
                    // Header Bar (Skip/Lewati)
                    Container(
                      height: 56,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: (_slides[_currentIndex].showSkip)
                          ? TextButton(
                              onPressed: _goToPilihPeran,
                              child: const Text('Lewati', style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.bold, fontFamily: 'Quicksand')),
                            )
                          : const SizedBox(),
                    ),

                    // Slider Content
                    Expanded(
                      child: PageView.builder(
                        controller: _controller,
                        itemCount: _slides.length,
                        onPageChanged: (idx) => setState(() => _currentIndex = idx),
                        itemBuilder: (context, idx) {
                          final slide = _slides[idx];
                          return SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 20),
                                  // Illustration Placeholder/Art
                                  SizedBox(
                                    height: isDesktop ? 300 : 220,
                                    child: Center(
                                      child: slide.finalSlide
                                          ? SvgPicture.asset(
                                              slide.illustration,
                                              width: isDesktop ? 230 : 175,
                                              height: isDesktop ? 230 : 175,
                                            )
                                          : Image.asset(
                                              slide.illustration,
                                              fit: BoxFit.contain,
                                            ),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  Text(
                                    slide.title,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, height: 1.25, fontFamily: 'Quicksand'),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    slide.body,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.black54, fontSize: 15, height: 1.5, fontFamily: 'Quicksand'),
                                  ),
                                  const SizedBox(height: 40),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Footer Bar
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Dots Indicator
                          Row(
                            children: List.generate(_slides.length, (index) {
                              final active = _currentIndex == index;
                              return Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3),
                                width: active ? 16 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: active ? AppColors.primary : Colors.grey.shade300,
                                ),
                              );
                            }),
                          ),

                          // Action Button
                          _slides[_currentIndex].finalSlide
                              ? ElevatedButton(
                                  onPressed: _goToPilihPeran,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  ),
                                  child: const Text('Mulai Sekarang', style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Quicksand')),
                                )
                              : FloatingActionButton(
                                  onPressed: () {
                                    _controller.nextPage(
                                      duration: const Duration(milliseconds: 300),
                                      curve: Curves.easeInOut,
                                    );
                                  },
                                  backgroundColor: AppColors.primary,
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _goToPilihPeran() {
    Navigator.of(context).pushReplacement(
      PageFadeRoute(builder: (_) => const PilihPeranScreen()),
    );
  }
}



