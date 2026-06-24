import 'dart:io';

import 'package:flutter/material.dart';
import 'package:orbit/providers/story_provider.dart';
import 'package:orbit/providers/user_provider.dart';
import 'package:orbit/services/media_picker.dart';
import 'package:orbit/widgets/background_widget.dart';
import 'package:orbit/widgets/custom_button.dart';
import 'package:provider/provider.dart';

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  final MediaPicker _mediaPicker = MediaPicker();
  String? _selectedImage;
  
  Future<void> _pickImage() async {
    final image = await _mediaPicker.pickStoryImage();
    if(image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }
  
  Future<void> _createStory() async {
    if(_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select an image")));
      return;
    }
    final provider = context.read<StoryProvider>();
    final currentUser = context.read<UserProvider>().user!;
    final success = await provider.createStory(
        imagePath: _selectedImage!,
        userName: currentUser.name,
      userImageUrl: currentUser.imageUrl
    );
    
    if(!mounted) return;
    if(success){
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.error ?? "Failed to upload story")));
    }
  }
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StoryProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Story"),
      ),
      body: AppBackground(
          child: Padding(
              padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ElevatedButton(onPressed: _pickImage, child: Text("Select Image")),

                SizedBox(height: 20,),

                if(_selectedImage != null)
                  Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_selectedImage!), width: double.infinity, fit: BoxFit.cover,),
                      )
                  ),

                SizedBox(height: 20,),

                CustomButton(
                    text: provider.isLoading ? "Uploading..." : "Share Story",
                    onPressed: provider.isLoading ? null : _createStory
                )
            ],
          ),
          )),
    );
  }
}
