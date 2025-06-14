import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaplet/core/theme/app_theme.dart';
import 'package:zaplet/data/models/product_model.dart';
import 'package:zaplet/presentation/providers/product_provider.dart';
import 'package:zaplet/presentation/screens/product/product_details_screen.dart';
import 'package:zaplet/presentation/widgets/product_card.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');
final searchHistoryProvider = StateNotifierProvider<SearchHistoryNotifier, List<String>>((ref) => SearchHistoryNotifier());
final selectedFiltersProvider = StateProvider<Map<String, dynamic>>((ref) => {});

class SearchHistoryNotifier extends StateNotifier<List<String>> {
  SearchHistoryNotifier() : super([]);

  void addSearch(String query) {
    if (query.trim().isEmpty) return;
    state = [query, ...state.where((item) => item != query).take(4)].toList();
  }

  void clearHistory() {
    state = [];
  }

  void removeSearch(String query) {
    state = state.where((item) => item != query).toList();
  }
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchQuery = ref.watch(searchQueryProvider);
    final products = ref.watch(productProvider);
    final searchHistory = ref.watch(searchHistoryProvider);
    final selectedFilters = ref.watch(selectedFiltersProvider);

    final filteredProducts = _filterProducts(products, searchQuery, selectedFilters);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search for tech products...',
            border: InputBorder.none,
            hintStyle: AppTheme.bodyStyle.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          style: AppTheme.bodyStyle.copyWith(
            color: AppTheme.textPrimary,
          ),
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
          onSubmitted: (value) {
            if (value.trim().isNotEmpty) {
              ref.read(searchHistoryProvider.notifier).addSearch(value);
            }
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.filter_list,
              color: _showFilters ? AppTheme.primary : AppTheme.textSecondary,
            ),
            onPressed: () {
              setState(() {
                _showFilters = !_showFilters;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_showFilters) _buildFilters(),
          Expanded(
            child: searchQuery.isEmpty
                ? _buildSearchHistory(searchHistory)
                : _buildSearchResults(filteredProducts),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHistory(List<String> searchHistory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Searches',
                style: AppTheme.bodyStyle.copyWith(
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (searchHistory.isNotEmpty)
                TextButton(
                  onPressed: () {
                    ref.read(searchHistoryProvider.notifier).clearHistory();
                  },
                  child: Text(
                    'Clear All',
                    style: AppTheme.bodyStyle.copyWith(
                      color: AppTheme.primary,
                    ),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: searchHistory.length,
            itemBuilder: (context, index) {
              final query = searchHistory[index];
              return ListTile(
                leading: const Icon(Icons.history, color: AppTheme.textSecondary),
                title: Text(
                  query,
                  style: AppTheme.bodyStyle.copyWith(
                    color: AppTheme.textPrimary,
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                  onPressed: () {
                    ref.read(searchHistoryProvider.notifier).removeSearch(query);
                  },
                ),
                onTap: () {
                  _searchController.text = query;
                  ref.read(searchQueryProvider.notifier).state = query;
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchResults(List<Product> products) {
    if (products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64.sp,
              color: AppTheme.textSecondary,
            ),
            SizedBox(height: 16.h),
            Text(
              'No products found',
              style: AppTheme.bodyStyle.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16.w),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          product: product,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                  product: product,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFilters() {
    final selectedFilters = ref.watch(selectedFiltersProvider);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: AppTheme.bodyStyle.copyWith(
              color: AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _FilterChip(
                label: 'Smartphones',
                selected: selectedFilters['category'] == 'Smartphones',
                onSelected: (selected) {
                  _updateFilter('category', selected ? 'Smartphones' : null);
                },
              ),
              _FilterChip(
                label: 'Audio',
                selected: selectedFilters['category'] == 'Audio',
                onSelected: (selected) {
                  _updateFilter('category', selected ? 'Audio' : null);
                },
              ),
              _FilterChip(
                label: 'Laptops',
                selected: selectedFilters['category'] == 'Laptops',
                onSelected: (selected) {
                  _updateFilter('category', selected ? 'Laptops' : null);
                },
              ),
              _FilterChip(
                label: 'Under \$100',
                selected: selectedFilters['priceRange'] == 'under100',
                onSelected: (selected) {
                  _updateFilter('priceRange', selected ? 'under100' : null);
                },
              ),
              _FilterChip(
                label: '\$100 - \$500',
                selected: selectedFilters['priceRange'] == '100to500',
                onSelected: (selected) {
                  _updateFilter('priceRange', selected ? '100to500' : null);
                },
              ),
              _FilterChip(
                label: 'Over \$500',
                selected: selectedFilters['priceRange'] == 'over500',
                onSelected: (selected) {
                  _updateFilter('priceRange', selected ? 'over500' : null);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updateFilter(String key, dynamic value) {
    final currentFilters = Map<String, dynamic>.from(ref.read(selectedFiltersProvider));
    if (value == null) {
      currentFilters.remove(key);
    } else {
      currentFilters[key] = value;
    }
    ref.read(selectedFiltersProvider.notifier).state = currentFilters;
  }

  List<Product> _filterProducts(
    List<Product> products,
    String query,
    Map<String, dynamic> filters,
  ) {
    if (query.isEmpty && filters.isEmpty) return [];

    return products.where((product) {
      // Search query filter
      if (query.isNotEmpty) {
        final matchesQuery = product.name.toLowerCase().contains(query.toLowerCase()) ||
            product.description.toLowerCase().contains(query.toLowerCase()) ||
            product.category.toLowerCase().contains(query.toLowerCase());
        if (!matchesQuery) return false;
      }

      // Category filter
      if (filters.containsKey('category')) {
        if (product.category != filters['category']) return false;
      }

      // Price range filter
      if (filters.containsKey('priceRange')) {
        final price = product.price;
        switch (filters['priceRange']) {
          case 'under100':
            if (price >= 100) return false;
            break;
          case '100to500':
            if (price < 100 || price > 500) return false;
            break;
          case 'over500':
            if (price <= 500) return false;
            break;
        }
      }

      return true;
    }).toList();
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(
        label,
        style: AppTheme.bodyStyle.copyWith(
          color: selected ? Colors.white : AppTheme.textPrimary,
          fontSize: 12.sp,
        ),
      ),
      selected: selected,
      onSelected: onSelected,
      backgroundColor: Colors.grey[100],
      selectedColor: AppTheme.primary,
      checkmarkColor: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
    );
  }
} 