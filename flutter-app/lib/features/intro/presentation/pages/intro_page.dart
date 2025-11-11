import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  static const String _introSeenKey = 'intro_seen';

  final List<IntroSlide> _slides = [
    IntroSlide(
      title: 'Hoş Geldiniz!',
      description: 'Binlerce ürünü keşfedin ve en iyi fiyatlarla alışveriş yapın',
      image: Icons.shopping_bag,
      color: const Color(0xFF6750A4),
    ),
    IntroSlide(
      title: 'Hızlı Teslimat',
      description: 'Siparişleriniz hızlı ve güvenli bir şekilde kapınıza gelsin',
      image: Icons.local_shipping,
      color: const Color(0xFF9575CD),
    ),
    IntroSlide(
      title: 'Güvenli Ödeme',
      description: 'Tüm ödemeleriniz SSL ile korunur, güvenle alışveriş yapın',
      image: Icons.security,
      color: const Color(0xFF7D5260),
    ),
    IntroSlide(
      title: 'Kampanyalar',
      description: 'Özel indirimler ve kampanyalardan haberdar olun',
      image: Icons.local_offer,
      color: const Color(0xFF6750A4),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _markIntroAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_introSeenKey, true);
  }

  Future<void> _navigateToOnboarding() async {
    await _markIntroAsSeen();
    if (mounted) {
      context.go('/onboarding');
    }
  }

  Future<void> _skipIntro() async {
    await _markIntroAsSeen();
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isMobile = screenWidth < 600;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // PageView for slides
            PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _slides.length,
              itemBuilder: (context, index) {
                final slide = _slides[index];
                return _buildSlide(slide, isMobile, screenHeight);
              },
            ),

            // Skip Button - Sağ altta
            Positioned(
              top: 16,
              right: 16,
              child: TextButton(
                onPressed: _skipIntro,
                child: Text(
                  'Atla',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
              ),
            ),

            // Bottom Section - Indicators and Next/Get Started Button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(isMobile ? 24 : 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page Indicators
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _slides.length,
                      effect: WormEffect(
                        dotColor: Theme.of(context).dividerColor.withOpacity(0.5),
                        activeDotColor: Theme.of(context).colorScheme.primary,
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 8,
                        radius: 4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Next/Get Started Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_currentPage < _slides.length - 1) {
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            _navigateToOnboarding();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            vertical: isMobile ? 16 : 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        child: Text(
                          _currentPage < _slides.length - 1 ? 'Devam Et' : 'Başlayalım',
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide(IntroSlide slide, bool isMobile, double screenHeight) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 40,
        vertical: isMobile ? 60 : 80,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          // Image/Icon
          Container(
            width: isMobile ? 200 : 250,
            height: isMobile ? 200 : 250,
            decoration: BoxDecoration(
              color: slide.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              slide.image,
              size: isMobile ? 100 : 120,
              color: slide.color,
            ),
          ),

          const Spacer(flex: 2),

          // Title
          Text(
            slide.title,
            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 28 : 32,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            slide.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: isMobile ? 16 : 18,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

class IntroSlide {
  final String title;
  final String description;
  final IconData image;
  final Color color;

  IntroSlide({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}

