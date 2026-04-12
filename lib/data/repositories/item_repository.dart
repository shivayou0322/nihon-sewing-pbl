import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/suit_item.dart';

/// Phase 2 でリモートリポジトリに差し替えられるよう抽象化
abstract class ItemRepository {
  Future<SuitItem?> findByTicketNumber(String ticketNumber);
}

class LocalItemRepository implements ItemRepository {
  Map<String, dynamic>? _cache;

  Future<Map<String, dynamic>> _loadData() async {
    if (_cache != null) return _cache!;
    final jsonString = await rootBundle.loadString('assets/data/items.json');
    _cache = json.decode(jsonString) as Map<String, dynamic>;
    return _cache!;
  }

  @override
  Future<SuitItem?> findByTicketNumber(String ticketNumber) async {
    final data = await _loadData();
    final item = data[ticketNumber];
    if (item == null) return null;
    return SuitItem.fromJson(ticketNumber, item as Map<String, dynamic>);
  }
}
