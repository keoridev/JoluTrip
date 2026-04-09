import 'package:flutter/material.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/l10n/app_localizations.dart';
import 'package:jolu_trip/widgets/search/custom_searchBar.dart';
import 'package:jolu_trip/widgets/search/location-card.dart';

import 'package:jolu_trip/widgets/search/category_grid.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Все';
  String _searchQuery = '';

  // Карта соответствий категорий (синонимы на русском, английском и кыргызском)
  final Map<String, List<String>> _categorySynonyms = {
    // Горы / Mountains / Тоолор
    'горы': [
      'горы',
      'гора',
      'горный',
      'mountain',
      'mountains',
      'mount',
      'тоо',
      'тоолор',
      'тоосу'
    ],
    // Озеро / Lake / Көл
    'озеро': [
      'озеро',
      'озера',
      'озёрный',
      'озерный',
      'lake',
      'lakes',
      'көл',
      'көлүн',
      'көлдөр'
    ],
    // Исторические / Historical / Тарыхый
    'исторические': [
      'исторические',
      'история',
      'исторический',
      'древний',
      'historical',
      'history',
      'historic',
      'тарыхый',
      'тарых',
      'тарыхы',
      'башкы'
    ],
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<String> _categories = [
      l10n.allCategory,
      l10n.mountains,
      l10n.lake,
      l10n.historical,
    ];
    return Scaffold(
      backgroundColor: AppColors.darkTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(AppDimens.spaceM),
              child: Row(
                children: [
                  Text(
                    l10n.searchPlaces,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                  ),
                ],
              ),
            ),
            CustomSearchBar(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            CategoryGrid(
              categories: _categories,
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            Expanded(
              child: _buildResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('locations').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(l10n.noAvailablePlaces),
          );
        }

        final allLocations = snapshot.data!.docs.map((doc) {
          return LocationModel.fromFirestore(
            doc.id,
            doc.data() as Map<String, dynamic>,
          );
        }).toList();

        var filteredLocations = allLocations.where((location) {
          return _matchesCategory(location) && _matchesSearch(location);
        }).toList();

        if (filteredLocations.isEmpty) {
          return _buildEmptyState(l10n);
        }

        return GridView.builder(
          padding: const EdgeInsets.all(AppDimens.spaceM),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: filteredLocations.length,
          itemBuilder: (context, index) {
            final location = filteredLocations[index];
            return LocationCard(
              location: location,
              onTap: () {
                _navigateToVideo(context, location, l10n);
              },
            );
          },
        );
      },
    );
  }

  // Улучшенная фильтрация по категории (с учетом синонимов на всех языках)
  bool _matchesCategory(LocationModel location) {
    final selectedLower = _selectedCategory.toLowerCase().trim();

    // Проверка на "Все" / "All" / "Бүгүн"
    if (selectedLower == 'все' ||
        selectedLower == 'all' ||
        selectedLower == 'бүгүн') {
      return true;
    }

    final locationCat = location.category.toLowerCase().trim();

    // Прямое совпадение
    if (locationCat == selectedLower) return true;

    // Проверка синонимов
    for (var entry in _categorySynonyms.entries) {
      if (entry.key == selectedLower ||
          entry.value.any((v) => v.toLowerCase() == selectedLower)) {
        // Проверяем, содержит ли локация категорию из списка синонимов
        if (entry.value.any((syn) =>
            locationCat.contains(syn.toLowerCase()) ||
            locationCat.toLowerCase().contains(syn.toLowerCase()))) {
          return true;
        }
        // Проверяем подстроки
        if (locationCat.contains(entry.key) ||
            entry.key.contains(locationCat)) {
          return true;
        }
      }
    }

    return false;
  }

  // Улучшенный поиск с поддержкой многоязычности и опечаток
  bool _matchesSearch(LocationModel location) {
    if (_searchQuery.isEmpty) return true;

    final query = _searchQuery.toLowerCase().trim();
    final name = location.name.toLowerCase();
    final description = location.description.toLowerCase();

    // Точное совпадение в названии
    if (name.contains(query)) {
      return true;
    }

    // Точное совпадение в описании
    if (description.contains(query)) {
      return true;
    }

    // Проверка расстояния Левенштейна (допускаем опечатки)
    if (_levenshteinDistance(name, query) <= 2) {
      return true;
    }

    // Поиск по словам (особенно полезно для многоязычного контента)
    final queryWords = query.split(' ');
    for (var word in queryWords) {
      if (word.isEmpty || word.length < 2) continue;

      // Проверка в названии
      if (name.contains(word)) {
        return true;
      }

      // Проверка в описании
      if (description.contains(word)) {
        return true;
      }

      // Проверка расстояния Левенштейна для каждого слова
      if (_levenshteinDistance(name, word) <= 1) {
        return true;
      }
    }

    return false;
  }

  // Алгоритм расстояния Левенштейна (для поиска опечаток)
  int _levenshteinDistance(String s1, String s2) {
    if (s1.length < s2.length) {
      return _levenshteinDistance(s2, s1);
    }

    if (s2.isEmpty) return s1.length;

    List<int> previous = List.generate(s2.length + 1, (i) => i);
    List<int> current = List.generate(s2.length + 1, (i) => 0);

    for (int i = 0; i < s1.length; i++) {
      current[0] = i + 1;
      for (int j = 0; j < s2.length; j++) {
        int cost = s1[i] == s2[j] ? 0 : 1;
        current[j + 1] = [
          current[j] + 1,
          previous[j + 1] + 1,
          previous[j] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
      previous = List.from(current);
    }
    return previous[s2.length];
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              l10n.nothingFound,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.tryChangingSearch,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.youSearched,
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _searchQuery,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _navigateToVideo(
      BuildContext context, LocationModel location, AppLocalizations l10n) {
    if (location.videoUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.videoNotAdded),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.pushNamed(
      context,
      '/video-feed',
      arguments: location.id,
    );
  }
}
