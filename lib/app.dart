import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_screen.dart';
import 'features/search/search_screen.dart';
import 'features/detail/detail_screen.dart';
import 'features/admin/admin_auth_screen.dart';
import 'features/admin/admin_menu_screen.dart';
import 'features/admin/admin_item_list_screen.dart';
import 'features/admin/admin_item_edit_screen.dart';
import 'features/admin/admin_password_screen.dart';
import 'data/models/suit_item.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '工程確認アプリ',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth',
      routes: {
        '/auth': (context) => const AuthScreen(),
        '/search': (context) => const SearchScreen(),
        '/admin-auth': (context) => const AdminAuthScreen(),
        '/admin-menu': (context) => const AdminMenuScreen(),
        '/admin-items': (context) => const AdminItemListScreen(),
        '/admin-item-edit': (context) => const AdminItemEditScreen(),
        '/admin-password': (context) => const AdminPasswordScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final item = settings.arguments as SuitItem;
          return MaterialPageRoute(
            builder: (context) => DetailScreen(item: item),
          );
        }
        return null;
      },
    );
  }
}
