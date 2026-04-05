import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../domain/providers/providers.dart';
import '../widgets/hydration_widgets/hydration_widgets.dart';

class HydrationScreen extends ConsumerStatefulWidget {
  static const String name = 'hydration';
  static const String path = '/hydration';

  const HydrationScreen({super.key});

  @override
  ConsumerState<HydrationScreen> createState() => _HydrationScreenState();
}

class _HydrationScreenState extends ConsumerState<HydrationScreen> {
  final _customAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(hydrationProvider.notifier).initialize();
    });
  }

  @override
  void dispose() {
    _customAmountController.dispose();
    super.dispose();
  }

  void _goBack() {
    ref.read(hydrationProvider.notifier).reset();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final hydrationState = ref.watch(hydrationProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) _goBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: switch (hydrationState) {
            HydrationInitial() || HydrationLoading() => Column(
                children: [
                  _buildHeader(),
                  const Expanded(child: HydrationShimmer()),
                ],
              ),
            HydrationError(:final message) => Center(
                child: Text(
                  'Error: $message',
                  style: AppTextStyles.body.copyWith(color: AppColors.error),
                ),
              ),
            HydrationLoaded(
              :final consumed,
              :final goal,
              :final progress,
              :final progressPercent,
              :final records,
            ) =>
              Builder(builder: (context) {
                final weekState = ref.watch(weekProvider);
                final selectedDate = weekState is WeekLoaded
                    ? weekState.selectedDate
                    : DateTime.now();
                final now = DateTime.now();
                final isToday = selectedDate.year == now.year &&
                    selectedDate.month == now.month &&
                    selectedDate.day == now.day;

                return Column(
                  children: [
                    _buildHeader(),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HydrationCircle(
                              consumed: consumed,
                              goal: goal,
                              progress: progress,
                              progressPercent: progressPercent,
                            ),
                            const SizedBox(height: 24),
                            HydrationGlassSection(
                              enabled: isToday,
                              onPreset: (amount) => ref
                                  .read(hydrationProvider.notifier)
                                  .addPresetWater(amount),
                            ),
                            const SizedBox(height: 24),
                            HydrationCustomSection(
                              controller: _customAmountController,
                              enabled: isToday,
                              onChanged: (value) {
                                final amount = int.tryParse(value);
                                ref
                                    .read(hydrationProvider.notifier)
                                    .setCustomAmount(amount);
                              },
                            ),
                            const SizedBox(height: 24),
                            HydrationHistorySection(
                              records: records,
                              enabled: isToday,
                              onDelete: (id) => ref
                                  .read(hydrationProvider.notifier)
                                  .deleteRecord(id),
                            ),
                            const SizedBox(height: 24),
                            HydrationSaveButton(
                              enabled: isToday,
                              onTap: () async {
                                await ref
                                    .read(hydrationProvider.notifier)
                                    .addCustomAmount();
                                _customAmountController.clear();
                                _goBack();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
          },
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _goBack,
            child: const Icon(
              LucideIcons.arrowLeft,
              color: AppColors.white,
              size: 24,
            ),
          ),
          Text(
            'Hidratación',
            style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}
