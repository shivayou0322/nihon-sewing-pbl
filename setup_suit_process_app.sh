#!/bin/bash
# ============================================================
# suit-process-app 初期セットアップスクリプト
# 
# 使い方:
#   1. flutter create --org com.yourcompany suit_process_app
#   2. cd suit_process_app
#   3. bash setup_suit_process_app.sh
#   4. gh repo create suit-process-app --private --source=. --push
# ============================================================

set -e
echo "🔧 suit-process-app セットアップ開始..."

# ────────────────────────────────────────
# 1. ディレクトリ構成の作成
# ────────────────────────────────────────
echo "📁 ディレクトリ構成を作成中..."

mkdir -p lib/features/auth
mkdir -p lib/features/search
mkdir -p lib/features/detail
mkdir -p lib/data/models
mkdir -p lib/data/repositories
mkdir -p lib/core/theme
mkdir -p lib/core/constants
mkdir -p lib/l10n
mkdir -p assets/data
mkdir -p assets/images

# ────────────────────────────────────────
# 2. .gitignore の追加項目
# ────────────────────────────────────────
echo "📝 .gitignore を更新中..."

cat >> .gitignore << 'EOF'

# IDE
.vscode/launch.json
*.iml

# macOS
.DS_Store

# 環境設定（パスワード等を含む可能性あり）
.env
EOF

# ────────────────────────────────────────
# 3. ダミーデータ (items.json)
# ────────────────────────────────────────
echo "📦 ダミーデータを作成中..."

cat > assets/data/items.json << 'EOF'
{
  "01": {
    "image": "assets/images/01.png",
    "description": "標準仕様：ボタン3つ、内ポケットあり"
  },
  "02": {
    "image": "assets/images/02.png",
    "description": "ダブルブレスト：ボタン6つ、フラップポケット"
  },
  "03": {
    "image": "assets/images/03.png",
    "description": "左ポケットあり、ボタンなし"
  },
  "04": {
    "image": "assets/images/04.png",
    "description": "スリーピース：ベスト付き、ノッチドラペル"
  },
  "05": {
    "image": "assets/images/05.png",
    "description": "カスタム裏地、名前刺繍入り"
  }
}
EOF

# ────────────────────────────────────────
# 4. ダミー画像のプレースホルダー
# ────────────────────────────────────────
echo "🖼️  ダミー画像プレースホルダーを作成中..."

for i in 01 02 03 04 05; do
  # 実際の画像がない場合の代替として空ファイルを作成
  # 本来は実際のダミー画像を配置してください
  touch "assets/images/${i}.png"
done

# ────────────────────────────────────────
# 5. 多言語リソースファイル (ARB)
# ────────────────────────────────────────
echo "🌐 多言語リソースを作成中..."

cat > lib/l10n/app_ja.arb << 'EOF'
{
  "@@locale": "ja",
  "appTitle": "工程確認アプリ",
  "loginTitle": "パスワードを入力してください",
  "loginButton": "ログイン",
  "loginError": "パスワードが正しくありません",
  "searchTitle": "伝票番号を入力",
  "searchHint": "伝票番号",
  "searchButton": "検索",
  "notFound": "該当する伝票番号が見つかりません",
  "backButton": "戻る"
}
EOF

cat > lib/l10n/app_my.arb << 'EOF'
{
  "@@locale": "my",
  "appTitle": "လုပ်ငန်းစဉ် အတည်ပြုချက် အက်ပ်",
  "loginTitle": "စကားဝှက်ထည့်ပါ",
  "loginButton": "ဝင်ရောက်ရန်",
  "loginError": "စကားဝှက် မှားနေပါသည်",
  "searchTitle": "ဘောင်ချာနံပါတ် ထည့်ပါ",
  "searchHint": "ဘောင်ချာနံပါတ်",
  "searchButton": "ရှာဖွေရန်",
  "notFound": "ဘောင်ချာနံပါတ် ရှာမတွေ့ပါ",
  "backButton": "နောက်သို့"
}
EOF

# ────────────────────────────────────────
# 6. データモデル
# ────────────────────────────────────────
echo "🏗️  データモデルを作成中..."

cat > lib/data/models/suit_item.dart << 'EOF'
class SuitItem {
  final String ticketNumber;
  final String imagePath;
  final String description;
  final String? processName; // Phase 2 拡張用

  const SuitItem({
    required this.ticketNumber,
    required this.imagePath,
    required this.description,
    this.processName,
  });

  factory SuitItem.fromJson(String ticketNumber, Map<String, dynamic> json) {
    return SuitItem(
      ticketNumber: ticketNumber,
      imagePath: json['image'] as String,
      description: json['description'] as String,
      processName: json['processName'] as String?,
    );
  }
}
EOF

# ────────────────────────────────────────
# 7. リポジトリ（ローカル→リモート差し替え可能な設計）
# ────────────────────────────────────────
echo "🗄️  リポジトリを作成中..."

cat > lib/data/repositories/item_repository.dart << 'EOF'
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
EOF

# ────────────────────────────────────────
# 8. 定数ファイル
# ────────────────────────────────────────
echo "⚙️  定数ファイルを作成中..."

cat > lib/core/constants/app_constants.dart << 'EOF'
class AppConstants {
  // Phase 1: シンプルなパスワード（本番では環境変数や暗号化を検討）
  static const String appPassword = '1234';
  
  // UI定数
  static const double minTapTarget = 48.0;
  static const double keypadButtonSize = 72.0;
}
EOF

# ────────────────────────────────────────
# 9. テーマ設定
# ────────────────────────────────────────
echo "🎨 テーマ設定を作成中..."

cat > lib/core/theme/app_theme.dart << 'EOF'
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF1B5E20), // 落ち着いた緑系
      brightness: Brightness.light,
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        bodyLarge: TextStyle(fontSize: 20),
        labelLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(200, 64),
          textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
    );
  }
}
EOF

# ────────────────────────────────────────
# 10. l10n.yaml（多言語設定）
# ────────────────────────────────────────
echo "📋 l10n.yaml を作成中..."

cat > l10n.yaml << 'EOF'
arb-dir: lib/l10n
template-arb-file: app_ja.arb
output-localization-file: app_localizations.dart
EOF

# ────────────────────────────────────────
# 11. analysis_options.yaml の強化
# ────────────────────────────────────────
echo "🔍 Lint設定を強化中..."

cat > analysis_options.yaml << 'EOF'
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_declarations
    - avoid_print
    - prefer_single_quotes
    - sort_child_properties_last
EOF

# ────────────────────────────────────────
# 12. pubspec.yaml にアセット登録の案内
# ────────────────────────────────────────
echo ""
echo "============================================================"
echo "✅ セットアップ完了！"
echo "============================================================"
echo ""
echo "📌 次にやること："
echo ""
echo "1. pubspec.yaml を編集して以下を追加："
echo ""
echo "   dependencies:"
echo "     flutter:"
echo "       sdk: flutter"
echo "     flutter_localizations:"
echo "       sdk: flutter"
echo "     intl: any"
echo "     hive: ^2.2.3"
echo "     hive_flutter: ^1.1.0"
echo ""
echo "   flutter:"
echo "     generate: true"
echo "     assets:"
echo "       - assets/data/"
echo "       - assets/images/"
echo ""
echo "2. 依存関係をインストール："
echo "   flutter pub get"
echo ""
echo "3. GitHubにpush："
echo "   git add ."
echo "   git commit -m 'chore: プロジェクト初期セットアップ'"
echo "   gh repo create suit-process-app --private --source=. --push"
echo ""
echo "4. VSCodeで開く："
echo "   code ."
echo ""
echo "5. 開発開始！"
echo "   flutter run"
echo ""
