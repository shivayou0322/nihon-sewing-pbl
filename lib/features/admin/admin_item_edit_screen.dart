import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Web版では画像選択はサポートされていません')),
      );
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      // アプリ内にコピー
      final appDir = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${appDir.path}/images');
      if (!await imagesDir.exists()) {
        await imagesDir.create(recursive: true);
      }
      final fileName = '${DateTime.now().millisecondsSinceEpoch}${p.extension(picked.path)}';
      final savedPath = '${imagesDir.path}/$fileName';
      await File(picked.path).copy(savedPath);

      setState(() {
        _imagePath = savedPath;
      });
    }
  }

  Future<void> _save() async {
    final ticketNumber = _ticketController.text.trim();
    final description = _descriptionController.text.trim();

    if (ticketNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('伝票番号を入力してください')),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('説明文を入力してください')),
      );
      return;
    }

    // 新規追加時の重複チェック
    if (!_isEditing || ticketNumber != _originalTicketNumber) {
      final existing = await _repository.findByTicketNumber(ticketNumber);
      if (existing != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('伝票番号「$ticketNumber」は既に登録されています')),
          );
        }
        return;
      }
    }

    // 編集時に伝票番号が変わった場合、旧データを削除
    if (_isEditing && _originalTicketNumber != null && ticketNumber != _originalTicketNumber) {
      await _repository.deleteItem(_originalTicketNumber!);
    }

    final item = SuitItem(
      ticketNumber: ticketNumber,
      imagePath: _imagePath ?? 'assets/images/placeholder.png',
      description: description,
    );

    if (_isEditing) {
      await _repository.updateItem(item);
    } else {
      await _repository.addItem(item);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_isEditing ? '更新しました' : '追加しました')),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _ticketController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'データ編集' : '新規追加'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 伝票番号
              Text(
                '伝票番号',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _ticketController,
                style: const TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '例: 01',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
              const SizedBox(height: 24),

              // 説明文
              Text(
                '説明文',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                style: const TextStyle(fontSize: 20),
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '例: 左ポケットあり、ボタンなし',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.all(20),
                ),
              ),
              const SizedBox(height: 24),

              // 画像
              Text(
                '画像',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: _buildImagePreview(),
                ),
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library, size: 24),
                label: const Text(
                  'ギャラリーから選択',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 32),

              // 保存ボタン
              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save, size: 24),
                label: Text(_isEditing ? '更新' : '保存'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    if (_imagePath == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 8),
            Text(
              'タップして画像を選択',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      );
    }

    if (_imagePath!.startsWith('assets/')) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          _imagePath!,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => _placeholderWithPath(),
        ),
      );
    }

    if (!kIsWeb && File(_imagePath!).existsSync()) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.file(
          File(_imagePath!),
          fit: BoxFit.contain,
        ),
      );
    }

    return _placeholderWithPath();
  }

  Widget _placeholderWithPath() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 8),
          Text(
            _imagePath ?? '',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
