import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_custom_painter/front_body_custom_paint.dart';
import 'package:fio_fut/apps/client/features/repose/presentation/widgets/muscle_custom_painter/back_body_custom_paint.dart';
import 'package:flutter/material.dart';

class ReposeScreen extends StatefulWidget {
  static const String name = 'repose';
  static const String path = '/repose';

  const ReposeScreen({super.key});

  @override
  State<ReposeScreen> createState() => _ReposeScreenState();
}

class _ReposeScreenState extends State<ReposeScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reposo Muscular'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Front'),
            Tab(text: 'Back'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Center(child: FrontBodyCustomPaint(width: 200)),
          Center(child: BackBodyCustomPaint(width: 200)),
        ],
      ),
    );
  }
}
