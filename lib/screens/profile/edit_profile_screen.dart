import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';
import '../../services/user_service.dart';

import 'package:image_picker/image_picker.dart';
import '../../services/cloudinary_service.dart.dart';
import 'dart:typed_data';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _userService = UserService();
  final StorageService _storageService = StorageService();

  Uint8List? _avatarBytes;
  String? _avatarUrl;
  bool _uploadingAvatar = false;

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  UserModel? _user;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      setState(() => _loading = false);
      return;
    }

    final user = await _userService.getUserById(currentUser.uid);
    if (user != null) {
      phoneController.text = user.phone;
      emailController.text = user.email;
      _avatarUrl = user.avatar;
    }

    setState(() {
      _user = user;
      _loading = false;
    });
  }

  Future<void> _saveProfile() async {
    if (_user == null) return;

    final phone = phoneController.text.trim();
    final email = emailController.text.trim();

    if (phone.isEmpty || email.isEmpty) {
      _showError("Vui lòng nhập đầy đủ thông tin");
      return;
    }

    setState(() => _saving = true);

    try {
      final firebaseUser = FirebaseAuth.instance.currentUser;

      /// Update email FirebaseAuth nếu thay đổi
      if (firebaseUser != null && email != _user!.email) {
        await firebaseUser.verifyBeforeUpdateEmail(email);
      }

      /// Update Firestore
      await _userService.updateUser(_user!.id, {
        'phone': phone,
        'email': email,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cập nhật thông tin thành công")),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showError("Cập nhật thất bại: $e");
    } finally {
      setState(() => _saving = false);
    }
  }

  /// Chọn ảnh đại diện từ gallery
  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked == null) return;

    final bytes = await picked.readAsBytes();

    setState(() {
      _avatarBytes = bytes;
    });

    await _uploadAvatar();
  }

  /// Upload ảnh đại diện lên Cloudinary
  Future<void> _uploadAvatar() async {
    if (_avatarBytes == null) return;

    setState(() => _uploadingAvatar = true);

    try {
      final avatarUrl = await _storageService.uploadAvatarBytes(_avatarBytes!);

      await _userService.updateUser(_user!.id, {'avatar': avatarUrl});

      setState(() {
        _avatarUrl = avatarUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật avatar thành công")),
      );
    } catch (e) {
      _showError("Upload avatar thất bại: $e");
    } finally {
      setState(() => _uploadingAvatar = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Sửa thông tin",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),

      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(color: Colors.blue.shade50.withOpacity(0.4)),

        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Avatar (chưa upload)
            GestureDetector(
              onTap: _uploadingAvatar ? null : _pickAvatar,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _avatarBytes != null
                        ? MemoryImage(_avatarBytes!)
                        : (_avatarUrl != null && _avatarUrl!.isNotEmpty
                                  ? NetworkImage(_avatarUrl!)
                                  : null)
                              as ImageProvider?,
                    child:
                        (_avatarBytes == null &&
                            (_avatarUrl == null || _avatarUrl!.isEmpty))
                        ? const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.white,
                          )
                        : null,
                  ),

                  Positioned(
                    bottom: 0,
                    right: 10,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: const Color(0xff0044B9),
                      child: _uploadingAvatar
                          ? const SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.camera_alt,
                              size: 16,
                              color: Colors.white,
                            ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),
            const Text(
              "Thay đổi ảnh đại diện",
              style: TextStyle(color: Colors.blue, fontSize: 15),
            ),

            const SizedBox(height: 25),

            /// Phone
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Số điện thoại:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 6),

            _buildInput(phoneController, TextInputType.phone),

            const SizedBox(height: 15),

            /// Email
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Mail:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const SizedBox(height: 6),

            _buildInput(emailController, TextInputType.emailAddress),

            const SizedBox(height: 30),

            /// Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1E28E5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _saving
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Lưu thay đổi",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(TextEditingController controller, TextInputType type) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blueAccent),
      ),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: const InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),
    );
  }
}
