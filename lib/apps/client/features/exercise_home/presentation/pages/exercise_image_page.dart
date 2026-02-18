import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/exercise.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/exercise_images_widgets/exercise_favorite.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/exercise_images_widgets/widgets.dart';
import 'package:fio_fut/core/extension/muscle_group_extension.dart';
import 'package:fio_fut/core/widgets/modal/exercise_instruction_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class ExerciseImagePage extends StatefulWidget {
  const ExerciseImagePage({
    required this.exercise,
    super.key,
  });

  static const String name = 'exercise-image';
  static const String path = '/exercise-image';

  final Exercise exercise;

  @override
  State<ExerciseImagePage> createState() => _ExerciseImagePageState();
}

class _ExerciseImagePageState extends State<ExerciseImagePage> {
  VideoPlayerController? _videoController;
  double _playbackSpeed = 1.0;
  final List<double> _speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5];

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    if (widget.exercise.videoUrl != null) {
      _videoController = VideoPlayerController.networkUrl(
        Uri.parse(widget.exercise.videoUrl!),
      );

      await _videoController!.initialize();
      await _videoController!.setLooping(true);
      await _videoController!.play();

      if (mounted) {
        setState(() {});
      }
    }
  }

  void _changePlaybackSpeed() {
    final currentIndex = _speedOptions.indexOf(_playbackSpeed);
    final nextIndex = (currentIndex + 1) % _speedOptions.length;
    final newSpeed = _speedOptions[nextIndex];

    setState(() {
      _playbackSpeed = newSpeed;
    });

    _videoController?.setPlaybackSpeed(newSpeed);
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          // Video de fondo
          if (_videoController != null && _videoController!.value.isInitialized)
            Positioned.fill(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _videoController!.value.size.width,
                  height: _videoController!.value.size.height,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            )
          else
            const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            ),

          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.black.withValues(alpha: 0),
                    AppColors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: CircleAvatar(
                        radius: 24,
                        backgroundColor: AppColors.backgroundSecondary.withValues(alpha: .8),
                        child: Icon(Icons.close,size: 24,color: AppColors.white),
                      ),
                    )
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20,vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      spacing: 8,
                      children: [
                        Text(widget.exercise.title, style: AppTextStyles.h3.copyWith(color: AppColors.white),),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8)
                          ,child: SizedBox(
                          width: 88,
                          height: 120,
                          child: Image.network(widget.exercise.imageUrl?? ''),
                        ),)
                      ],
                    ),
                    Column(
                      spacing: 24,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ExerciseFavorite(initialValue: false, onChangeValue: (bool value) {  }, exercise: widget.exercise,),
                        PlaybackSpeedButton(
                          speed: _playbackSpeed,
                          onTap: _changePlaybackSpeed,
                        ),
                         ViewInstructionsButton(onTap: ()=> ExerciseInstructionModal.show(
                          context,
                          exercise: widget.exercise,
                        )),
                       
                        SizedBox.square(
                          dimension: 64,
                          child: SvgPicture.asset(widget.exercise.muscleMain.muscleGroup.getIcon))
                      ],
                    ),
                  ],
                ),
              )
            ],
          ))
          // Content
          // SafeArea(
          //   child: Column(
          //     children: [
          //       // Header
          //       Padding(
          //         padding: const EdgeInsets.all(AppSpacing.lg),
          //         child: Row(
          //           children: [
          //             const CircularBackButton(),
          //             const Spacer(),
          //             PlaybackSpeedButton(
          //               speed: _playbackSpeed,
          //               onTap: _changePlaybackSpeed,
          //             ),
          //           ],
          //         ),
          //       ),

          //       const Spacer(),

          //       // Bottom info
          //       Padding(
          //         padding: const EdgeInsets.all(AppSpacing.lg),
          //         child: Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             // Imagen pequeña y título
          //             Row(
          //               children: [
          //                 ExerciseThumbnail(
          //                   imageUrl: widget.exercise.imageUrl,
          //                 ),
          //                 const SizedBox(width: AppSpacing.md),
          //                 Expanded(
          //                   child: ExerciseInfo(
          //                     title: widget.exercise.title,
          //                     description: widget.exercise.description,
          //                   ),
          //                 ),
          //               ],
          //             ),
          //             const SizedBox(height: AppSpacing.lg),

          //             // Músculo principal
          //             PrimaryMuscleContainer(
          //               muscleName: widget.exercise.muscleMain.name,
          //             ),
          //             const SizedBox(height: AppSpacing.md),

          //             // Botón de instrucciones
          //             ViewInstructionsButton(
          //               onTap: () => ExerciseInstructionModal.show(
          //                 context,
          //                 exercise: widget.exercise,
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
