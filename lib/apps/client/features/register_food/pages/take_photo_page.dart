import 'dart:io';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../food_home/domain/providers/food_home_provider.dart';

class TakePhotoPage extends ConsumerStatefulWidget {
  const TakePhotoPage({super.key});

  @override
  ConsumerState<TakePhotoPage> createState() => _TakePhotoPageState();
}

class _TakePhotoPageState extends ConsumerState<TakePhotoPage> {
  final _picker = ImagePicker();
  bool _hasAttempted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _openCamera());
  }

  Future<void> _openCamera() async {
    if (_hasAttempted) return;
    _hasAttempted = true;

    final xFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 60,
      maxWidth: 1024,
    );

    if (!mounted) return;

    if (xFile != null) {
      // Add loading item to home and process in background.
      ref.read(foodHomeProvider.notifier).addLoadingItem(File(xFile.path));
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Tomar Foto', style: AppTextStyles.titleMedium),
        centerTitle: true,
      ),
      body: const Center(
        child: AppLoading(),
      ),
    );
  }
}
