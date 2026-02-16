import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/muscle_repose.dart';
import 'package:fio_fut/apps/client/features/exercise_home/widgets/muscle_item.dart';
import 'package:flutter/material.dart';

class MuscleReset extends StatelessWidget {
  const MuscleReset({super.key});

  @override
  Widget build(BuildContext context) {
    final data = MuscleRepose.data;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Músculos a entrenar',style: AppTextStyles.h3.copyWith(fontWeight: FontWeight.bold),),
          SizedBox(width: 16,),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 32,
              children: data.map((e) => MuscleItem(percentage: e.percentage, muscleRepose: e)).toList(),
            ),
          )
        ],
      ),
    );
  }
}

