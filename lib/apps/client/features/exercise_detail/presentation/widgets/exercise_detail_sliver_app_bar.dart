import 'dart:ui';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class ExerciseDetailSliverAppBar extends StatelessWidget {
  const ExerciseDetailSliverAppBar({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  final String title;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250,
      pinned: true,
      stretch: true,
      automaticallyImplyLeading: false,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final statusBarHeight = MediaQuery.of(context).padding.top;
          final maxExtent = 250.0 + statusBarHeight;
          final minExtent = statusBarHeight + kToolbarHeight;
          final t = ((constraints.maxHeight - minExtent) /
                  (maxExtent - minExtent))
              .clamp(0.0, 1.0);

          return Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                imageUrl ?? '',
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withValues(alpha: (1 - t) * 0.7),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Opacity(
                  opacity: t,
                  child: const Icon(
                    Icons.favorite_outline,
                    color: AppColors.favorite,
                    size: 28,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: statusBarHeight),
                child: Align(
                  alignment: Alignment.lerp(
                    Alignment.center,
                    Alignment.bottomLeft,
                    t,
                  )!,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    child: Text(
                      title,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: lerpDouble(14, 20, t),
                      ),
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
}
