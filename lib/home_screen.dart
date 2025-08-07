import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:techmart_admin/features/banner/presentation/screens/bannerscreen.dart';
import 'package:techmart_admin/features/catagories/presentation/screens/catagory_screen.dart';
import 'package:techmart_admin/features/coupons/presentation/screens/coupons_screen.dart';
import 'package:techmart_admin/features/screens/brand_screen.dart';
import 'package:techmart_admin/features/screens/dashboard_screen.dart';
import 'package:techmart_admin/features/screens/order_screen.dart';

import 'package:techmart_admin/features/screens/users.dart';
import 'package:techmart_admin/features/sellers/presentation/screens/sellers_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
              displayMode: SideMenuDisplayMode.auto,
              showHamburger: true,
              selectedHoverColor: Colors.blue[100],
              selectedColor: Colors.lightBlue,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
            ),
            title: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Admin Menu', style: TextStyle(fontSize: 18)),
            ),
            items: [
              SideMenuItem(
                title: 'Dashboard',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  pageController.jumpToPage(index);
                },

                icon: const Icon(Icons.dashboard),
              ),
              SideMenuItem(
                title: 'Users',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                  pageController.jumpToPage(index);
                },

                icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                title: 'Sellers',
                onTap: (index, _) {
                  sideMenu.changePage(index); // updates selected menu
                  pageController.jumpToPage(index); // navigates to page
                },

                icon: const Icon(Icons.store),
              ),
              SideMenuItem(
                title: 'Catagory',
                onTap: (index, _) {
                  sideMenu.changePage(index); // updates selected menu
                  pageController.jumpToPage(index); // navigates to page
                },

                icon: const Icon(Icons.shopping_bag_rounded),
              ),
              SideMenuItem(
                title: 'Brands',
                onTap: (index, _) {
                  sideMenu.changePage(index); // updates selected menu
                  pageController.jumpToPage(index); // navigates to page
                },

                icon: const Icon(Icons.category),
              ),
              SideMenuItem(
                title: 'Orders',
                onTap: (index, _) {
                  sideMenu.changePage(index); // updates selected menu
                  pageController.jumpToPage(index); // navigates to page
                },

                icon: const Icon(Icons.shopping_cart),
              ),
              SideMenuItem(
                title: 'Coupons',
                onTap: (index, _) {
                  sideMenu.changePage(index); // updates selected menu
                  pageController.jumpToPage(index); // navigates to page
                },

                icon: const Icon(Icons.local_offer_sharp),
              ),
              SideMenuItem(
                title: 'Banner',
                onTap: (index, _) {
                  sideMenu.changePage(index); // updates selected menu
                  pageController.jumpToPage(index); // navigates to page
                },

                icon: const Icon(Icons.local_offer_sharp),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                DashboardPage(),
                UsersPage(),
                SellersPage(),
                CatagoryScreen(),
                BrandScreen(),
                OrdersPage(),
                CouponsScreen(),
                BannerScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
