import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../data/repositories/item_repository.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _ticketNumber = '';
  String? _errorMessage;
  final ItemRepository _repository = LocalItemRepository();

  void _onKeyTap(String value) {
    if (_ticketNumber.length < 10) {
      setState(() {
        _ticketNumber += value;
        _errorMessage = null;
      });
    }
  }

  void _onDelete() {
    if (_ticketNumber.isNotEmpty) {
      setState(() {
        _ticketNumber = _ticketNumber.substring(0, _ticketNumber.length - 1);
        _errorMessage = null;
      });
    }
  }

  void _onClear() {
    setState(() {
      _ticketNumber = '';
      _errorMessage = null;
    });
  }

  Future<void> _onSearch() async {
    final item = await _repository.findByTicketNumber(_ticketNumber);
    if (item != null) {
      if (mounted) {
        Navigator.pushNamed(context, '/detail', arguments: item);
      }
    } else {
      setState(() {
        _errorMessage = '該当する伝票番号が見つかりません';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('伝票番号を入力'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/auth');
            },
            tooltip: 'ログアウト',
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _errorMessage != null
                          ? Theme.of(context).colorScheme.error
                          : Theme.of(context).colorScheme.outline,
                      width: 2,
                    ),
                  ),
                  child: Text(
                    _ticketNumber.isEmpty ? '伝票番号' : _ticketNumber,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: _ticketNumber.isEmpty
                          ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _errorMessage!,
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                _buildKeypad(),
                const SizedBox(height: 24),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _ticketNumber.isNotEmpty ? _onSearch : null,
                      icon: const Icon(Icons.search, size: 28),
                      label: const Text('検索'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        children: [
          for (var row = 0; row < 3; row++)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (var col = 1; col <= 3; col++)
                    _buildKeyButton('${row * 3 + col}'),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: AppConstants.keypadButtonSize,
                  height: AppConstants.keypadButtonSize,
                  child: ElevatedButton(
                    onPressed: _onClear,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('C', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              _buildKeyButton('0'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: SizedBox(
                  width: AppConstants.keypadButtonSize,
                  height: AppConstants.keypadButtonSize,
                  child: IconButton.filled(
                    onPressed: _onDelete,
                    icon: const Icon(Icons.backspace_outlined, size: 28),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.errorContainer,
                      foregroundColor: Theme.of(context).colorScheme.onErrorContainer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyButton(String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: AppConstants.keypadButtonSize,
        height: AppConstants.keypadButtonSize,
        child: ElevatedButton(
          onPressed: () => _onKeyTap(number),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            number,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
