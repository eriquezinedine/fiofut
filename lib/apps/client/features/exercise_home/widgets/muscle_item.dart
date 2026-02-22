import 'package:app_ui/app_ui.dart';
import 'package:fio_fut/apps/client/features/exercise_home/domain/model/muscle_repose.dart';
import 'package:fio_fut/core/extension/muscle_group_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MuscleItem extends StatelessWidget {
  const MuscleItem({super.key, required this.percentage, required this.muscleRepose});
  
  final MuscleRepose muscleRepose;
  final int percentage;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          SizedBox.square(
            dimension: 56,
            child: SvgPicture.asset(muscleRepose.muscle.muscleGroup.getIcon),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(muscleRepose.muscle.name,style: AppTextStyles.bodyMedium,),
              SizedBox(height: 8),
              SizedBox(
                width: 53,
                height: 22,
                child: DecoratedBox(decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: muscleRepose.percentageColor,
                ), 
                child: Center(
                  child: Text(
                    '$percentage%',
                    style: AppTextStyles.buttonSmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                )
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}