import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/services/export_import_service.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});

  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  final ExportImportService _exportImport = ExportImportService();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _exportImport.init();
  }

  Future<void> _onExport() async {
    if (kIsWeb) {
      _showMessage('Web版ではエクスポートはサポートされていません');
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final zipPath = await _exportImport.exportData();
      if (mounted) {
        // 共有ダイアログを表示（AirDrop、メール、ファイル保存等）
        await SharePlus.instance.share(
          ShareParams(files: [XFile(zipPath)]),
        );
        _showMessage('エクスポートが完了しました');
      }
    } catch (e) {
      _showMessage('エクスポートに失敗しました: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _onImport() async {
    if (kIsWeb) {
      _showMessage('Web版ではインポートはサポートされていません');
      return;
    }

    // 確認ダイアログ
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('インポート確認'),
        content: const Text(
          'インポートすると、同じ伝票番号のデータは上書きされます。\n続けますか？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('インポート'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isProcessing = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result != null && result.files.single.path != null) {
        final count = await _exportImport.importData(result.files.single.path!);
        if (mounted) {
          _showMessage('$count件のデータをインポートしました');
        }
      }
    } catch (e) {
      _showMessage('インポートに失敗しました: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 16))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('管理メニュー'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/auth');
          },
          tooltip: 'ログアウト',
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.admin_panel_settings,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 32),
                _buildMenuButton(
                  context,
                  icon: Icons.list_alt,
                  label: '伝票データ管理',
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin-items');
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  icon: Icons.key,
                  label: 'パスワード変更',
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin-password');
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  icon: Icons.upload_file,
                  label: 'データエクスポート',
                  onPressed: _isProcessing ? null : _onExport,
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  icon: Icons.download,
                  label: 'データインポート',
                  onPressed: _isProcessing ? null : _onImport,
                ),
                if (_isProcessing) ...[
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  const Text('処理中...', style: TextStyle(fontSize: 18)),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(icon, size: 28),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 24),
            textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
