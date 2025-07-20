import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/features/catagories/presentation/widget/header_widget.dart';
import 'package:techmart_admin/features/catagories/presentation/widget/add_dialog_widget.dart';
import 'package:techmart_admin/features/catagories/presentation/widget/confirmation_dialog.dart';
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/features/catagories/presentation/widget/body_widget.dart';

import 'package:techmart_admin/features/catagories/models/category_model.dart';
import 'package:techmart_admin/features/catagories/providers/catagory_varient_provider.dart';
import 'package:techmart_admin/providers/pick_image.dart';
import 'package:techmart_admin/features/catagories/service/catagory_service.dart';

class CatagoryScreen extends StatelessWidget {
  TextEditingController ctagorynameController = TextEditingController();
  CatagoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(13),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              HeaderWidget(ctagorynameController: ctagorynameController),
              const SizedBox(height: 10),
              BodyWidget(ctagorynameController: ctagorynameController),
            ],
          ),
        ),
      ),
    );
  }
}
