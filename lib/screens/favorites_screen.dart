import 'package:flutter/material.dart';
import 'package:jolu_trip/constants/app_colors.dart';
import 'package:jolu_trip/constants/app_dimens.dart';
import 'package:jolu_trip/constants/app_text_styles.dart';
import 'package:jolu_trip/data/models/location_model.dart';
import 'package:jolu_trip/screens/auth/auth_button.dart';
import 'package:jolu_trip/utils/scroll_utils.dart';
import 'package:jolu_trip/widgets/video/video_item.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  FavoritesProvider? _favoritesProvider;
  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;
  bool _isFirstBuild = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    // Initialize provider immediately
    _favoritesProvider = FavoritesProvider();
    _favoritesProvider!.init();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isFirstBuild && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _animationController.isCompleted == false) {
          _animationController.forward();
        }
      });
      _isFirstBuild = false;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _favoritesProvider?.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Guard clause - if provider is null, show loading
    if (_favoritesProvider == null) {
      return const Scaffold(
        backgroundColor: AppColors.bgDark,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    return ChangeNotifierProvider<FavoritesProvider>.value(
      value: _favoritesProvider!,
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        body: Consumer<FavoritesProvider>(
          builder: (context, provider, child) {
            if (!provider.isUserLoggedIn) {
              return _buildNotLoggedIn(context);
            }

            if (provider.isLoading) {
              return _buildLoading();
            }

            if (provider.error != null) {
              return _buildError(provider.error!);
            }

            if (provider.favorites.isEmpty) {
              return _buildEmpty();
            }

            return _buildFavoritesList(provider.favorites);
          },
        ),
      ),
    );
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: AppColors.textSecondaryDark,
            ),
            const SizedBox(height: AppDimens.spaceL),
            Text(
              'Войдите, чтобы сохранять',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceM),
            Text(
              'Добавляйте локации в избранное и возвращайтесь к ним позже',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondaryDark,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimens.spaceXL),
            ElevatedButton(
              onPressed: () {
                AuthPopup.show(
                  context: context,
                  onLogin: () => Navigator.pushNamed(context, '/auth',
                      arguments: {'mode': 'login'}),
                  onRegister: () => Navigator.pushNamed(context, '/auth',
                      arguments: {'mode': 'register'}),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.spaceXL,
                  vertical: AppDimens.spaceM,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusL),
                ),
              ),
              child: const Text('Войти или зарегистрироваться'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primary),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.spaceL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.error,
            ),
            const SizedBox(height: AppDimens.spaceM),
            Text(
              'Ошибка загрузки',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimaryDark,
              ),
            ),
            const SizedBox(height: AppDimens.spaceS),
            Text(
              error,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondaryDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.spaceL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_outline,
                size: 80,
                color: AppColors.textSecondaryDark,
              ),
              const SizedBox(height: AppDimens.spaceL),
              Text(
                'Пока пусто',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimaryDark,
                ),
              ),
              const SizedBox(height: AppDimens.spaceM),
              Text(
                'Добавляйте локации в избранное, нажимая на сердечко',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondaryDark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesList(List<LocationModel> favorites) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: favorites.length,
        itemBuilder: (context, index) {
          final location = favorites[index];

          return VideoItem(
            id: location.id,
            url: location.videoUrl,
            title: location.name,
            category: location.category,
            price: location.price,
            travelTime: location.travelTime,
            carType: location.carType,
            difficult: location.difficult,
            thumbnailUrl: location.thumbnailUrl,
          );
        },
      ),
    );
  }
}
