import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({super.key});

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePicker picker = ImagePicker();
  final List<File> images = [];

  /// Pick single image from camera
  Future<void> pickFromCamera() async {
    try {
      final XFile? picked = await picker.pickImage(source: ImageSource.camera);

      if (picked != null) {
        setState(() {
          images.add(File(picked.path));
        });
      }
    } catch (e) {
      // ممكن تعرض SnackBar بدل الطباعة
      debugPrint("Camera pick error: $e");
    }
  }

  /// Pick multiple images from gallery
  Future<void> pickFromGallery() async {
    try {
      final List<XFile> pickedImages = await picker.pickMultiImage(
        // optional:
        imageQuality: 85,
        // maxWidth: 1500,
        // maxHeight: 1500,
      );

      if (pickedImages.isNotEmpty) {
        setState(() {
          images.addAll(pickedImages.map((e) => File(e.path)));
        });
      }
    } catch (e) {
      debugPrint("Gallery pick error: $e");
    }
  }

  void removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  void previewImage(File file) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(12),
        child: InteractiveViewer(child: Image.file(file, fit: BoxFit.contain)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Image Picker (Multi)"),
        centerTitle: true,
        actions: [
          if (images.isNotEmpty)
            IconButton(
              tooltip: "Clear all",
              onPressed: () => setState(images.clear),
              icon: const Icon(Icons.delete_forever),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickFromGallery,
                    icon: const Icon(Icons.photo_library),
                    label: const Text("Gallery (Multi)"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Preview / Grid
            Expanded(
              child: images.isEmpty
                  ? const Center(
                      child: Text(
                        "No Images Selected",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      itemCount: images.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemBuilder: (context, index) {
                        final file = images[index];
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: InkWell(
                                  onTap: () => previewImage(file),
                                  child: Image.file(file, fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: InkWell(
                                onTap: () => removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
