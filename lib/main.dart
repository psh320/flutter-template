
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:profitable_flutter_app/config.dart';
import 'package:profitable_flutter_app/router.dart';
import 'package:profitable_flutter_app/service_locator.dart';
import 'package:profitable_flutter_app/core/services/firebase_service.dart';
import 'package:profitable_flutter_app/core/services/in_app_purchase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  if (useFirebase) {
    await FirebaseService.initialize();
  }

  if (useCrashlytics) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  }

  if (useGoogleAds) {
    MobileAds.instance.initialize();
  }

  if (useInAppPurchases) {
    getIt<InAppPurchaseService>().initialize();
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      title: 'Profitable Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    if (useGoogleAds) {
      _loadBannerAd();
    }
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111', // Sample Ad Unit ID
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    )..load();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profitable Flutter App'),
      ),
      body: widget.child,
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (useGoogleAds && _bannerAd != null && _isLoaded)
            SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings),
                label: 'Settings',
              ),
            ],
            currentIndex: _currentIndex,
            onTap: _onItemTapped,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
