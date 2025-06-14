import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zaplet/presentation/screens/cart/cart_screen.dart';
import 'package:zaplet/presentation/screens/home/home_screen.dart';
import 'package:zaplet/presentation/screens/search/search_screen.dart';
import 'package:zaplet/presentation/widgets/curved_nav_bar.dart';

final currentIndexProvider = StateProvider<int>((ref) => 0);

class BaseScreen extends ConsumerWidget {
  const BaseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(currentIndexProvider);

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: const [
          HomeScreen(),
          SearchScreen(),
          FavoritesScreen(),
          CartScreen(),
        ],
      ),
      bottomNavigationBar: CurvedNavBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(currentIndexProvider.notifier).state = index,
      ),
    );
  }
} 