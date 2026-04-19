import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:nihon_sewing_pbl/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../../data/models/suit_item.dart';
import '../../data/repositories/item_repository.dart';

class AdminItemEditScreen extends StatefulWidget {
  const AdminItemEditScreen({super.key});

  @override
  State<AdminItemEditScreen> createState() => _AdminItemEditScreenState();
}

class _AdminItemEditScreenState extends State<AdminItemEditScreen> {
  final _ticketController = TextEditingController();
  final _descriptionController = TextEditingController();
  final ItemRepository _repository = LocalItemRepository();
  String? _imagePath;
  bool _isEditing = false;
  String? _originalTicketNumber;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final item = ModalRoute.of(context)?.settings.arguments as SuitItem?;
    if (item != null && !_isEditing) {
      _isEditing = true;
      _originalTicketNumber = item.ticketNumber;
      _ticketController.text = item.ticketNumber;
      _descriptionController.text = item.description;
      _imagePath = item.imagePath;
    }
  }

  Future<void> _pickImage() async {
    final l10n = AppLocalizations.of(context)!;
    if (kIsWeb) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.webNotSupported))); return; }
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/images');
      if (!await imagesDir.exists()) await imagesDir.create(recursive: true);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
      final savedPath = '${imagesDir.path}/$fileName';
      await File(picked.path).copy(savedPath);
      setState(() => _imagePath = savedPath);
    }
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    final ticketNumber = _ticketController.text.trim();
    final description = _descriptionController.text.trim();
    if (ticketNumber.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.enterTicketNumber))); return; }
    if (description.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.enterDescription))); return; }
    if (!_isEditing || ticketNumber != _originalTicketNumber) {
      final existing = await _repository.findByTicketNumber(ticketNumber);
      if (existing != null) { if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.duplicateTicketNumber(ticketNumber)))); return; }
    }
    if (_isEditing && _originalTicketNumber != null && ticketNumber != _originalTicketNumber) await _repository.deleteItem(_originalTicketNumber!);
    final item = SuitItem(ticketNumber: ticketNumber, imagePath: _imagePath ?? 'assets/images/placeholder.png', description: description);
    if (_isEditing) { await _repository.updateItem(item); } else { await _repository.addItem(item); }
    if (mounted) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_isEditing ? l10n.updated : l10n.saved))); Navigator.pop(context); }
  }

  @override
  void dispose() { _ticketController.dispose(); _descriptionController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? l10n.editTitle : l10n.addTitle), centerTitle: true),
      body: SafeArea(child: SingleChildScrollView(padding: const EdgeInsets.all(24), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(l10n.ticketNumberLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 8),
        TextField(controller: _ticketController, style: const TextStyle(fontSize: 24), keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: l10n.ticketNumberHint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.all(20))),
        const SizedBox(height: 24),
        Text(l10n.descriptionLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 8),
        TextField(controller: _descriptionController, style: const TextStyle(fontSize: 20), maxLines: 3,
          decoration: InputDecoration(hintText: l10n.descriptionHint, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.all(20))),
        const SizedBox(height: 24),
        Text(l10n.imageLabel, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
        const SizedBox(height: 8),
        GestureDetector(onTap: _pickImage, child: Container(height: 250,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.outline)),
          child: _buildImagePreview())),
        const SizedBox(height: 8),
        TextButton.icon(onPressed: _pickImage, icon: const Icon(Icons.photo_library, size: 24), label: Text(l10n.selectFromGallery, style: const TextStyle(fontSize: 18))),
        const SizedBox(height: 32),
        ElevatedButton.icon(onPressed: _save, icon: const Icon(Icons.save, size: 24), label: Text(_isEditing ? l10n.update : l10n.save),
          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(vertical: 20), textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
      ]))),
    );
  }

  Widget _buildImagePreview() {
    final l10n = AppLocalizations.of(context)!;
    if (_imagePath == null) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.add_photo_alternate_outlined, size: 64, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
        const SizedBox(height: 8),
        Text(l10n.tapToSelectImage, style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
      ]));
    }
    if (_imagePath!.startsWith('assets/')) {
      return ClipRRect(borderRadius: BorderRadius.circular(16),
        child: Image.asset(_imagePath!, fit: BoxFit.contain, errorBuilder: (c, e, s) => _placeholderWithPath()));
    }
    if (!kIsWeb && File(_imagePath!).existsSync()) {
      return ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.file(File(_imagePath!), fit: BoxFit.contain));
    }
    return _placeholderWithPath();
  }

  Widget _placeholderWithPath() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.image_outlined, size: 64, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
      const SizedBox(height: 8),
      Text(_imagePath ?? '', style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)), textAlign: TextAlign.center),
    ]));
  }
}
