import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:nihon_sewing_pbl/l10n/app_localizations.dart';
import '../../data/models/suit_item.dart';
import '../../data/repositories/item_repository.dart';

class AdminItemListScreen extends StatefulWidget {
  const AdminItemListScreen({super.key});

  @override
  State<AdminItemListScreen> createState() => _AdminItemListScreenState();
}

class _AdminItemListScreenState extends State<AdminItemListScreen> {
  final ItemRepository _repository = LocalItemRepository();
  List<SuitItem> _items = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _loadItems(); }

  Future<void> _loadItems() async {
    setState(() => _isLoading = true);
    final items = await _repository.getAllItems();
    setState(() { _items = items; _isLoading = false; });
  }

  Future<void> _deleteItem(SuitItem item) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(context: context, builder: (context) => AlertDialog(
      title: Text(l10n.deleteConfirmTitle),
      content: Text(l10n.deleteConfirmMessage(item.ticketNumber)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
        ElevatedButton(onPressed: () => Navigator.pop(context, true),
          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error, foregroundColor: Theme.of(context).colorScheme.onError),
          child: Text(l10n.delete)),
      ],
    ));
    if (confirmed == true) {
      await _repository.deleteItem(item.ticketNumber);
      await _loadItems();
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.deleted(item.ticketNumber))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.itemListTitle), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async { await Navigator.pushNamed(context, '/admin-item-edit'); await _loadItems(); },
        icon: const Icon(Icons.add), label: Text(l10n.addNew)),
      body: _isLoading ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty ? Center(child: Text(l10n.noData, style: const TextStyle(fontSize: 20), textAlign: TextAlign.center))
          : ListView.builder(
              padding: const EdgeInsets.all(16), itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                return Card(margin: const EdgeInsets.only(bottom: 12), child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: SizedBox(width: 60, height: 60, child: _buildThumbnail(item)),
                  title: Text('${l10n.ticketNumberLabel}: ${item.ticketNumber}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  subtitle: Padding(padding: const EdgeInsets.only(top: 8), child: Text(item.description, style: const TextStyle(fontSize: 16))),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(icon: const Icon(Icons.edit, size: 28), onPressed: () async {
                      await Navigator.pushNamed(context, '/admin-item-edit', arguments: item); await _loadItems(); }, tooltip: l10n.edit),
                    IconButton(icon: Icon(Icons.delete, size: 28, color: Theme.of(context).colorScheme.error), onPressed: () => _deleteItem(item), tooltip: l10n.delete),
                  ]),
                ));
              }),
    );
  }

  Widget _buildThumbnail(SuitItem item) {
    if (item.imagePath.startsWith('assets/')) {
      return ClipRRect(borderRadius: BorderRadius.circular(8),
        child: Image.asset(item.imagePath, fit: BoxFit.cover, errorBuilder: (c, e, s) => _placeholderIcon()));
    } else if (!kIsWeb && File(item.imagePath).existsSync()) {
      return ClipRRect(borderRadius: BorderRadius.circular(8),
        child: Image.file(File(item.imagePath), fit: BoxFit.cover, errorBuilder: (c, e, s) => _placeholderIcon()));
    }
    return _placeholderIcon();
  }

  Widget _placeholderIcon() {
    return Container(decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
      child: Icon(Icons.image_outlined, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)));
  }
}
