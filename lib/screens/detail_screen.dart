import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jolu_trip/services/guides.services.dart';
import 'package:jolu_trip/services/image_cache_service.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/data/models/guides_model.dart';
import 'package:jolu_trip/widgets/detail-screen/gear_list.dart';
import 'package:jolu_trip/widgets/detail-screen/info_row_widget.dart';
import 'package:jolu_trip/widgets/detail-screen/travel_mode_selector.dart';
import 'package:jolu_trip/widgets/detail-screen/sliver_app_bar.dart';
import 'package:jolu_trip/widgets/detail-screen/description_section.dart';
import 'package:jolu_trip/widgets/error_widget.dart';
import 'package:jolu_trip/widgets/ui/divider.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/utils/scroll_utils.dart';

const double _kExpandedHeight = 320.0;

class DetailsScreen extends StatefulWidget {
  final String locationId;

  const DetailsScreen({super.key, required this.locationId});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _service = LocationGuidesService();
  final _imageCacheService = ImageCacheService();
  final _scrollController = ScrollController();

  bool _isDataLoaded = false;
  double _scrollOffset = 0;
  LocationModel? _cachedLocation;
  List<GuidesModel> _cachedGuides = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final offset = _scrollController.offset.clamp(0.0, _kExpandedHeight);
    if ((offset - _scrollOffset).abs() > 0.5) {
      setState(() => _scrollOffset = offset);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  double get _collapseProgress => ScrollUtils.calculateCollapseProgress(
      _scrollOffset, _kExpandedHeight, kToolbarHeight);

  LocationModel? _getLocation(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    if (_cachedLocation != null) return _cachedLocation;

    if (snapshot.hasData &&
        snapshot.data != null &&
        snapshot.data!.isNotEmpty &&
        snapshot.data!['locations'] != null) {
      try {
        final location = snapshot.data!['locations'] as LocationModel;
        _cachedLocation = location;
        _isDataLoaded = true;
        _imageCacheService.precacheImage(location.thumbnailUrl, context);
        return location;
      } catch (e) {
        debugPrint('Error getting location: $e');
        return null;
      }
    }

    return null;
  }

  List<GuidesModel> _getGuides(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    if (_cachedGuides.isNotEmpty) return _cachedGuides;

    if (snapshot.hasData &&
        snapshot.data != null &&
        snapshot.data!.isNotEmpty) {
      try {
        final guides = List<GuidesModel>.from(snapshot.data!['guides'] ?? []);
        _cachedGuides = guides;
        return guides;
      } catch (e) {
        debugPrint('Error getting guides: $e');
        return [];
      }
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = isDark ? AppColors.darkTheme : AppColors.lightTheme;
    final textPrimary =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;
    final cardColor = theme.cardColor;

    // Настройка статус-бара
    _updateStatusBar();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: StreamBuilder<Map<String, dynamic>>(
        stream: _service.getLocationWithGuidesStream(widget.locationId),
        builder: (context, snapshot) {
          final location = _getLocation(snapshot);
          final guides = _getGuides(snapshot);

          if (location == null) {
            return _buildLoadingOrError(snapshot, isDark);
          }

          return CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            cacheExtent: 500,
            slivers: [
              DetailsSliverAppBar(
                location: location,
                isDark: isDark,
                cardColor: cardColor,
                textSecondary: textSecondary,
                textPrimary: textPrimary,
                scrollOffset: _scrollOffset,
                collapseProgress: _collapseProgress,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppDimens.screenPadding,
                  child: RepaintBoundary(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppDimens.spaceM),
                        InfoRowWidget(location: location),
                        const SizedBox(height: AppDimens.spaceM),
                        DescriptionSection(
                          location: location,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                        ),
                        const SizedBox(height: AppDimens.spaceXL),
                        if (location.gearList.isNotEmpty) ...[
                          GearList(
                            gearList: location.gearList,
                            isDark: isDark,
                            textSecondary: textSecondary,
                            cardColor: cardColor,
                          ),
                          const SizedBox(height: AppDimens.spaceXL),
                        ],
                        DashedDivider(
                          color: isDark
                              ? Colors.white.withOpacity(0.1)
                              : Colors.black.withOpacity(0.07),
                        ),
                        const SizedBox(height: AppDimens.spaceXL),
                        TravelModeSelector(
                          location: location,
                          guides: guides,
                          isDark: isDark,
                          textPrimary: textPrimary,
                          textSecondary: textSecondary,
                          cardColor: cardColor,
                        ),
                        const SizedBox(height: AppDimens.spaceXXL),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateStatusBar() {
    final statusBarBrightness =
        _collapseProgress > 0.6 ? Brightness.dark : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarBrightness: statusBarBrightness,
      statusBarIconBrightness: statusBarBrightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
    ));
  }

  Widget _buildLoadingOrError(AsyncSnapshot snapshot, bool isDark) {
    if (snapshot.connectionState == ConnectionState.waiting && !_isDataLoaded) {
      return Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
          backgroundColor: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.1),
        ),
      );
    }
    return CustomErrorWidget(locationId: widget.locationId);
  }
}
