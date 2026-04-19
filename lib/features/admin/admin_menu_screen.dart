import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:nihon_sewing_pbl/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/services/export_import_service.dart';
import '../../data/services/settings_service.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});

  @override
  State<AdminMenuScreen> createState() => _AdminMenuScreenState();
}

class _AdminMenuScreenState extends State<AdminMenuScreen> {
  final ExportImportService _exportImport = ExportImportService();
  final SettingsService _settings = SettingsService();
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _exportImport.init();
  }

  Future<void> _onExport() async {
    if (kIsWeb) {
      _showMessage(AppLocalizations.of(context)!.webNotSupported);
      return;
    }

    setState(() => _isProcessing = true);
    try {
      final zipPath = await _exportImport.exportData();
      if (mounted) {
        await SharePlus.instance.share(
          ShareParams(files: [XFile(zipPath)]),
        );
        _showMessage(AppLocalizations.of(context)!.exportComplete);
      }
    } catch (e) {
      _showMessage('${AppLocalizations.of(context)!.exportFailed}: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _onImport() async {
    final l10n = AppLocalizations.of(context)!;
    if (kIsWeb) {
      _showMessage(l10n.webNotSupported);
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importConfirmTitle),
        content: Text(l10n.importConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.dataImport),
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
          _showMessage(l10n.importComplete(count));
        }
      }
    } catch (e) {
      _showMessage('${l10n.importFailed}: $e');
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  Future<void> _showLanguageDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final currentLocale = _settings.getLocale().languageCode;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.languageSettings),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(
                currentLocale == 'ja' ? Icons.radio_button_checked : Icons.radio_button_off,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(l10n.japanese, style: const TextStyle(fontSize: 20)),
              onTap: () async {
                await _settings.setLocale('ja');
                if (mounted) Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                currentLocale == 'my' ? Icons.radio_button_checked : Icons.radio_button_off,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(l10n.myanmar, style: const TextStyle(fontSize: 20)),
              onTap: () async {
                await _settings.setLocale('my');
                if (mounted) Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 16))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(l10n.adminMenu),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.logout),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/auth');
          },
          tooltip: l10n.logout,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
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
                  label: l10n.itemManagement,
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin-items');
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  icon: Icons.key,
                  label: l10n.passwordChange,
                  onPressed: () {
                    Navigator.pushNamed(context, '/admin-password');
                  },
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  icon: Icons.upload_file,
                  label: l10n.dataExport,
                  onPressed: _isProcessing ? null : _onExport,
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  icon: Icons.download,
                  label: l10n.dataImport,
                  onPressed: _isProcessing ? null : _onImport,
                ),
                const SizedBox(height: 16),
                _buildMenuButton(
                  context,
                  icon: Icons.language,
                  label: l10n.languageSettings,
                  onPressed: _showLanguageDialog,
                ),
                if (_isProcessing) ...[
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 8),
                  Text(l10n.processing, style: const TextStyle(fontSize: 18)),
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
