import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:hive/hive.dart';
import '../../core/constants/app_constants.dart';
import '../models/suit_item.dart';

abstract class ItemRepository {
  Future<SuitItem?> findByTicketNumber(String ticketNumber);
  Future<List<SuitItem>> getAllItems();
  Future<void> addItem(SuitItem item);
  Future<void> updateItem(SuitItem item);
  Future<void> deleteItem(String ticketNumber);
}

class LocalItemRepository implements ItemRepository {
  late Box _box;
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _box = await Hive.openBox(AppConstants.itemsBox);

    // 初回起動時にアセットのダミーデータを読み込む
    if (_box.isEmpty) {
      try {
        final jsonString = await rootBundle.loadString('assets/data/items.json');
        final data = json.decode(jsonString) as Map<String, dynamic>;
        for (final entry in data.entries) {
          final item = SuitItem.fromJson(entry.key, entry.value as Map<String, dynamic>);
          await _box.put(item.ticketNumber, json.encode({
            'image': item.imagePath,
            'description': item.description,
          }));
        }
      } catch (e) {
        // アセットがない場合はスキップ
      }
    }
    _initialized = true;
  }

  @override
  Future<SuitItem?> findByTicketNumber(String ticketNumber) async {
    await _ensureInitialized();
    final data = _box.get(ticketNumber);
    if (data == null) return null;
    final map = json.decode(data) as Map<String, dynamic>;
    return SuitItem.fromJson(ticketNumber, map);
  }

  @override
  Future<List<SuitItem>> getAllItems() async {
    await _ensureInitialized();
    final items = <SuitItem>[];
    for (final key in _box.keys) {
      final data = _box.get(key);
      if (data != null) {
        final map = json.decode(data) as Map<String, dynamic>;
        items.add(SuitItem.fromJson(key.toString(), map));
      }
    }
    items.sort((a, b) => a.ticketNumber.compareTo(b.ticketNumber));
    return items;
  }

  @override
  Future<void> addItem(SuitItem item) async {
    await _ensureInitialized();
    await _box.put(item.ticketNumber, json.encode({
      'image': item.imagePath,
      'description': item.description,
    }));
  }

  @override
  Future<void> updateItem(SuitItem item) async {
    await addItem(item);
  }

  @override
  Future<void> deleteItem(String ticketNumber) async {
    await _ensureInitialized();
    await _box.delete(ticketNumber);
  }
}
