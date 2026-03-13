import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/data/repositories/location.repository.dart';
import 'package:jolu_trip/widgets/video/video_item.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';

class FeedScreen extends StatefulWidget {
  final VoidCallback? onThemeToggle;
  final String? initialLocationId;
  const FeedScreen({super.key, this.onThemeToggle, this.initialLocationId});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final PageController _pageController = PageController();
  final _locationRepo = LocationRepository();
  List<LocationModel> _locations = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _loadLocations();
  }

  Future<void> _loadLocations() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('locations').get();

      final locations = snapshot.docs.map((doc) {
        return LocationModel.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();

      setState(() {
        _locations = locations;
        _isInitialized = true;
      });

      // Если есть initialLocationId, прокручиваем к нему
      if (widget.initialLocationId != null && locations.isNotEmpty) {
        _scrollToLocation();
      }
    } catch (e) {
      debugPrint('Ошибка загрузки локаций: $e');
    }
  }

  void _scrollToLocation() {
    final index = _locations
        .indexWhere((location) => location.id == widget.initialLocationId);

    if (index != -1) {
      // Небольшая задержка для завершения сборки
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(index);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = isDark ? AppColors.darkTheme : AppColors.lightTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (widget.onThemeToggle != null)
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: isDark ? Colors.white : Colors.black,
              ),
              onPressed: widget.onThemeToggle,
              tooltip: 'Переключить тему',
            ),
        ],
      ),
      body: StreamBuilder<List<LocationModel>>(
        stream: _locationRepo.getLocations(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            final msg = snapshot.error.toString().contains('PERMISSION_DENIED')
                ? 'Нет доступа к Firestore. Проверьте правила доступа.'
                : 'Ошибка загрузки: ${snapshot.error}';

            return Center(
              child: Padding(
                padding: AppDimens.screenPadding,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline,
                        color: AppColors.error, size: AppDimens.iconSizeL * 2),
                    const SizedBox(height: AppDimens.spaceM),
                    Text(msg,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: isDark
                              ? AppColors.textSecondaryDark
                              : AppColors.textSecondaryLight,
                        )),
                  ],
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                backgroundColor: isDark
                    ? Colors.white.withOpacity(0.1)
                    : Colors.black.withOpacity(0.1),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.video_library_outlined,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                      size: AppDimens.iconSizeL * 2),
                  const SizedBox(height: AppDimens.spaceM),
                  Text('Нет доступных видео',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      )),
                ],
              ),
            );
          }

          final locations = snapshot.data!;

          return PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: locations.length,
            itemBuilder: (context, index) {
              final location = locations[index];
              return VideoItem(
                key: ValueKey(location.id),
                id: location.id,
                url: location.videoUrl,
                title: location.name,
                category: location.category,
                price: location.price,
                carType: location.carType,
                travelTime: location.travelTime,
                difficult: location.difficult,
                thumbnailUrl: location.thumbnailUrl,
              );
            },
          );
        },
      ),
    );
  }
}
