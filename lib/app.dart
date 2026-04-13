import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/auth_screen.dart';
import 'features/search/search_screen.dart';
import 'features/detail/detail_screen.dart';
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
