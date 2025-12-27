import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:quiz_app/core/services/service_locator.dart';
import 'package:quiz_app/features/profile/data/character_repository.dart';
import 'package:quiz_app/features/profile/data/models/character_model.dart';
import 'package:quiz_app/features/quiz/presentation/widgets/quiz_text_field.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _repository = locator<CharacterRepository>();

  bool _isLoading = false;
  File? _selectedImageFile;
  String? _currentImageUrl;

  @override
  void initState() {
    super.initState();
    final current = _repository.character;
    if (current != null) {
      _nameController.text = current.name;
      _descController.text = current.description;
      _currentImageUrl = current.imagePath;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage() async {
    if (_selectedImageFile == null) return _currentImageUrl ?? '';

    try {
      final userId =
          DateTime.now().millisecondsSinceEpoch.toString(); // Fallback ID
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('character_images')
          .child('${userId}.jpg');

      await storageRef.putFile(_selectedImageFile!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      print("Image upload failed: $e");
      return _currentImageUrl ?? '';
    }
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final imageUrl = await _uploadImage();

      final current = _repository.character;

      final newChar = Character(
        id: current?.id ?? '',
        name: _nameController.text.trim(),
        description: _descController.text.trim(),
        imagePath: imageUrl,
        createdAt: current?.createdAt ?? DateTime.now(),
        lastModified: DateTime.now(),
        stats: current?.stats ?? {'Intelligence': 10, 'Strength': 5},
        skills: current?.skills ?? ['Flutter'],
      );

      await _repository.saveCharacter(newChar);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $e")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: _selectedImageFile != null
                    ? FileImage(_selectedImageFile!)
                    : (_currentImageUrl != null && _currentImageUrl!.isNotEmpty
                        ? CachedNetworkImageProvider(_currentImageUrl!)
                            as ImageProvider
                        : null),
                child: (_selectedImageFile == null &&
                        (_currentImageUrl == null || _currentImageUrl!.isEmpty))
                    ? const Icon(Icons.add_a_photo, size: 40)
                    : null,
              ),
            ),
            const SizedBox(height: 24),
            QuizTextField(
              controller: _nameController,
              label: "Character Name",
              icon: Icons.person,
            ),
            const SizedBox(height: 16),
            QuizTextField(
              controller: _descController,
              label: "Description/Bio",
              icon: Icons.description,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _isLoading ? null : _save,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Save Character"),
            ),
          ],
        ),
      ),
    );
  }
}
