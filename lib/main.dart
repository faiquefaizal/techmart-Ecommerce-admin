import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/firebase_options.dart';
import 'package:techmart_admin/home_screen.dart';
import 'package:techmart_admin/models/category_model.dart';
import 'package:techmart_admin/providers/catagory_varient_provider.dart';
import 'package:techmart_admin/providers/pick_image.dart';
import 'package:techmart_admin/services/brand_service.dart';
import 'package:techmart_admin/services/catagory_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CategoryService>(
          create: (_) => CategoryService(),
        ),
        ChangeNotifierProvider<ImageProviderModel>(
          create: (_) => ImageProviderModel(),
        ),
        ChangeNotifierProvider<BrandService>(create: (_) => BrandService()),
        ChangeNotifierProvider<CatagoryVarientProvider>(
          create: (_) => CatagoryVarientProvider(),
        ),
      ],

      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
