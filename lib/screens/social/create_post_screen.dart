import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orbit/providers/post_provider.dart';
import 'package:orbit/providers/user_provider.dart';
import 'package:orbit/services/media_picker.dart';
import 'package:orbit/widgets/custom_button.dart';
import 'package:orbit/widgets/custom_textfield.dart';
import 'package:provider/provider.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _captionController = TextEditingController();
  final MediaPicker _mediaPicker = MediaPicker();

  List<String> _selectedImages = [];

  Future<void> _pickImages() async {
    final images = await _mediaPicker.pickMultipleImages();
    if(images.isNotEmpty) {
      setState(() {
        _selectedImages = images;
      });
    }
  }

  Future<void> _createPost() async {
    if(_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please select images")));
      return;
    }
    final provider = context.read<PostProvider>();
    final currentUser = context.read<UserProvider>().user!;
    final success = await provider.createPost(
        caption: _captionController.text.trim(),
        imagePaths: _selectedImages,
        userName: currentUser.name,
        userImageUrl: currentUser.imageUrl
    );
    if(!mounted) return;

    if(success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.error ?? "Failed to create post"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PostProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: _pickImages,
                child: const Text("Select Images")
            ),
            const SizedBox(height: 15,),
            if(_selectedImages.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                    itemCount: _selectedImages.length,
                    itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Image.file(File(
                        _selectedImages[index]
                      ),
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    );
                    }
                    ),
              ),

            const SizedBox(height: 20,),

            CustomTextField(
              controller: _captionController,
                labelText: "Caption",
              maxLines: 4,
              maxLength: 300,
            ),

            const Spacer(),

            CustomButton(
                text: provider.isLoading ? "Uploading..." : "Post",
                onPressed: provider.isLoading ? null : _createPost
            )
          ],
        ),
      ),
    );
  }
  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }
}
