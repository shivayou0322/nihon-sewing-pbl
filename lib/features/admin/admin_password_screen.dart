import 'package:flutter/material.dart';
import '../../data/services/settings_service.dart';

class AdminPasswordScreen extends StatefulWidget {
  const AdminPasswordScreen({super.key});

  @override
  State<AdminPasswordScreen> createState() => _AdminPasswordScreenState();
}

class _AdminPasswordScreenState extends State<AdminPasswordScreen> {
  final SettingsService _settings = SettingsService();
  bool _isLoading = true;

  final _currentAppPwController = TextEditingController();
  final _newAppPwController = TextEditingController();
  final _confirmAppPwController = TextEditingController();

  final _currentAdminCodeController = TextEditingController();
  final _newAdminCodeController = TextEditingController();
  final _confirmAdminCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _settings.init();
    setState(() => _isLoading = false);
  }

  Future<void> _changeAppPassword() async {
    final current = _currentAppPwController.text;
    final newPw = _newAppPwController.text;
    final confirm = _confirmAppPwController.text;

    if (current != _settings.getAppPassword()) {
      _showMessage('現在のパスワードが正しくありません');
      return;
    }
    if (newPw.isEmpty) {
      _showMessage('新しいパスワードを入力してください');
      return;
    }
    if (newPw != confirm) {
      _showMessage('新しいパスワードが一致しません');
      return;
    }

    await _settings.setAppPassword(newPw);
    _currentAppPwController.clear();
    _newAppPwController.clear();
    _confirmAppPwController.clear();
    _showMessage('パスワードを変更しました');
  }

  Future<void> _changeAdminCode() async {
    final current = _currentAdminCodeController.text;
    final newCode = _newAdminCodeController.text;
    final confirm = _confirmAdminCodeController.text;

    if (current != _settings.getAdminCode()) {
      _showMessage('現在の管理者コードが正しくありません');
      return;
    }
    if (newCode.isEmpty) {
      _showMessage('新しい管理者コードを入力してください');
      return;
    }
    if (newCode != confirm) {
      _showMessage('新しい管理者コードが一致しません');
      return;
    }

    await _settings.setAdminCode(newCode);
    _currentAdminCodeController.clear();
    _newAdminCodeController.clear();
    _confirmAdminCodeController.clear();
    _showMessage('管理者コードを変更しました');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 16))),
    );
  }

  @override
  void dispose() {
    _currentAppPwController.dispose();
    _newAppPwController.dispose();
    _confirmAppPwController.dispose();
    _currentAdminCodeController.dispose();
    _newAdminCodeController.dispose();
    _confirmAdminCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('パスワード変更'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 通常パスワード変更
              _buildSection(
                title: '通常パスワード（従業員用）',
                icon: Icons.lock_outline,
                currentController: _currentAppPwController,
                newController: _newAppPwController,
                confirmController: _confirmAppPwController,
                onSave: _changeAppPassword,
                currentLabel: '現在のパスワード',
                newLabel: '新しいパスワード',
                confirmLabel: '新しいパスワード（確認）',
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 32),

              // 管理者コード変更
              _buildSection(
                title: '管理者コード',
                icon: Icons.admin_panel_settings,
                currentController: _currentAdminCodeController,
                newController: _newAdminCodeController,
                confirmController: _confirmAdminCodeController,
                onSave: _changeAdminCode,
                currentLabel: '現在の管理者コード',
                newLabel: '新しい管理者コード',
                confirmLabel: '新しい管理者コード（確認）',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required TextEditingController currentController,
    required TextEditingController newController,
    required TextEditingController confirmController,
    required VoidCallback onSave,
    required String currentLabel,
    required String newLabel,
    required String confirmLabel,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildPasswordField(currentController, currentLabel),
        const SizedBox(height: 12),
        _buildPasswordField(newController, newLabel),
        const SizedBox(height: 12),
        _buildPasswordField(confirmController, confirmLabel),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: onSave,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text('変更を保存'),
        ),
      ],
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(fontSize: 20),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(fontSize: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.all(16),
      ),
    );
  }
}
