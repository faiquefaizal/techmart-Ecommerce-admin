import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:techmart_admin/features/catagories/presentation/widget/add_dialog_widget.dart';
import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/features/catagories/presentation/widget/varient_dialogs.dart';

import 'package:techmart_admin/features/catagories/providers/catagory_varient_provider.dart';
import 'package:techmart_admin/providers/pick_image.dart';
import 'package:techmart_admin/features/catagories/service/catagory_service.dart';

class HeaderWidget extends StatelessWidget {
  final TextEditingController ctagorynameController;
  const HeaderWidget({super.key, required this.ctagorynameController});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => categorycustemAddDialog(context),
      child: Text("Add Catagory"),
    );
  }

  categorycustemAddDialog(BuildContext context) {
    custemAddDialog(
      varient: true,
      varientOption: () => showAddVariantDialog(context),
      context: context,
      controller: ctagorynameController,
      onpressed: () async {
        final catargoryVarientProvider =
            context.read<CatagoryVarientProvider>();
        final imageProvider = context.read<ImageProviderModel>();
        final image = imageProvider.pickedImage;
        final name = ctagorynameController.text.trim();
        if (name.isEmpty || image == null) {
          return custemSnakbar(context, "Pick a photo ", Colors.red);
        }

        await context.read<CategoryService>().addCatagory(
          name,
          image,
          catargoryVarientProvider.ctagoryVarientList,
        );

        if (Navigator.canPop(context)) {
          ctagorynameController.clear();
          imageProvider.clearImage();
          Navigator.pop(context);
        }
      },
    );
  }
}
