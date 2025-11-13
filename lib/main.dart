import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/theme/app_theme.dart';
import 'package:techmart_admin/features/authentication/presentation/widget/screens/login_page.dart';
import 'package:techmart_admin/features/authentication/service/auth_service.dart';
import 'package:techmart_admin/features/banner/provider/current_state.dart';
import 'package:techmart_admin/features/coupons/service/coupon_service.dart';
import 'package:techmart_admin/features/orders/provider/order_provider.dart';
import 'package:techmart_admin/features/sellers/service/seller_service.dart';
import 'package:techmart_admin/firebase_options.dart';
import 'package:techmart_admin/home_screen.dart';
import 'package:techmart_admin/features/catagories/models/category_model.dart';
import 'package:techmart_admin/features/catagories/providers/catagory_varient_provider.dart';
import 'package:techmart_admin/providers/pick_image.dart';
import 'package:techmart_admin/features/brands/services/brand_service.dart';
import 'package:techmart_admin/features/catagories/service/catagory_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool loggedIn = AuthService.isLoggedIn();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OrderProvider>(create: (_) => OrderProvider()),
        ChangeNotifierProvider<SellerService>(create: (_) => SellerService()),
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
        ChangeNotifierProvider(create: (_) => CouponService()),
        ChangeNotifierProvider(create: (_) => BannerService()),
      ],

      child: MaterialApp(
        theme: appTheme,
        home: loggedIn ? HomePage() : LoginPage(),

        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
