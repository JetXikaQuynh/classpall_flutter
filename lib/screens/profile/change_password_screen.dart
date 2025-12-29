import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _oldPwController = TextEditingController();
  final _newPwController = TextEditingController();
  final _confirmPwController = TextEditingController();

  bool _loading = false;
  String? _error;
  String? _success;

  Future<void> _submit() async {
    final oldPw = _oldPwController.text;
    final newPw = _newPwController.text;
    final confirmPw = _confirmPwController.text;

    setState(() {
      _error = null;
      _success = null;
    });

    if (newPw.length < 6) {
      setState(() => _error = 'Mật khẩu mới tối thiểu 6 ký tự');
      return;
    }

    if (newPw != confirmPw) {
      setState(() => _error = 'Mật khẩu xác nhận không khớp');
      return;
    }

    setState(() => _loading = true);

    try {
      await AuthService.changePassword(oldPassword: oldPw, newPassword: newPw);

      setState(() => _success = 'Đổi mật khẩu thành công');
      _oldPwController.clear();
      _newPwController.clear();
      _confirmPwController.clear();
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đổi mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _oldPwController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu cũ',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _newPwController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mật khẩu mới',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _confirmPwController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Xác nhận mật khẩu mới',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0044B9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Cập nhật mật khẩu',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),

            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],

            if (_success != null) ...[
              const SizedBox(height: 12),
              Text(_success!, style: const TextStyle(color: Colors.green)),
            ],
          ],
        ),
      ),
    );
  }
}
