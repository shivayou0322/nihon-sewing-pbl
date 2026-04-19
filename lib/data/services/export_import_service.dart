import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../models/suit_item.dart';
import '../repositories/item_repository.dart';
import 'settings_service.dart';

class ExportImportService {
  final ItemRepository _repository = LocalItemRepository();
  final SettingsService _settings = SettingsService();

  Future<void> init() async {
    await _settings.init();
  }

  /// 全データをZIPファイルにエクスポート
  Future<String> exportData() async {
    final items = await _repository.getAllItems();
    final archive = Archive();

    // 伝票データをJSON化
    final Map<String, dynamic> jsonData = {};
    for (final item in items) {
      jsonData[item.ticketNumber] = {
        'image': p.basename(item.imagePath),
        'description': item.description,
        'originalImagePath': item.imagePath,
      };

      // 画像ファイルをアーカイブに追加
      if (!item.imagePath.startsWith('assets/')) {
        final imageFile = File(item.imagePath);
        if (await imageFile.exists()) {
          final imageBytes = await imageFile.readAsBytes();
          archive.addFile(ArchiveFile(
            'images/${p.basename(item.imagePath)}',
            imageBytes.length,
            imageBytes,
          ));
        }
      }
    }

    // 設定データも含める
    final settings = {
      'appPassword': _settings.getAppPassword(),
      'adminCode': _settings.getAdminCode(),
    };

    // JSONファイルをアーカイブに追加
    final itemsJson = utf8.encode(json.encode(jsonData));
    archive.addFile(ArchiveFile('items.json', itemsJson.length, itemsJson));

    final settingsJson = utf8.encode(json.encode(settings));
    archive.addFile(ArchiveFile('settings.json', settingsJson.length, settingsJson));

    // ZIPに圧縮して保存
    final zipData = ZipEncoder().encode(archive);
    if (zipData == null) throw Exception('ZIP作成に失敗しました');

    final outputDir = await getApplicationDocumentsDirectory();
    final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
    final zipPath = '${outputDir.path}/pokayoke_backup_$timestamp.zip';
    final zipFile = File(zipPath);
    await zipFile.writeAsBytes(zipData);

    return zipPath;
  }

  /// ZIPファイルからデータをインポート
  Future<int> importData(String zipPath) async {
    final zipFile = File(zipPath);
    if (!await zipFile.exists()) {
      throw Exception('ファイルが見つかりません');
    }

    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // items.json を探す
    final itemsFile = archive.findFile('items.json');
    if (itemsFile == null) {
      throw Exception('データファイルが含まれていません');
    }

    final jsonString = utf8.decode(itemsFile.content as List<int>);
    final jsonData = json.decode(jsonString) as Map<String, dynamic>;

    // 画像の保存先ディレクトリ
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/images');
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    int importedCount = 0;

    for (final entry in jsonData.entries) {
      final ticketNumber = entry.key;
      final data = entry.value as Map<String, dynamic>;
      final imageName = data['image'] as String;

      // 画像ファイルの復元
      String imagePath = 'assets/images/placeholder.png';
      final imageArchiveFile = archive.findFile('images/$imageName');
      if (imageArchiveFile != null) {
        final savedPath = '${imagesDir.path}/$imageName';
        final file = File(savedPath);
        await file.writeAsBytes(imageArchiveFile.content as List<int>);
        imagePath = savedPath;
      }

      final item = SuitItem(
        ticketNumber: ticketNumber,
        imagePath: imagePath,
        description: data['description'] as String,
      );

      await _repository.addItem(item);
      importedCount++;
    }

    // 設定のインポート
    final settingsFile = archive.findFile('settings.json');
    if (settingsFile != null) {
      final settingsString = utf8.decode(settingsFile.content as List<int>);
      final settingsData = json.decode(settingsString) as Map<String, dynamic>;

      if (settingsData.containsKey('appPassword')) {
        await _settings.setAppPassword(settingsData['appPassword'] as String);
      }
      if (settingsData.containsKey('adminCode')) {
        await _settings.setAdminCode(settingsData['adminCode'] as String);
      }
    }

    return importedCount;
  }
}
