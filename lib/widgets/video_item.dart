// import 'dart:async';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:jolu_trip/constants/app_dimens.dart';
// import 'package:jolu_trip/constants/app_colors.dart';
// import 'package:jolu_trip/constants/app_text_styles.dart';
// import 'package:video_player/video_player.dart';

// class VideoItem extends StatefulWidget {
//   final String url;
//   final String title;
//   final String category;
//   final int price;
//   final int travelTime;
//   final String carType;
//   final String difficult;
//   final String? thumbnailUrl; // постер (опционально)

//   const VideoItem({
//     super.key,
//     required this.url,
//     required this.title,
//     required this.category,
//     required this.price,
//     required this.travelTime,
//     required this.carType,
//     required this.difficult,
//     required this.thumbnailUrl,
//   });

//   @override
//   State<VideoItem> createState() => _VideoItemState();
// }

// class _VideoItemState extends State<VideoItem>
//     with SingleTickerProviderStateMixin {
//   VideoPlayerController? _controller;
//   bool _isInitialized = false;
//   bool _hasError = false;
//   bool _isPlaying = true;
//   bool _showPauseIcon = false;
//   bool _showIcon = false;
//   double _playbackSpeed = 1.0;
//   bool _isSpeedIndicatorVisible = false;
//   Timer? _speedIndicatorTimer;

//   static final _videoCacheManager = CacheManager(
//     Config(
//       'videoCache',
//       stalePeriod: const Duration(days: 7),
//       maxNrOfCacheObjects: 20,
//     ),
//   );

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//   }

//   Future<void> _initializeVideo() async {
//     if (widget.url.isEmpty) {
//       if (mounted) setState(() => _hasError = true);
//       return;
//     }
//     try {
//       VideoPlayerController controller;

//       final fileInfo = await _videoCacheManager.getFileFromCache(widget.url);

//       if (fileInfo != null) {
//         debugPrint('Видео найдено в кэше: ${widget.url}');
//         controller = VideoPlayerController.file(File(fileInfo.file.path),
//             videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true));
//       } else {
//         debugPrint('Видео из сети: ${widget.url}');

//         _videoCacheManager.downloadFile(widget.url);
//         controller = VideoPlayerController.networkUrl(
//           Uri.parse(widget.url),
//           videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
//         );
//       }

//       await controller.initialize();
//       if (!mounted) {
//         controller.dispose();
//         return;
//       }

//       setState(() {
//         _controller = controller;
//         _isInitialized = true;
//       });

//       _controller!.setLooping(true);
//       _controller!.setPlaybackSpeed(_playbackSpeed);
//       _controller!.play();
//     } catch (e) {
//       debugPrint('Ошибка загрузки видео: $e');
//       if (mounted) setState(() => _hasError = true);
//     }
//   }

//   void _togglePlayPause() {
//     if (_controller == null) return;
//     setState(() {
//       if (_controller!.value.isPlaying) {
//         _controller!.pause();
//         _isPlaying = false;
//       } else {
//         _controller!.play();
//         _isPlaying = true;
//       }
//       _showIcon = true;
//     });
//   }

//   void _onLongPressStart(LongPressStartDetails details) {
//     if (_controller == null) return;
//     setState(() {
//       _playbackSpeed = 2.0;
//       _controller!.setPlaybackSpeed(_playbackSpeed);
//       _isSpeedIndicatorVisible = true;
//     });

//     _speedIndicatorTimer?.cancel();
//   }

//   void _onLongPressEnd(LongPressEndDetails details) {
//     if (_controller == null) return;

//     setState(() {
//       _playbackSpeed = 1.0;
//       _controller!.setPlaybackSpeed(_playbackSpeed);
//     });

//     _speedIndicatorTimer = Timer(const Duration(milliseconds: 500), () {
//       if (mounted) setState(() => _isSpeedIndicatorVisible = false);
//     });
//   }

//   @override
//   void dispose() {
//     _speedIndicatorTimer?.cancel();
//     _controller?.dispose();
//     super.dispose();
//   }

//   String _getDifficultyLabel(String difficult) {
//     switch (difficult.toLowerCase()) {
//       case 'easy':
//         return 'Легко';
//       case 'нормально':
//         return 'Нормально';
//       case 'medium':
//         return 'Средне';
//       case 'hard':
//         return 'Сложно';
//       default:
//         return difficult;
//     }
//   }

//   Widget _buildFeatureChip({required IconData icon, required String label}) {
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: AppDimens.spaceXS,
//         vertical: AppDimens.spaceXXS,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.black.withOpacity(0.3),
//         borderRadius: BorderRadius.circular(AppDimens.radiusS),
//         border: Border.all(color: Colors.white.withOpacity(0.2), width: 0.5),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             icon,
//             color: Colors.white70,
//             size: AppDimens.iconSizeS,
//           ),
//           const SizedBox(
//             width: 4,
//           ),
//           Text(
//             label,
//             style: AppTextStyles.featureLabel
//                 .copyWith(color: Colors.white, fontSize: 12),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_hasError) {
//       return Container(
//         color: Colors.black,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(Icons.error_outline, color: AppColors.error, size: 50),
//               const SizedBox(height: AppDimens.spaceM),
//               Text(
//                 'Не удалось загрузить видео\n${widget.title}',
//                 style: const TextStyle(color: Colors.white),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return GestureDetector(
//       onTap: _togglePlayPause,
//       onLongPressStart: _onLongPressStart,
//       onLongPressEnd: _onLongPressEnd,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           // Видео
//           if (!_isInitialized)
//             _buildPlaceholder()
//           else
//             FittedBox(
//               fit: BoxFit.cover,
//               child: SizedBox(
//                 width: _controller!.value.size.width,
//                 height: _controller!.value.size.height,
//                 child: VideoPlayer(_controller!),
//               ),
//             ),

//           // Градиент для читаемости текста
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 300, // Увеличил для большего контента
//               decoration: const BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                   colors: [
//                     Colors.black87,
//                     Colors.black54,
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // КОНТЕНТ ВНИЗУ - красиво оформленный
//           Positioned(
//             bottom: 40,
//             left: AppDimens.spaceM,
//             right: AppDimens.spaceM,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Категория (красивая плашка)
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: AppDimens.spaceS,
//                     vertical: AppDimens.spaceXXS,
//                   ),
//                   decoration: BoxDecoration(
//                     color: AppColors.primary.withOpacity(0.9),
//                     borderRadius: BorderRadius.circular(AppDimens.radiusS),
//                   ),
//                   child: Text(
//                     widget.category,
//                     style: AppTextStyles.featureLabel.copyWith(
//                       color: Colors.white,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),

//                 const SizedBox(height: AppDimens.spaceXS),

//                 // Название
//                 Text(
//                   widget.title,
//                   style: AppTextStyles.locationTitle.copyWith(
//                     fontSize: 32,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),

//                 const SizedBox(height: AppDimens.spaceS),

//                 // Характеристики в одну строку
//                 Wrap(
//                   runSpacing: AppDimens.spaceS,
//                   spacing: AppDimens.spaceS,
//                   children: [
//                     // Время в пути
//                     _buildFeatureChip(
//                       icon: Icons.access_time,
//                       label: '${widget.travelTime} мин',
//                     ),

//                     // Тип машины
//                     _buildFeatureChip(
//                       icon: Icons.directions_car,
//                       label: widget.carType,
//                     ),

//                     // Сложность
//                     _buildFeatureChip(
//                       icon: Icons.terrain,
//                       label: _getDifficultyLabel(widget.difficult),
//                     ),
//                   ],
//                 ),

//                 const SizedBox(height: AppDimens.spaceM),

//                 // Цена и кнопка в одной строке
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Цена
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'от',
//                           style: AppTextStyles.bodyMedium.copyWith(
//                             color: Colors.white70,
//                             fontSize: 12,
//                           ),
//                         ),
//                         Text(
//                           '${widget.price} сом',
//                           style: AppTextStyles.headlineMedium.copyWith(
//                             color: Colors.white,
//                             fontSize: 24,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),

//                     // Кнопка "Узнать больше" - по центру снизу
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: AppColors.primary,
//                         foregroundColor: Colors.white,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: AppDimens.spaceL,
//                           vertical: AppDimens.spaceS,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius:
//                               BorderRadius.circular(AppDimens.radiusM),
//                         ),
//                         elevation: 0,
//                       ),
//                       onPressed: () {
//                         // Навигация на детальный экран
//                       },
//                       child: Text(
//                         'Узнать больше',
//                         style: AppTextStyles.buttonLarge,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),

//           // Кнопка паузы (появляется при паузе)
//           if (_showIcon)
//             Center(
//               child: Container(
//                 width: 70,
//                 height: 70,
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.4),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.play_arrow,
//                   color: Colors.white.withOpacity(0.9),
//                   size: 40,
//                 ),
//               ),
//             ),

//           // Индикатор скорости (при зажатии)
//           if (_isSpeedIndicatorVisible)
//             Positioned(
//               top: 100,
//               right: 20,
//               child: Container(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: AppDimens.spaceS,
//                   vertical: AppDimens.spaceXXS,
//                 ),
//                 decoration: BoxDecoration(
//                   color: Colors.black.withOpacity(0.6),
//                   borderRadius: BorderRadius.circular(AppDimens.radiusM),
//                   border: Border.all(color: Colors.white.withOpacity(0.3)),
//                 ),
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const Icon(Icons.flash_on, color: Colors.white, size: 16),
//                     const SizedBox(width: 4),
//                     Text(
//                       '${_playbackSpeed}x',
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPlaceholder() {
//     return Stack(
//       fit: StackFit.expand,
//       children: [
//         if (widget.thumbnailUrl != null && widget.thumbnailUrl!.isNotEmpty)
//           Image.network(
//             widget.thumbnailUrl!,
//             fit: BoxFit.cover,
//             errorBuilder: (_, __, ___) => _buildDefaultPlaceholder(),
//           )
//         else
//           _buildDefaultPlaceholder(),
//         const Center(
//           child: CircularProgressIndicator(
//             color: Colors.white,
//           ),
//         )
//       ],
//     );
//   }

//   Widget _buildDefaultPlaceholder() {
//     return Container(
//       color: Colors.grey[900],
//       child: const Center(
//         child: Icon(
//           Icons.landscape,
//           color: Colors.white24,
//           size: 80,
//         ),
//       ),
//     );
//   }
// }
