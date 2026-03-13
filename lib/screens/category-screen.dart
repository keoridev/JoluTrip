import 'package:flutter/material.dart';
import 'package:jolu_trip/data/models/location_model.dart';
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

  final List<String> _categories = [
    'Все',
    'Горы',
    'Озеро',
    'Исторические',
  ];

  // Карта соответствий категорий (синонимы)
  final Map<String, List<String>> _categorySynonyms = {
    'горы': ['горы', 'гора', 'горный'],
    'озеро': ['озеро', 'озера', 'озёрный', 'озерный'],
    'исторические': ['исторические', 'история', 'исторический', 'древний'],
  };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    'Поиск мест',
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
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('locations').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('Нет доступных мест'),
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
          return _buildEmptyState();
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
                _navigateToVideo(context, location);
              },
            );
          },
        );
      },
    );
  }

  // Улучшенная фильтрация по категории (с учетом синонимов)
  bool _matchesCategory(LocationModel location) {
    if (_selectedCategory == 'Все') return true;

    final locationCat = location.category.toLowerCase().trim();
    final selectedCat = _selectedCategory.toLowerCase().trim();

    if (locationCat == selectedCat) return true;

    for (var entry in _categorySynonyms.entries) {
      if (entry.key == selectedCat || entry.value.contains(selectedCat)) {
        if (entry.value.contains(locationCat) ||
            locationCat.contains(entry.key)) {
          return true;
        }
      }
    }

    if (locationCat.contains(selectedCat) ||
        selectedCat.contains(locationCat)) {
      return true;
    }

    return false;
  }

  // Улучшенный поиск с учетом опечаток
  bool _matchesSearch(LocationModel location) {
    if (_searchQuery.isEmpty) return true;

    final query = _searchQuery.toLowerCase().trim();
    final name = location.name.toLowerCase();

    // Точное совпадение
    if (name.contains(query)) {
      return true;
    }

    if (_levenshteinDistance(name, query) <= 2) {
      return true;
    }

    final queryWords = query.split(' ');
    for (var word in queryWords) {
      if (word.length < 3) continue; // Пропускаем короткие слова

      if (name.contains(word) || _levenshteinDistance(name, word) <= 1) {
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

  Widget _buildEmptyState() {
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
              'Ничего не найдено',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[300],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Попробуйте изменить параметры поиска',
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
                      'Вы искали:',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$_searchQuery',
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

  void _navigateToVideo(BuildContext context, LocationModel location) {
    if (location.videoUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Видео для этого места еще не добавлено'),
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
