import 'package:firebase_core/firebase_core.dart';
import '../../controller/bottom_nav_controller.dart';

import 'controller/calculate_page_controller.dart';
import 'controller/gold_shop_controller.dart';
import 'ui/page/main_page.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GoldShopController(0)),
        ChangeNotifierProvider(create: (_) => BottomNavController(0)),
        ChangeNotifierProvider(create: (_) => CalulatePageController()),
      ],
      child: const MaterialAppWidget(),
    );
  }
}

class MaterialAppWidget extends StatelessWidget {
  const MaterialAppWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
