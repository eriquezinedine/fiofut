import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_custom_painter/back_body_custom_paint.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_custom_painter/front_body_custom_paint.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/repose_list_sliders/repose_list_sliders.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/repose_screen_widgets/most_used_muscles_section.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/repose_screen_widgets/repose_stats_section.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/screens/repose_slider_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ReposeScreen extends StatelessWidget {
  static const String name = 'repose';
  static const String path = '/repose';

  const ReposeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recuperación Muscular',
              style: AppTextStyles.h3,
              ),
          
              GestureDetector(
                onTap: () => context.pushNamed(ReposeSliderScreen.name),
                child: Text('Editar', style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                )),
              )
            ],
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(20).copyWith(top: 0),
        children: [
          SizedBox(height: 16),
          Row(
            spacing: 8,
            children: [
            Expanded(child: 
            LayoutBuilder(
              builder: (context, constraints) {
                final bodyWidth =( (constraints.maxWidth - 8) / 2) -24;
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FrontBodyCustomPaint(width: bodyWidth),
                      BackBodyCustomPaint(width: bodyWidth),
                    ],
                  ),
                );
              },
            )
            ),
            ReposeStatsSection(averagePercent: '20', musclesRecovering: '22', mostWornMuscle: '32')
          ],),
          MostUsedMusclesSection(
            muscles: kFakeMuscles.take(5).toList(),
          )
        ],
      ),
    );
  }
}
