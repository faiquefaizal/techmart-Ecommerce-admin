import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/widgets/add_dialog_widget.dart';
import 'package:techmart_admin/core/widgets/confirmation_dialog.dart';
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/features/catagories/ui/body_widget.dart';
import 'package:techmart_admin/features/catagories/ui/header_widget.dart';
import 'package:techmart_admin/features/catagories/ui/widgets';
import 'package:techmart_admin/models/category_model.dart';
import 'package:techmart_admin/providers/catagory_varient_provider.dart';
import 'package:techmart_admin/providers/pick_image.dart';
import 'package:techmart_admin/services/catagory_service.dart';

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
