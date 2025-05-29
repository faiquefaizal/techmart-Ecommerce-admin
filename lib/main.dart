import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/firebase_options.dart';
import 'package:techmart_admin/home_screen.dart';
import 'package:techmart_admin/models/category_model.dart';
import 'package:techmart_admin/providers/pick_image.dart';
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
        Provider<CategoryService>(create: (_) => CategoryService()),
        Provider<ImageProviderModel>(create: (_) => ImageProviderModel()),
      ],

      child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
