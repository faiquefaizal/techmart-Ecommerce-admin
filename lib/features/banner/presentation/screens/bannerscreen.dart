import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:techmart_admin/core/funtions/image_funtion.dart';

import 'package:techmart_admin/core/widgets/custem_snackbar.dart';
import 'package:techmart_admin/features/banner/models/banner_model.dart';
import 'package:techmart_admin/features/banner/provider/current_state.dart';
import 'package:techmart_admin/providers/pick_image.dart';

class BannerScreen extends StatelessWidget {
  const BannerScreen({super.key});

  void _showAddBannerDialog(BuildContext context) {
    final imageProvider = context.read<ImageProviderModel>();
    final bannerService = context.read<BannerService>();
    final titleController = TextEditingController();
    imageProvider.clearImageList();

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: 600,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Banner",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: "Title",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Consumer<ImageProviderModel>(
                    builder: (context, provider, _) {
                      return Column(
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              final images = await pickMultiImages(context);
                              if (images.isNotEmpty) {
                                provider.setImageList(images);
                              }
                            },
                            icon: const Icon(Icons.image),
                            label: const Text("Pick Images"),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children:
                                provider.pickedImageList.map((img) {
                                  final index = provider.pickedImageList
                                      .indexOf(img);
                                  return Stack(
                                    children: [
                                      Image.memory(
                                        img,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap:
                                              () =>
                                                  provider.removeImageAt(index),
                                          child: const CircleAvatar(
                                            radius: 12,
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.close,
                                              size: 14,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () async {
                          final title = titleController.text.trim();
                          final images = imageProvider.pickedImageList;

                          if (title.isEmpty || images.isEmpty) {
                            custemSnakbar(
                              context,
                              "Enter title and pick at least 1 image",
                              Colors.red,
                            );
                            return;
                          }

                          try {
                            await bannerService.addBanner(title, images);
                            Navigator.pop(context);
                            custemSnakbar(
                              context,
                              "Banner added!",
                              Colors.green,
                            );
                          } catch (e) {
                            Navigator.pop(context);
                            custemSnakbar(
                              context,
                              "Error: ${e.toString()}",
                              Colors.red,
                            );
                          }
                        },
                        child: const Text("Add Banner"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteBanner(BuildContext context, BannerModel banner) {
    final bannerService = context.read<BannerService>();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Delete Banner?"),
            content: const Text("Are you sure you want to delete this banner?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await bannerService.deleteBanner(banner);
                  if (context.mounted) {
                    Navigator.pop(context);
                    custemSnakbar(
                      context,
                      "Deleted successfully",
                      Colors.green,
                    );
                  }
                },
                child: const Text("Delete"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bannerService = context.read<BannerService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Banner Management"),
        actions: [
          TextButton.icon(
            onPressed: () => _showAddBannerDialog(context),
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Add Banner",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: StreamBuilder<List<BannerModel>>(
          stream: bannerService.fetchBanners(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final banners = snapshot.data;
            if (banners == null || banners.isEmpty) {
              log(snapshot.toString());
              log("insise buider ${banners.toString()}");
              return const Center(child: Text("No banners yet."));
            }
            log(banners.toString());
            return GridView.builder(
              itemCount: banners.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3,
              ),
              itemBuilder: (context, index) {
                final banner = banners[index];
                return Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (banner.images != null && banner.images!.isNotEmpty)
                          ...banner.images!.map(
                            (url) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Image.network(
                                url,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                banner.title ?? "Untitled",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed:
                                      () => _deleteBanner(context, banner),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
