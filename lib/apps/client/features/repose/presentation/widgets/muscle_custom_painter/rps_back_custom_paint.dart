import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class RPSBackCustomPainter extends CustomPainter {
  final Color back1Color;
  final Color trapsColor;
  final Color lowerBack1Color;
  final Color glutes1Color;
  final Color tricepsColor;
  final Color rearDeltoidColor;
  final Color hamstringsColor;
  final Color calvesColor;

  RPSBackCustomPainter({
    this.back1Color = AppColors.muscleDefaultColor,
    this.trapsColor = AppColors.muscleDefaultColor,
    this.lowerBack1Color = AppColors.muscleDefaultColor,
    this.glutes1Color = AppColors.muscleDefaultColor,
    this.tricepsColor = AppColors.muscleDefaultColor,
    this.rearDeltoidColor = AppColors.muscleDefaultColor,
    this.hamstringsColor = AppColors.muscleDefaultColor,
    this.calvesColor = AppColors.muscleDefaultColor,
  });

  final Path _back1Path = Path();
  final Path _trapsPath = Path();
  final Path _lowerBack1Path = Path();
  final Path _glutes1Path = Path();
  final Path _tricepsPath = Path();
  final Path _rearDeltoidPath = Path();
  final Path _hamstringsPath = Path();
  final Path _calvesPath = Path();

  String? hitTestMuscle(Offset position) {
    if (_back1Path.contains(position)) return 'back1';
    if (_trapsPath.contains(position)) return 'traps';
    if (_lowerBack1Path.contains(position)) return 'lowerBack1';
    if (_glutes1Path.contains(position)) return 'glutes1';
    if (_tricepsPath.contains(position)) return 'triceps';
    if (_rearDeltoidPath.contains(position)) return 'rearDeltoid';
    if (_hamstringsPath.contains(position)) return 'hamstrings';
    if (_calvesPath.contains(position)) return 'calves';
    return null;
  }

  @override
  void paint(Canvas canvas, Size size) {
            
Path path_0 = Path();
    path_0.moveTo(size.width*0.6031087,size.height*0.08625672);
    path_0.cubicTo(size.width*0.6283287,size.height*0.07759118,size.width*0.6452662,size.height*0.05876345,size.width*0.6188025,size.height*0.05517731);
    path_0.cubicTo(size.width*0.6144150,size.height*0.05458319,size.width*0.6117400,size.height*0.05310210,size.width*0.6126238,size.height*0.05154160);
    path_0.cubicTo(size.width*0.6504037,size.height*-0.01559836,size.width*0.3392188,size.height*-0.01880517,size.width*0.3680325,size.height*0.05171092);
    path_0.cubicTo(size.width*0.3686475,size.height*0.05321092,size.width*0.3660288,size.height*0.05461681,size.width*0.3618187,size.height*0.05515840);
    path_0.cubicTo(size.width*0.3341925,size.height*0.05871471,size.width*0.3523712,size.height*0.07698193,size.width*0.3788225,size.height*0.08647815);
    path_0.cubicTo(size.width*0.3859200,size.height*0.08902731,size.width*0.3914950,size.height*0.09200462,size.width*0.3958487,size.height*0.09517017);
    path_0.cubicTo(size.width*0.4099762,size.height*0.1054298,size.width*0.4440963,size.height*0.1260315,size.width*0.4909662,size.height*0.1266555);
    path_0.cubicTo(size.width*0.5354625,size.height*0.1272496,size.width*0.5671975,size.height*0.1081479,size.width*0.5817838,size.height*0.09709496);
    path_0.cubicTo(size.width*0.5870450,size.height*0.09310630,size.width*0.5940075,size.height*0.08936933,size.width*0.6030975,size.height*0.08624916);
    path_0.lineTo(size.width*0.6031087,size.height*0.08625672);
    path_0.close();

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_0,paint_0_fill);

Path path_1 = Path();
    path_1.moveTo(size.width*0.3031725,size.height*0.6636723);
    path_1.lineTo(size.width*0.2361200,size.height*0.6888025);
    path_1.cubicTo(size.width*0.2252175,size.height*0.6931555,size.width*0.2158025,size.height*0.7027017,size.width*0.2105300,size.height*0.7081092);
    path_1.cubicTo(size.width*0.2016987,size.height*0.7171597,size.width*0.1902125,size.height*0.7299706,size.width*0.1874700,size.height*0.7319706);
    path_1.cubicTo(size.width*0.1556900,size.height*0.7549412,size.width*0.1551300,size.height*0.7841975,size.width*0.1668287,size.height*0.8166765);
    path_1.cubicTo(size.width*0.1783137,size.height*0.8486303,size.width*0.2016538,size.height*0.8837101,size.width*0.2187463,size.height*0.9189790);
    path_1.cubicTo(size.width*0.2206950,size.height*0.9230420,size.width*0.2190712,size.height*0.9271765,size.width*0.2143925,size.height*0.9309790);
    path_1.cubicTo(size.width*0.2069150,size.height*0.9370924,size.width*0.2048888,size.height*0.9433025,size.width*0.2072613,size.height*0.9495882);
    path_1.cubicTo(size.width*0.2082025,size.height*0.9520966,size.width*0.2068588,size.height*0.9546471,size.width*0.2037575,size.height*0.9569496);
    path_1.cubicTo(size.width*0.1926975,size.height*0.9651597,size.width*0.1717875,size.height*0.9737689,size.width*0.1368275,size.height*0.9829328);
    path_1.cubicTo(size.width*0.1306825,size.height*0.9845462,size.width*0.1263050,size.height*0.9868697,size.width*0.1253200,size.height*0.9894706);
    path_1.cubicTo(size.width*0.1253200,size.height*0.9895084,size.width*0.1252987,size.height*0.9895504,size.width*0.1252987,size.height*0.9895882);
    path_1.cubicTo(size.width*0.1240668,size.height*0.9932101,size.width*0.1328875,size.height*0.9963487,size.width*0.1437237,size.height*0.9963487);
    path_1.lineTo(size.width*0.3088150,size.height*0.9963487);
    path_1.cubicTo(size.width*0.3504012,size.height*0.9938109,size.width*0.3438750,size.height*0.9823697,size.width*0.3301513,size.height*0.9554496);
    path_1.cubicTo(size.width*0.3295913,size.height*0.9543655,size.width*0.3293225,size.height*0.9532731,size.width*0.3291662,size.height*0.9521681);
    path_1.cubicTo(size.width*0.3282587,size.height*0.9453992,size.width*0.3241513,size.height*0.9374454,size.width*0.3188000,size.height*0.9290504);
    path_1.cubicTo(size.width*0.3161812,size.height*0.9249328,size.width*0.3152512,size.height*0.9207059,size.width*0.3160237,size.height*0.9165126);
    path_1.cubicTo(size.width*0.3199975,size.height*0.8955084,size.width*0.3252925,size.height*0.8772983,size.width*0.3325575,size.height*0.8633866);
    path_1.cubicTo(size.width*0.3356588,size.height*0.8574580,size.width*0.3416925,size.height*0.8517563,size.width*0.3500762,size.height*0.8464160);
    path_1.cubicTo(size.width*0.3928162,size.height*0.8191639,size.width*0.4022975,size.height*0.7533445,size.width*0.3712112,size.height*0.7050210);
    path_1.cubicTo(size.width*0.3669688,size.height*0.6984202,size.width*0.3657925,size.height*0.6906092,size.width*0.3537037,size.height*0.6852143);
    path_1.lineTo(size.width*0.3031725,size.height*0.6636723);
    path_1.close();

Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
paint_1_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_1,paint_1_fill);

Path path_2 = Path();
    path_2.moveTo(size.width*0.6978488,size.height*0.6636723);
    path_2.lineTo(size.width*0.7649013,size.height*0.6888025);
    path_2.cubicTo(size.width*0.7758050,size.height*0.6931555,size.width*0.7852188,size.height*0.7027017,size.width*0.7904912,size.height*0.7081092);
    path_2.cubicTo(size.width*0.7993237,size.height*0.7171597,size.width*0.8108087,size.height*0.7299706,size.width*0.8135513,size.height*0.7319706);
    path_2.cubicTo(size.width*0.8453312,size.height*0.7549412,size.width*0.8458912,size.height*0.7841975,size.width*0.8341938,size.height*0.8166765);
    path_2.cubicTo(size.width*0.8227087,size.height*0.8486303,size.width*0.7993687,size.height*0.8837101,size.width*0.7822750,size.height*0.9189790);
    path_2.cubicTo(size.width*0.7803275,size.height*0.9230420,size.width*0.7819500,size.height*0.9271765,size.width*0.7866300,size.height*0.9309790);
    path_2.cubicTo(size.width*0.7941075,size.height*0.9370924,size.width*0.7961337,size.height*0.9433025,size.width*0.7937600,size.height*0.9495882);
    path_2.cubicTo(size.width*0.7928200,size.height*0.9520966,size.width*0.7941637,size.height*0.9546471,size.width*0.7972638,size.height*0.9569496);
    path_2.cubicTo(size.width*0.8083237,size.height*0.9651597,size.width*0.8292350,size.height*0.9737689,size.width*0.8641937,size.height*0.9829328);
    path_2.cubicTo(size.width*0.8703387,size.height*0.9845462,size.width*0.8747162,size.height*0.9868697,size.width*0.8757012,size.height*0.9894706);
    path_2.cubicTo(size.width*0.8757012,size.height*0.9895084,size.width*0.8757238,size.height*0.9895504,size.width*0.8757238,size.height*0.9895882);
    path_2.cubicTo(size.width*0.8769550,size.height*0.9932101,size.width*0.8681337,size.height*0.9963487,size.width*0.8572987,size.height*0.9963487);
    path_2.lineTo(size.width*0.6922075,size.height*0.9963487);
    path_2.cubicTo(size.width*0.6506213,size.height*0.9938109,size.width*0.6571475,size.height*0.9823697,size.width*0.6708713,size.height*0.9554496);
    path_2.cubicTo(size.width*0.6714313,size.height*0.9543655,size.width*0.6716988,size.height*0.9532731,size.width*0.6718563,size.height*0.9521681);
    path_2.cubicTo(size.width*0.6727625,size.height*0.9453992,size.width*0.6768713,size.height*0.9374454,size.width*0.6822213,size.height*0.9290504);
    path_2.cubicTo(size.width*0.6848413,size.height*0.9249328,size.width*0.6857700,size.height*0.9207059,size.width*0.6849975,size.height*0.9165126);
    path_2.cubicTo(size.width*0.6810238,size.height*0.8955084,size.width*0.6757287,size.height*0.8772983,size.width*0.6684638,size.height*0.8633866);
    path_2.cubicTo(size.width*0.6653638,size.height*0.8574580,size.width*0.6593300,size.height*0.8517563,size.width*0.6509450,size.height*0.8464160);
    path_2.cubicTo(size.width*0.6082063,size.height*0.8191639,size.width*0.5987250,size.height*0.7533445,size.width*0.6298113,size.height*0.7050210);
    path_2.cubicTo(size.width*0.6340537,size.height*0.6984202,size.width*0.6352288,size.height*0.6906092,size.width*0.6473187,size.height*0.6852143);
    path_2.lineTo(size.width*0.6978488,size.height*0.6636723);
    path_2.close();

Paint paint_2_fill = Paint()..style=PaintingStyle.fill;
paint_2_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_2,paint_2_fill);

Path path_3 = Path();
    path_3.moveTo(size.width*0.1087749,size.height*0.3810391);
    path_3.cubicTo(size.width*0.06649463,size.height*0.3565727,size.width*0.04724075,size.height*0.3299143,size.width*0.04887513,size.height*0.3113429);
    path_3.cubicTo(size.width*0.05066612,size.height*0.2905794,size.width*0.08081200,size.height*0.2736092,size.width*0.1412825,size.height*0.2607143);
    path_3.cubicTo(size.width*0.1444837,size.height*0.2600147,size.width*0.1477975,size.height*0.2593420,size.width*0.1511900,size.height*0.2586765);
    path_3.cubicTo(size.width*0.1564737,size.height*0.2576462,size.width*0.1639063,size.height*0.2580034,size.width*0.1668613,size.height*0.2598080);
    path_3.cubicTo(size.width*0.2688737,size.height*0.3217487,size.width*0.1617350,size.height*0.3679563,size.width*0.1087749,size.height*0.3810429);
    path_3.lineTo(size.width*0.1087749,size.height*0.3810391);
    path_3.close();

Paint paint_3_fill = Paint()..style=PaintingStyle.fill;
paint_3_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_3,paint_3_fill);

Path path_4 = Path();
    path_4.moveTo(size.width*0.1449325,size.height*0.5362605);
    path_4.cubicTo(size.width*0.1520412,size.height*0.5414202,size.width*0.1565750,size.height*0.5462437,size.width*0.1570000,size.height*0.5505672);
    path_4.cubicTo(size.width*0.1572912,size.height*0.5538571,size.width*0.1498137,size.height*0.5561723,size.width*0.1403100,size.height*0.5553487);
    path_4.cubicTo(size.width*0.1352388,size.height*0.5549160,size.width*0.1302912,size.height*0.5537605,size.width*0.1255113,size.height*0.5517773);
    path_4.cubicTo(size.width*0.1184025,size.height*0.5487899,size.width*0.1144845,size.height*0.5450840,size.width*0.1137345,size.height*0.5412857);
    path_4.cubicTo(size.width*0.1126151,size.height*0.5357479,size.width*0.1084733,size.height*0.5261261,size.width*0.09317088,size.height*0.5263782);
    path_4.cubicTo(size.width*0.06015938,size.height*0.5268950,size.width*0.07268563,size.height*0.5462605,size.width*0.07565200,size.height*0.5502857);
    path_4.cubicTo(size.width*0.07611100,size.height*0.5509076,size.width*0.07650275,size.height*0.5515252,size.width*0.07684975,size.height*0.5521429);
    path_4.lineTo(size.width*0.08053262,size.height*0.5586765);
    path_4.cubicTo(size.width*0.08253637,size.height*0.5622353,size.width*0.08704762,size.height*0.5655882,size.width*0.09367462,size.height*0.5684412);
    path_4.lineTo(size.width*0.1224324,size.height*0.5808193);
    path_4.cubicTo(size.width*0.1260150,size.height*0.5823613,size.width*0.1280962,size.height*0.5842437,size.width*0.1283650,size.height*0.5861975);
    path_4.lineTo(size.width*0.1283650,size.height*0.5862899);
    path_4.cubicTo(size.width*0.1288237,size.height*0.5893908,size.width*0.1205181,size.height*0.5919118,size.width*0.1114285,size.height*0.5912899);
    path_4.cubicTo(size.width*0.09404400,size.height*0.5901008,size.width*0.07668187,size.height*0.5843866,size.width*0.05678988,size.height*0.5788151);
    path_4.cubicTo(size.width*0.04896525,size.height*0.5766345,size.width*0.04250612,size.height*0.5739454,size.width*0.03786062,size.height*0.5709244);
    path_4.lineTo(size.width*0.008274500,size.height*0.5516933);
    path_4.cubicTo(size.width*0.001781888,size.height*0.5474664,size.width*-0.0009942550,size.height*0.5427143,size.width*0.0003378475,size.height*0.5379790);
    path_4.lineTo(size.width*0.01153199,size.height*0.4979874);
    path_4.cubicTo(size.width*0.01255063,size.height*0.4943992,size.width*0.01409550,size.height*0.4908193,size.width*0.01599850,size.height*0.4872689);
    path_4.cubicTo(size.width*0.04353600,size.height*0.4365126,size.width*-0.02582288,size.height*0.3867324,size.width*0.04710700,size.height*0.3513861);
    path_4.cubicTo(size.width*0.04951375,size.height*0.3544164,size.width*0.05186450,size.height*0.3572508,size.width*0.05426000,size.height*0.3599239);
    path_4.cubicTo(size.width*0.06181612,size.height*0.3683000,size.width*0.07002137,size.height*0.3752172,size.width*0.08262600,size.height*0.3823303);
    path_4.cubicTo(size.width*0.08850288,size.height*0.3856571,size.width*0.09534250,size.height*0.3890408,size.width*0.1035366,size.height*0.3926273);
    path_4.cubicTo(size.width*0.1037494,size.height*0.3927063,size.width*0.1224547,size.height*0.3882513,size.width*0.1226674,size.height*0.3883416);
    path_4.cubicTo(size.width*0.1464888,size.height*0.3828340,size.width*0.1484025,size.height*0.3813828,size.width*0.1652725,size.height*0.3748336);
    path_4.cubicTo(size.width*0.1713400,size.height*0.3725029,size.width*0.1769138,size.height*0.3700971,size.width*0.1820412,size.height*0.3676231);
    path_4.cubicTo(size.width*0.2248025,size.height*0.4150861,size.width*0.1293275,size.height*0.4395546,size.width*0.1009620,size.height*0.4839664);
    path_4.cubicTo(size.width*0.09780525,size.height*0.4889370,size.width*0.1000552,size.height*0.4941303,size.width*0.1072866,size.height*0.4985966);
    path_4.lineTo(size.width*0.1201824,size.height*0.5053403);
    path_4.cubicTo(size.width*0.1261600,size.height*0.5084538,size.width*0.1301225,size.height*0.5119496,size.width*0.1318237,size.height*0.5156008);
    path_4.lineTo(size.width*0.1377012,size.height*0.5282101);
    path_4.cubicTo(size.width*0.1390113,size.height*0.5309916,size.width*0.1414175,size.height*0.5337059,size.width*0.1449100,size.height*0.5362521);
    path_4.lineTo(size.width*0.1449325,size.height*0.5362605);
    path_4.close();

Paint paint_4_fill = Paint()..style=PaintingStyle.fill;
paint_4_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_4,paint_4_fill);

Path path_5 = Path();
    path_5.moveTo(size.width*0.8829337,size.height*0.3801403);
    path_5.cubicTo(size.width*0.8299750,size.height*0.3670538,size.width*0.7228350,size.height*0.3208462,size.width*0.8248475,size.height*0.2589055);
    path_5.cubicTo(size.width*0.8278138,size.height*0.2571008,size.width*0.8352363,size.height*0.2567437,size.width*0.8405200,size.height*0.2577739);
    path_5.cubicTo(size.width*0.8439113,size.height*0.2584353,size.width*0.8471913,size.height*0.2591084,size.width*0.8504262,size.height*0.2598113);
    path_5.cubicTo(size.width*0.9108863,size.height*0.2727101,size.width*0.9410425,size.height*0.2896765,size.width*0.9428337,size.height*0.3104399);
    path_5.cubicTo(size.width*0.9444350,size.height*0.3290155,size.width*0.9252037,size.height*0.3556702,size.width*0.8829337,size.height*0.3801366);
    path_5.lineTo(size.width*0.8829337,size.height*0.3801403);
    path_5.close();

Paint paint_5_fill = Paint()..style=PaintingStyle.fill;
paint_5_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_5,paint_5_fill);

Path path_6 = Path();
    path_6.moveTo(size.width*0.9834088,size.height*0.5507983);
    path_6.lineTo(size.width*0.9538225,size.height*0.5700294);
    path_6.cubicTo(size.width*0.9491763,size.height*0.5730504,size.width*0.9427175,size.height*0.5757437,size.width*0.9348812,size.height*0.5779202);
    path_6.cubicTo(size.width*0.9149900,size.height*0.5834916,size.width*0.8976275,size.height*0.5892017,size.width*0.8802437,size.height*0.5903950);
    path_6.cubicTo(size.width*0.8711650,size.height*0.5910168,size.width*0.8628588,size.height*0.5884958,size.width*0.8633062,size.height*0.5853908);
    path_6.lineTo(size.width*0.8633062,size.height*0.5853025);
    path_6.cubicTo(size.width*0.8635750,size.height*0.5833487,size.width*0.8656575,size.height*0.5814622,size.width*0.8692388,size.height*0.5799202);
    path_6.lineTo(size.width*0.8979975,size.height*0.5675462);
    path_6.cubicTo(size.width*0.9046238,size.height*0.5646933,size.width*0.9091350,size.height*0.5613403,size.width*0.9111387,size.height*0.5577773);
    path_6.lineTo(size.width*0.9148212,size.height*0.5512479);
    path_6.cubicTo(size.width*0.9151687,size.height*0.5506303,size.width*0.9155712,size.height*0.5500126,size.width*0.9160200,size.height*0.5493908);
    path_6.cubicTo(size.width*0.9189863,size.height*0.5453655,size.width*0.9315125,size.height*0.5260000,size.width*0.8985013,size.height*0.5254832);
    path_6.cubicTo(size.width*0.8831988,size.height*0.5252311,size.width*0.8790562,size.height*0.5348529,size.width*0.8779375,size.height*0.5403866);
    path_6.cubicTo(size.width*0.8771875,size.height*0.5441933,size.width*0.8732575,size.height*0.5478950,size.width*0.8661612,size.height*0.5508824);
    path_6.cubicTo(size.width*0.8613812,size.height*0.5528613,size.width*0.8564438,size.height*0.5540210,size.width*0.8513625,size.height*0.5544538);
    path_6.cubicTo(size.width*0.8418587,size.height*0.5552773,size.width*0.8343813,size.height*0.5529622,size.width*0.8346713,size.height*0.5496681);
    path_6.cubicTo(size.width*0.8350975,size.height*0.5453445,size.width*0.8396425,size.height*0.5405252,size.width*0.8467387,size.height*0.5353655);
    path_6.cubicTo(size.width*0.8502425,size.height*0.5328151,size.width*0.8526388,size.height*0.5301008,size.width*0.8539475,size.height*0.5273193);
    path_6.lineTo(size.width*0.8598250,size.height*0.5147101);
    path_6.cubicTo(size.width*0.8615375,size.height*0.5110588,size.width*0.8654887,size.height*0.5075630,size.width*0.8714675,size.height*0.5044496);
    path_6.lineTo(size.width*0.8843625,size.height*0.4977059);
    path_6.cubicTo(size.width*0.8916050,size.height*0.4932395,size.width*0.8938437,size.height*0.4880504,size.width*0.8906875,size.height*0.4830798);
    path_6.cubicTo(size.width*0.8623212,size.height*0.4386639,size.width*0.7668463,size.height*0.4141979,size.width*0.8096075,size.height*0.3667349);
    path_6.cubicTo(size.width*0.8147350,size.height*0.3692084,size.width*0.8203212,size.height*0.3716147,size.width*0.8263763,size.height*0.3739454);
    path_6.cubicTo(size.width*0.8432575,size.height*0.3804945,size.width*0.8636537,size.height*0.3864945,size.width*0.8875075,size.height*0.3919983);
    path_6.cubicTo(size.width*0.8877213,size.height*0.3919080,size.width*0.8879112,size.height*0.3918181,size.width*0.8881237,size.height*0.3917391);
    path_6.cubicTo(size.width*0.8963175,size.height*0.3881525,size.width*0.9031575,size.height*0.3847689,size.width*0.9090350,size.height*0.3814416);
    path_6.cubicTo(size.width*0.9216387,size.height*0.3743290,size.width*0.9298338,size.height*0.3674151,size.width*0.9374000,size.height*0.3590353);
    path_6.cubicTo(size.width*0.9398075,size.height*0.3563626,size.width*0.9421575,size.height*0.3535277,size.width*0.9445538,size.height*0.3504979);
    path_6.cubicTo(size.width*1.017484,size.height*0.3858441,size.width*0.9481350,size.height*0.4356218,size.width*0.9756625,size.height*0.4863782);
    path_6.cubicTo(size.width*0.9775537,size.height*0.4899328,size.width*0.9791100,size.height*0.4935126,size.width*0.9801175,size.height*0.4970966);
    path_6.lineTo(size.width*0.9913113,size.height*0.5370924);
    path_6.cubicTo(size.width*0.9926438,size.height*0.5418277,size.width*0.9898675,size.height*0.5465798,size.width*0.9833863,size.height*0.5508067);
    path_6.lineTo(size.width*0.9834088,size.height*0.5507983);
    path_6.close();

Paint paint_6_fill = Paint()..style=PaintingStyle.fill;
paint_6_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_6,paint_6_fill);

Path path_7 = Path();
    path_7.moveTo(size.width*0.7678662,size.height*0.1731542);
    path_7.cubicTo(size.width*0.7573100,size.height*0.1734210,size.width*0.7466875,size.height*0.1729361,size.width*0.7366687,size.height*0.1717517);
    path_7.cubicTo(size.width*0.6435437,size.height*0.1608269,size.width*0.5783050,size.height*0.1457328,size.width*0.5663050,size.height*0.1227059);
    path_7.cubicTo(size.width*0.5235213,size.height*0.1394693,size.width*0.4760800,size.height*0.1471613,size.width*0.4146462,size.height*0.1212773);
    path_7.cubicTo(size.width*0.4159788,size.height*0.1402214,size.width*0.3509412,size.height*0.1560861,size.width*0.2458388,size.height*0.1700937);
    path_7.cubicTo(size.width*0.2317563,size.height*0.1719622,size.width*0.2163762,size.height*0.1724286,size.width*0.2015213,size.height*0.1714475);
    path_7.cubicTo(size.width*0.1953650,size.height*0.1711618,size.width*0.1892862,size.height*0.1710261,size.width*0.1832638,size.height*0.1710261);
    path_7.cubicTo(size.width*0.1102219,size.height*0.1710261,size.width*0.04923612,size.height*0.1912672,size.width*0.05102725,size.height*0.2165832);
    path_7.lineTo(size.width*0.05106087,size.height*0.2502983);
    path_7.lineTo(size.width*0.05313175,size.height*0.2703962);
    path_7.cubicTo(size.width*0.05313175,size.height*0.2703962,size.width*0.1416550,size.height*0.2428433,size.width*0.1682862,size.height*0.2469521);
    path_7.cubicTo(size.width*0.1918162,size.height*0.2505840,size.width*0.2234175,size.height*0.2781218,size.width*0.2262825,size.height*0.2851933);
    path_7.cubicTo(size.width*0.2291825,size.height*0.2922576,size.width*0.2338612,size.height*0.3090584,size.width*0.2378350,size.height*0.3176185);
    path_7.cubicTo(size.width*0.2420888,size.height*0.3268105,size.width*0.2639850,size.height*0.3446378,size.width*0.2667050,size.height*0.3600290);
    path_7.cubicTo(size.width*0.2678350,size.height*0.3663899,size.width*0.2644663,size.height*0.3773151,size.width*0.2600887,size.height*0.3879542);
    path_7.cubicTo(size.width*0.2552638,size.height*0.3997664,size.width*0.2468012,size.height*0.4113983,size.width*0.2339175,size.height*0.4225084);
    path_7.cubicTo(size.width*0.1551100,size.height*0.4904874,size.width*0.2307713,size.height*0.5726765,size.width*0.2181338,size.height*0.6786807);
    path_7.lineTo(size.width*0.3014513,size.height*0.6520294);
    path_7.lineTo(size.width*0.3818250,size.height*0.6790210);
    path_7.cubicTo(size.width*0.4520575,size.height*0.6102689,size.width*0.4834575,size.height*0.5590798,size.width*0.4786663,size.height*0.4969832);
    path_7.cubicTo(size.width*0.4786100,size.height*0.4963529,size.width*0.4784637,size.height*0.4940840,size.width*0.4782400,size.height*0.4910798);
    path_7.cubicTo(size.width*0.4914725,size.height*0.4939202,size.width*0.5083638,size.height*0.4939790,size.width*0.5217075,size.height*0.4911933);
    path_7.cubicTo(size.width*0.5213712,size.height*0.4944706,size.width*0.5211925,size.height*0.4969916,size.width*0.5211362,size.height*0.4977227);
    path_7.cubicTo(size.width*0.5163338,size.height*0.5598277,size.width*0.5477338,size.height*0.6110210,size.width*0.6179988,size.height*0.6797647);
    path_7.lineTo(size.width*0.6983400,size.height*0.6527815);
    path_7.lineTo(size.width*0.7816687,size.height*0.6794202);
    path_7.cubicTo(size.width*0.7529337,size.height*0.5967647,size.width*0.8477250,size.height*0.4918403,size.width*0.7520825,size.height*0.4080412);
    path_7.cubicTo(size.width*0.7419525,size.height*0.3991651,size.width*0.7344525,size.height*0.3899731,size.width*0.7296837,size.height*0.3806008);
    path_7.lineTo(size.width*0.7234700,size.height*0.3683975);
    path_7.cubicTo(size.width*0.7203475,size.height*0.3622471,size.width*0.7206613,size.height*0.3507092,size.width*0.7255525,size.height*0.3447055);
    path_7.cubicTo(size.width*0.7461950,size.height*0.3299273,size.width*0.7627950,size.height*0.3150622,size.width*0.7620337,size.height*0.2996937);
    path_7.cubicTo(size.width*0.7675413,size.height*0.2685050,size.width*0.7965463,size.height*0.2567794,size.width*0.8169863,size.height*0.2457870);
    path_7.cubicTo(size.width*0.8222700,size.height*0.2429445,size.width*0.8277550,size.height*0.2449861,size.width*0.8366438,size.height*0.2465013);
    path_7.lineTo(size.width*0.9280888,size.height*0.2643773);
    path_7.cubicTo(size.width*0.9289950,size.height*0.2624336,size.width*0.9303275,size.height*0.2553021,size.width*0.9310662,size.height*0.2534412);
    path_7.cubicTo(size.width*0.9552000,size.height*0.1936206,size.width*0.8966550,size.height*0.1698534,size.width*0.7678775,size.height*0.1731504);
    path_7.lineTo(size.width*0.7678662,size.height*0.1731542);
    path_7.close();
    path_7.moveTo(size.width*0.2604025,size.height*0.3226563);
    path_7.cubicTo(size.width*0.2603463,size.height*0.3221336,size.width*0.2610513,size.height*0.3216828,size.width*0.2621938,size.height*0.3213971);
    path_7.cubicTo(size.width*0.2612538,size.height*0.3216828,size.width*0.2607725,size.height*0.3221487,size.width*0.2604025,size.height*0.3226563);
    path_7.close();
    path_7.moveTo(size.width*0.2636600,size.height*0.3211487);
    path_7.cubicTo(size.width*0.2648800,size.height*0.3210134,size.width*0.2663238,size.height*0.3210622,size.width*0.2675775,size.height*0.3213592);
    path_7.cubicTo(size.width*0.2658987,size.height*0.3211298,size.width*0.2646225,size.height*0.3210849,size.width*0.2636600,size.height*0.3211487);
    path_7.close();

Paint paint_7_fill = Paint()..style=PaintingStyle.fill;
paint_7_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_7,paint_7_fill);

Path traps1a = Path();
    traps1a.moveTo(size.width*0.4447237,size.height*0.1410324);
    traps1a.lineTo(size.width*0.4516300,size.height*0.1419798);
    traps1a.cubicTo(size.width*0.4608762,size.height*0.1432504,size.width*0.4669213,size.height*0.1462731,size.width*0.4669213,size.height*0.1496303);
    traps1a.lineTo(size.width*0.4669213,size.height*0.1707097);
    traps1a.cubicTo(size.width*0.4669213,size.height*0.1771155,size.width*0.4510812,size.height*0.1822773,size.width*0.4320175,size.height*0.1820105);
    traps1a.cubicTo(size.width*0.3865700,size.height*0.1813790,size.width*0.3074163,size.height*0.1830706,size.width*0.2571650,size.height*0.1844731);
    traps1a.lineTo(size.width*0.3783762,size.height*0.1746609);
    traps1a.cubicTo(size.width*0.4022750,size.height*0.1726794,size.width*0.4280437,size.height*0.1663563,size.width*0.4284700,size.height*0.1580891);
    traps1a.lineTo(size.width*0.4291638,size.height*0.1444761);
    traps1a.cubicTo(size.width*0.4292975,size.height*0.1418105,size.width*0.4373800,size.height*0.1400210,size.width*0.4447237,size.height*0.1410324);
    traps1a.close();

Paint paint_8_fill = Paint()..style=PaintingStyle.fill;
paint_8_fill.color = trapsColor;
canvas.drawPath(traps1a,paint_8_fill);
_trapsPath.addPath(traps1a, Offset.zero);

Path traps1b = Path();
    traps1b.moveTo(size.width*0.5402400,size.height*0.1410311);
    traps1b.lineTo(size.width*0.5333337,size.height*0.1419786);
    traps1b.cubicTo(size.width*0.5240863,size.height*0.1432492,size.width*0.5180425,size.height*0.1462718,size.width*0.5180425,size.height*0.1496290);
    traps1b.lineTo(size.width*0.5180425,size.height*0.1707084);
    traps1b.cubicTo(size.width*0.5180425,size.height*0.1771143,size.width*0.5338813,size.height*0.1822761,size.width*0.5529450,size.height*0.1820092);
    traps1b.cubicTo(size.width*0.5983937,size.height*0.1813777,size.width*0.6871738,size.height*0.1827160,size.width*0.7374137,size.height*0.1841143);
    traps1b.lineTo(size.width*0.6065875,size.height*0.1746555);
    traps1b.cubicTo(size.width*0.5826887,size.height*0.1726744,size.width*0.5569188,size.height*0.1663508,size.width*0.5564938,size.height*0.1580840);
    traps1b.lineTo(size.width*0.5558000,size.height*0.1444710);
    traps1b.cubicTo(size.width*0.5556650,size.height*0.1418055,size.width*0.5475838,size.height*0.1400160,size.width*0.5402400,size.height*0.1410273);
    traps1b.lineTo(size.width*0.5402400,size.height*0.1410311);
    traps1b.close();

Paint paint_9_fill = Paint()..style=PaintingStyle.fill;
paint_9_fill.color = trapsColor;
canvas.drawPath(traps1b,paint_9_fill);
_trapsPath.addPath(traps1b, Offset.zero);

Path traps1c = Path();
    traps1c.moveTo(size.width*0.2671875,size.height*0.1898937);
    traps1c.cubicTo(size.width*0.3433200,size.height*0.1866080,size.width*0.4074612,size.height*0.1865555,size.width*0.4590000,size.height*0.1898937);
    traps1c.cubicTo(size.width*0.4640813,size.height*0.1898937,size.width*0.4682125,size.height*0.1912773,size.width*0.4682125,size.height*0.1929878);
    traps1c.lineTo(size.width*0.4682125,size.height*0.2711769);
    traps1c.cubicTo(size.width*0.4682125,size.height*0.2865718,size.width*0.4582275,size.height*0.3017866,size.width*0.4389513,size.height*0.3157567);
    traps1c.lineTo(size.width*0.4386937,size.height*0.3159408);
    traps1c.cubicTo(size.width*0.4356375,size.height*0.3181513,size.width*0.4265363,size.height*0.3183655,size.width*0.4225962,size.height*0.3163168);
    traps1c.lineTo(size.width*0.2808225,size.height*0.2425151);
    traps1c.cubicTo(size.width*0.2789538,size.height*0.2415412,size.width*0.2788638,size.height*0.2403004,size.width*0.2805763,size.height*0.2392933);
    traps1c.lineTo(size.width*0.3113150,size.height*0.2213643);
    traps1c.cubicTo(size.width*0.3131400,size.height*0.2203004,size.width*0.3129163,size.height*0.2189693,size.width*0.3107450,size.height*0.2179807);
    traps1c.lineTo(size.width*0.2597775,size.height*0.1948223);
    traps1c.cubicTo(size.width*0.2552888,size.height*0.1927811,size.width*0.2596213,size.height*0.1898899,size.width*0.2671875,size.height*0.1898899);
    traps1c.lineTo(size.width*0.2671875,size.height*0.1898937);
    traps1c.close();

Paint paint_10_fill = Paint()..style=PaintingStyle.fill;
paint_10_fill.color = trapsColor;
canvas.drawPath(traps1c,paint_10_fill);
_trapsPath.addPath(traps1c, Offset.zero);

Path traps1d = Path();
    traps1d.moveTo(size.width*0.7190663,size.height*0.1898937);
    traps1d.cubicTo(size.width*0.6429350,size.height*0.1866080,size.width*0.5787925,size.height*0.1865555,size.width*0.5272550,size.height*0.1898937);
    traps1d.cubicTo(size.width*0.5221725,size.height*0.1898937,size.width*0.5180425,size.height*0.1912773,size.width*0.5180425,size.height*0.1929878);
    traps1d.lineTo(size.width*0.5180425,size.height*0.2711769);
    traps1d.cubicTo(size.width*0.5180425,size.height*0.2865718,size.width*0.5280275,size.height*0.3017866,size.width*0.5473037,size.height*0.3157567);
    traps1d.lineTo(size.width*0.5475612,size.height*0.3159408);
    traps1d.cubicTo(size.width*0.5506175,size.height*0.3181513,size.width*0.5597175,size.height*0.3183655,size.width*0.5636575,size.height*0.3163168);
    traps1d.lineTo(size.width*0.7054325,size.height*0.2425151);
    traps1d.cubicTo(size.width*0.7073012,size.height*0.2415412,size.width*0.7073912,size.height*0.2403004,size.width*0.7056788,size.height*0.2392933);
    traps1d.lineTo(size.width*0.6749388,size.height*0.2213643);
    traps1d.cubicTo(size.width*0.6731150,size.height*0.2203004,size.width*0.6733387,size.height*0.2189693,size.width*0.6755100,size.height*0.2179807);
    traps1d.lineTo(size.width*0.7264775,size.height*0.1948223);
    traps1d.cubicTo(size.width*0.7309663,size.height*0.1927811,size.width*0.7266337,size.height*0.1898899,size.width*0.7190663,size.height*0.1898899);
    traps1d.lineTo(size.width*0.7190663,size.height*0.1898937);
    traps1d.close();

Paint paint_11_fill = Paint()..style=PaintingStyle.fill;
paint_11_fill.color = trapsColor;
canvas.drawPath(traps1d,paint_11_fill);
_trapsPath.addPath(traps1d, Offset.zero);

Path rearDeltoid1 = Path();
    rearDeltoid1.moveTo(size.width*0.7293863,size.height*0.2013118);
    rearDeltoid1.lineTo(size.width*0.7449687,size.height*0.1927214);
    rearDeltoid1.cubicTo(size.width*0.7494800,size.height*0.1902366,size.width*0.7571250,size.height*0.1885975,size.width*0.7657337,size.height*0.1882702);
    rearDeltoid1.cubicTo(size.width*0.7990812,size.height*0.1870034,size.width*0.8824663,size.height*0.1856197,size.width*0.9010375,size.height*0.2023231);
    rearDeltoid1.cubicTo(size.width*0.9176612,size.height*0.2172706,size.width*0.9189813,size.height*0.2380193,size.width*0.9157575,size.height*0.2469517);
    rearDeltoid1.cubicTo(size.width*0.9147950,size.height*0.2496248,size.width*0.9056712,size.height*0.2509668,size.width*0.8991450,size.height*0.2494067);
    rearDeltoid1.lineTo(size.width*0.7332600,size.height*0.2076840);
    rearDeltoid1.cubicTo(size.width*0.7271925,size.height*0.2062332,size.width*0.7254912,size.height*0.2034508,size.width*0.7293750,size.height*0.2013118);
    rearDeltoid1.lineTo(size.width*0.7293863,size.height*0.2013118);
    rearDeltoid1.close();

Paint paint_12_fill = Paint()..style=PaintingStyle.fill;
paint_12_fill.color = rearDeltoidColor;
canvas.drawPath(rearDeltoid1,paint_12_fill);
_rearDeltoidPath.addPath(rearDeltoid1, Offset.zero);

Path back1a = Path();
    back1a.moveTo(size.width*0.7108537,size.height*0.2235189);
    back1a.cubicTo(size.width*0.7040925,size.height*0.2320979,size.width*0.7301625,size.height*0.2351466,size.width*0.7194837,size.height*0.2482975);
    back1a.cubicTo(size.width*0.7172000,size.height*0.2511130,size.width*0.7224050,size.height*0.2539815,size.width*0.7308687,size.height*0.2546433);
    back1a.cubicTo(size.width*0.7604438,size.height*0.2569630,size.width*0.7895475,size.height*0.2493160,size.width*0.8064175,size.height*0.2381882);
    back1a.cubicTo(size.width*0.8095300,size.height*0.2361315,size.width*0.8094513,size.height*0.2334664,size.width*0.8046262,size.height*0.2318235);
    back1a.cubicTo(size.width*0.7817450,size.height*0.2240525,size.width*0.7650550,size.height*0.2196651,size.width*0.7396225,size.height*0.2164471);
    back1a.cubicTo(size.width*0.7265925,size.height*0.2148004,size.width*0.7144125,size.height*0.2189962,size.width*0.7108537,size.height*0.2235189);
    back1a.close();

Paint paint_13_fill = Paint()..style=PaintingStyle.fill;
paint_13_fill.color = back1Color;
canvas.drawPath(back1a,paint_13_fill);
_back1Path.addPath(back1a, Offset.zero);

Path back1b = Path();
    back1b.moveTo(size.width*0.6967612,size.height*0.2563643);
    back1b.cubicTo(size.width*0.6612750,size.height*0.2722782,size.width*0.6144162,size.height*0.2971584,size.width*0.5827712,size.height*0.3161059);
    back1b.cubicTo(size.width*0.5765688,size.height*0.3198164,size.width*0.5779800,size.height*0.3244332,size.width*0.5862750,size.height*0.3276475);
    back1b.lineTo(size.width*0.6394462,size.height*0.3482605);
    back1b.cubicTo(size.width*0.6583313,size.height*0.3555803,size.width*0.6931225,size.height*0.3542534,size.width*0.7067800,size.height*0.3457231);
    back1b.cubicTo(size.width*0.7216113,size.height*0.3364597,size.width*0.7368137,size.height*0.3257378,size.width*0.7385038,size.height*0.3197601);
    back1b.cubicTo(size.width*0.7417050,size.height*0.3084630,size.width*0.7509400,size.height*0.2802071,size.width*0.7711687,size.height*0.2604811);
    back1b.cubicTo(size.width*0.7726125,size.height*0.2590752,size.width*0.7687388,size.height*0.2577366,size.width*0.7644962,size.height*0.2581613);
    back1b.cubicTo(size.width*0.7466412,size.height*0.2599471,size.width*0.7285963,size.height*0.2598345,size.width*0.7137875,size.height*0.2556315);
    back1b.cubicTo(size.width*0.7086375,size.height*0.2541689,size.width*0.7008125,size.height*0.2545450,size.width*0.6967713,size.height*0.2563609);
    back1b.lineTo(size.width*0.6967612,size.height*0.2563643);
    back1b.close();

Paint paint_14_fill = Paint()..style=PaintingStyle.fill;
paint_14_fill.color = back1Color;
canvas.drawPath(back1b,paint_14_fill);
_back1Path.addPath(back1b, Offset.zero);

Path rearDeltoid2 = Path();
    rearDeltoid2.moveTo(size.width*0.2578825,size.height*0.2013118);
    rearDeltoid2.lineTo(size.width*0.2423000,size.height*0.1927214);
    rearDeltoid2.cubicTo(size.width*0.2377887,size.height*0.1902366,size.width*0.2301425,size.height*0.1885975,size.width*0.2215350,size.height*0.1882702);
    rearDeltoid2.cubicTo(size.width*0.1881875,size.height*0.1870034,size.width*0.1048020,size.height*0.1856197,size.width*0.08623100,size.height*0.2023231);
    rearDeltoid2.cubicTo(size.width*0.06960762,size.height*0.2172706,size.width*0.06828675,size.height*0.2380193,size.width*0.07151063,size.height*0.2469517);
    rearDeltoid2.cubicTo(size.width*0.07247337,size.height*0.2496248,size.width*0.08159663,size.height*0.2509668,size.width*0.08812275,size.height*0.2494067);
    rearDeltoid2.lineTo(size.width*0.2540088,size.height*0.2076840);
    rearDeltoid2.cubicTo(size.width*0.2600763,size.height*0.2062332,size.width*0.2617775,size.height*0.2034508,size.width*0.2578937,size.height*0.2013118);
    rearDeltoid2.lineTo(size.width*0.2578825,size.height*0.2013118);
    rearDeltoid2.close();

Paint paint_15_fill = Paint()..style=PaintingStyle.fill;
paint_15_fill.color = rearDeltoidColor;
canvas.drawPath(rearDeltoid2,paint_15_fill);
_rearDeltoidPath.addPath(rearDeltoid2, Offset.zero);

Path back1c = Path();
    back1c.moveTo(size.width*0.2763975,size.height*0.2235189);
    back1c.cubicTo(size.width*0.2831588,size.height*0.2320979,size.width*0.2570875,size.height*0.2351466,size.width*0.2677675,size.height*0.2482975);
    back1c.cubicTo(size.width*0.2700500,size.height*0.2511130,size.width*0.2648450,size.height*0.2539815,size.width*0.2563825,size.height*0.2546433);
    back1c.cubicTo(size.width*0.2268075,size.height*0.2569630,size.width*0.1977025,size.height*0.2493160,size.width*0.1808337,size.height*0.2381882);
    back1c.cubicTo(size.width*0.1777212,size.height*0.2361315,size.width*0.1778000,size.height*0.2334664,size.width*0.1826238,size.height*0.2318235);
    back1c.cubicTo(size.width*0.2055050,size.height*0.2240525,size.width*0.2221950,size.height*0.2196651,size.width*0.2476288,size.height*0.2164471);
    back1c.cubicTo(size.width*0.2606587,size.height*0.2148004,size.width*0.2728375,size.height*0.2189962,size.width*0.2763975,size.height*0.2235189);
    back1c.close();

Paint paint_16_fill = Paint()..style=PaintingStyle.fill;
paint_16_fill.color = back1Color;
canvas.drawPath(back1c,paint_16_fill);
_back1Path.addPath(back1c, Offset.zero);

Path back1d = Path();
    back1d.moveTo(size.width*0.2904987,size.height*0.2563643);
    back1d.cubicTo(size.width*0.3259850,size.height*0.2722782,size.width*0.3728425,size.height*0.2971584,size.width*0.4044887,size.height*0.3161059);
    back1d.cubicTo(size.width*0.4106900,size.height*0.3198164,size.width*0.4092800,size.height*0.3244332,size.width*0.4009850,size.height*0.3276475);
    back1d.lineTo(size.width*0.3478125,size.height*0.3482605);
    back1d.cubicTo(size.width*0.3289287,size.height*0.3555803,size.width*0.2941375,size.height*0.3542534,size.width*0.2804800,size.height*0.3457231);
    back1d.cubicTo(size.width*0.2656475,size.height*0.3364597,size.width*0.2504462,size.height*0.3257378,size.width*0.2487563,size.height*0.3197601);
    back1d.cubicTo(size.width*0.2455550,size.height*0.3084630,size.width*0.2363187,size.height*0.2802071,size.width*0.2160912,size.height*0.2604811);
    back1d.cubicTo(size.width*0.2146475,size.height*0.2590752,size.width*0.2185213,size.height*0.2577366,size.width*0.2227638,size.height*0.2581613);
    back1d.cubicTo(size.width*0.2406175,size.height*0.2599471,size.width*0.2586625,size.height*0.2598345,size.width*0.2734725,size.height*0.2556315);
    back1d.cubicTo(size.width*0.2786225,size.height*0.2541689,size.width*0.2864463,size.height*0.2545450,size.width*0.2904875,size.height*0.2563609);
    back1d.lineTo(size.width*0.2904987,size.height*0.2563643);
    back1d.close();

Paint paint_17_fill = Paint()..style=PaintingStyle.fill;
paint_17_fill.color = back1Color;
canvas.drawPath(back1d,paint_17_fill);
_back1Path.addPath(back1d, Offset.zero);

Path lowerBack1a = Path();
    lowerBack1a.moveTo(size.width*0.4491500,size.height*0.3275987);
    lowerBack1a.cubicTo(size.width*0.4667813,size.height*0.3441853,size.width*0.4514225,size.height*0.3710996,size.width*0.4351350,size.height*0.3840130);
    lowerBack1a.cubicTo(size.width*0.4316650,size.height*0.3867651,size.width*0.4219150,size.height*0.3879307,size.width*0.4139888,size.height*0.3865660);
    lowerBack1a.lineTo(size.width*0.3386862,size.height*0.3735845);
    lowerBack1a.cubicTo(size.width*0.3285550,size.height*0.3718399,size.width*0.3263275,size.height*0.3673134,size.width*0.3342425,size.height*0.3645655);
    lowerBack1a.cubicTo(size.width*0.3663250,size.height*0.3534261,size.width*0.4010150,size.height*0.3401555,size.width*0.4305450,size.height*0.3267004);
    lowerBack1a.cubicTo(size.width*0.4356050,size.height*0.3243920,size.width*0.4462725,size.height*0.3249034,size.width*0.4491388,size.height*0.3276025);
    lowerBack1a.lineTo(size.width*0.4491500,size.height*0.3275987);
    lowerBack1a.close();

Paint paint_18_fill = Paint()..style=PaintingStyle.fill;
paint_18_fill.color = lowerBack1Color;
canvas.drawPath(lowerBack1a,paint_18_fill);
_lowerBack1Path.addPath(lowerBack1a, Offset.zero);

Path lowerBack1b = Path();
    lowerBack1b.moveTo(size.width*0.5340150,size.height*0.3275987);
    lowerBack1b.cubicTo(size.width*0.5163837,size.height*0.3441853,size.width*0.5317425,size.height*0.3710996,size.width*0.5480300,size.height*0.3840130);
    lowerBack1b.cubicTo(size.width*0.5515000,size.height*0.3867651,size.width*0.5612500,size.height*0.3879307,size.width*0.5691763,size.height*0.3865660);
    lowerBack1b.lineTo(size.width*0.6444787,size.height*0.3735845);
    lowerBack1b.cubicTo(size.width*0.6546100,size.height*0.3718399,size.width*0.6568375,size.height*0.3673134,size.width*0.6489225,size.height*0.3645655);
    lowerBack1b.cubicTo(size.width*0.6168400,size.height*0.3534261,size.width*0.5821500,size.height*0.3401555,size.width*0.5526200,size.height*0.3267004);
    lowerBack1b.cubicTo(size.width*0.5475600,size.height*0.3243920,size.width*0.5368925,size.height*0.3249034,size.width*0.5340262,size.height*0.3276025);
    lowerBack1b.lineTo(size.width*0.5340150,size.height*0.3275987);
    lowerBack1b.close();

Paint paint_19_fill = Paint()..style=PaintingStyle.fill;
paint_19_fill.color = lowerBack1Color;
canvas.drawPath(lowerBack1b,paint_19_fill);
_lowerBack1Path.addPath(lowerBack1b, Offset.zero);

Path path_20 = Path();
    path_20.moveTo(size.width*0.2805625,size.height*0.3621261);
    path_20.cubicTo(size.width*0.2827562,size.height*0.3608550,size.width*0.2858350,size.height*0.3599227,size.width*0.2896513,size.height*0.3592651);
    path_20.cubicTo(size.width*0.2996475,size.height*0.3575433,size.width*0.3113575,size.height*0.3600282,size.width*0.3121525,size.height*0.3637950);
    path_20.cubicTo(size.width*0.3128575,size.height*0.3671672,size.width*0.3157338,size.height*0.3705735,size.width*0.3202675,size.height*0.3740097);
    path_20.cubicTo(size.width*0.3242075,size.height*0.3769983,size.width*0.3189687,size.height*0.3804571,size.width*0.3095100,size.height*0.3812353);
    path_20.lineTo(size.width*0.2982937,size.height*0.3821563);
    path_20.cubicTo(size.width*0.2883538,size.height*0.3829761,size.width*0.2787600,size.height*0.3804458,size.width*0.2787600,size.height*0.3770097);
    path_20.lineTo(size.width*0.2787600,size.height*0.3645958);
    path_20.cubicTo(size.width*0.2787600,size.height*0.3637349,size.width*0.2792863,size.height*0.3628702,size.width*0.2805738,size.height*0.3621261);
    path_20.lineTo(size.width*0.2805625,size.height*0.3621261);
    path_20.close();

Paint paint_20_fill = Paint()..style=PaintingStyle.fill;
paint_20_fill.color = Color(0xff6C7180).withOpacity(1.0);
canvas.drawPath(path_20,paint_20_fill);

Path path_21 = Path();
    path_21.moveTo(size.width*0.7072150,size.height*0.3621261);
    path_21.cubicTo(size.width*0.7050200,size.height*0.3608550,size.width*0.7019425,size.height*0.3599227,size.width*0.6981250,size.height*0.3592651);
    path_21.cubicTo(size.width*0.6881287,size.height*0.3575433,size.width*0.6764200,size.height*0.3600282,size.width*0.6756250,size.height*0.3637950);
    path_21.cubicTo(size.width*0.6749200,size.height*0.3671672,size.width*0.6720425,size.height*0.3705735,size.width*0.6675087,size.height*0.3740097);
    path_21.cubicTo(size.width*0.6635688,size.height*0.3769983,size.width*0.6688075,size.height*0.3804571,size.width*0.6782662,size.height*0.3812353);
    path_21.lineTo(size.width*0.6894825,size.height*0.3821563);
    path_21.cubicTo(size.width*0.6994238,size.height*0.3829761,size.width*0.7090175,size.height*0.3804458,size.width*0.7090175,size.height*0.3770097);
    path_21.lineTo(size.width*0.7090175,size.height*0.3645958);
    path_21.cubicTo(size.width*0.7090175,size.height*0.3637349,size.width*0.7084913,size.height*0.3628702,size.width*0.7072038,size.height*0.3621261);
    path_21.lineTo(size.width*0.7072150,size.height*0.3621261);
    path_21.close();

Paint paint_21_fill = Paint()..style=PaintingStyle.fill;
paint_21_fill.color = Color(0xff6C7180).withOpacity(1.0);
canvas.drawPath(path_21,paint_21_fill);

Path path_22 = Path();
    path_22.moveTo(size.width*0.2708575,size.height*0.4082887);
    path_22.cubicTo(size.width*0.2607487,size.height*0.4177887,size.width*0.2520287,size.height*0.4295714,size.width*0.2418425,size.height*0.4406975);
    path_22.cubicTo(size.width*0.2396150,size.height*0.4431261,size.width*0.2460400,size.height*0.4454916,size.width*0.2533950,size.height*0.4449076);
    path_22.cubicTo(size.width*0.3197312,size.height*0.4396639,size.width*0.3144137,size.height*0.4073071,size.width*0.4240050,size.height*0.4048336);
    path_22.cubicTo(size.width*0.4308662,size.height*0.4046794,size.width*0.4347963,size.height*0.4020853,size.width*0.4309000,size.height*0.4001832);
    path_22.cubicTo(size.width*0.4158213,size.height*0.3928034,size.width*0.3925375,size.height*0.3889122,size.width*0.3662537,size.height*0.3879462);
    path_22.cubicTo(size.width*0.3243537,size.height*0.3864046,size.width*0.2850287,size.height*0.3949576,size.width*0.2708575,size.height*0.4082924);
    path_22.lineTo(size.width*0.2708575,size.height*0.4082887);
    path_22.close();

Paint paint_22_fill = Paint()..style=PaintingStyle.fill;
paint_22_fill.color = Color(0xff6C7180).withOpacity(1.0);
canvas.drawPath(path_22,paint_22_fill);

Path glutes1a = Path();
    glutes1a.moveTo(size.width*0.4350762,size.height*0.4131609);
    glutes1a.cubicTo(size.width*0.3516688,size.height*0.4053563,size.width*0.3393662,size.height*0.4397185,size.width*0.2650812,size.height*0.4500000);
    glutes1a.cubicTo(size.width*0.2451788,size.height*0.4527563,size.width*0.2318237,size.height*0.4591218,size.width*0.2318237,size.height*0.4663487);
    glutes1a.lineTo(size.width*0.2318237,size.height*0.4668193);
    glutes1a.cubicTo(size.width*0.2318237,size.height*0.4809664,size.width*0.2659775,size.height*0.4924370,size.width*0.3081000,size.height*0.4924370);
    glutes1a.lineTo(size.width*0.3553400,size.height*0.4924370);
    glutes1a.cubicTo(size.width*0.4087925,size.height*0.4924370,size.width*0.4521363,size.height*0.4778824,size.width*0.4521363,size.height*0.4599286);
    glutes1a.lineTo(size.width*0.4521363,size.height*0.4206513);
    glutes1a.cubicTo(size.width*0.4521363,size.height*0.4171496,size.width*0.4451175,size.height*0.4141004,size.width*0.4350762,size.height*0.4131609);
    glutes1a.close();

Paint paint_23_fill = Paint()..style=PaintingStyle.fill;
paint_23_fill.color = glutes1Color;
canvas.drawPath(glutes1a,paint_23_fill);
_glutes1Path.addPath(glutes1a, Offset.zero);

Path path_24 = Path();
    path_24.moveTo(size.width*0.7212388,size.height*0.4082887);
    path_24.cubicTo(size.width*0.7313475,size.height*0.4177887,size.width*0.7400675,size.height*0.4295714,size.width*0.7502537,size.height*0.4406975);
    path_24.cubicTo(size.width*0.7524812,size.height*0.4431261,size.width*0.7460562,size.height*0.4454916,size.width*0.7387012,size.height*0.4449076);
    path_24.cubicTo(size.width*0.6723650,size.height*0.4396639,size.width*0.6776825,size.height*0.4073071,size.width*0.5680912,size.height*0.4048336);
    path_24.cubicTo(size.width*0.5612300,size.height*0.4046794,size.width*0.5573012,size.height*0.4020853,size.width*0.5611962,size.height*0.4001832);
    path_24.cubicTo(size.width*0.5762750,size.height*0.3928034,size.width*0.5995588,size.height*0.3889122,size.width*0.6258425,size.height*0.3879462);
    path_24.cubicTo(size.width*0.6677425,size.height*0.3864046,size.width*0.7070675,size.height*0.3949576,size.width*0.7212388,size.height*0.4082924);
    path_24.lineTo(size.width*0.7212388,size.height*0.4082887);
    path_24.close();

Paint paint_24_fill = Paint()..style=PaintingStyle.fill;
paint_24_fill.color = Color(0xff6C7180).withOpacity(1.0);
canvas.drawPath(path_24,paint_24_fill);

Path glutes1b = Path();
    glutes1b.moveTo(size.width*0.5570138,size.height*0.4131609);
    glutes1b.cubicTo(size.width*0.6404212,size.height*0.4053563,size.width*0.6527238,size.height*0.4397185,size.width*0.7270075,size.height*0.4500000);
    glutes1b.cubicTo(size.width*0.7469112,size.height*0.4527563,size.width*0.7602650,size.height*0.4591218,size.width*0.7602650,size.height*0.4663487);
    glutes1b.lineTo(size.width*0.7602650,size.height*0.4668193);
    glutes1b.cubicTo(size.width*0.7602650,size.height*0.4809664,size.width*0.7261125,size.height*0.4924370,size.width*0.6839887,size.height*0.4924370);
    glutes1b.lineTo(size.width*0.6367487,size.height*0.4924370);
    glutes1b.cubicTo(size.width*0.5832975,size.height*0.4924370,size.width*0.5399538,size.height*0.4778824,size.width*0.5399538,size.height*0.4599286);
    glutes1b.lineTo(size.width*0.5399538,size.height*0.4206513);
    glutes1b.cubicTo(size.width*0.5399538,size.height*0.4171496,size.width*0.5469725,size.height*0.4141004,size.width*0.5570138,size.height*0.4131609);
    glutes1b.close();

Paint paint_25_fill = Paint()..style=PaintingStyle.fill;
paint_25_fill.color = glutes1Color;
canvas.drawPath(glutes1b,paint_25_fill);
_glutes1Path.addPath(glutes1b, Offset.zero);

Path hamstrings1a = Path();
    hamstrings1a.moveTo(size.width*0.2433413,size.height*0.4994328);
    hamstrings1a.lineTo(size.width*0.3169312,size.height*0.5063151);
    hamstrings1a.cubicTo(size.width*0.3248900,size.height*0.5068235,size.width*0.3306438,size.height*0.5091639,size.width*0.3306100,size.height*0.5118866);
    hamstrings1a.lineTo(size.width*0.3305775,size.height*0.6128908);
    hamstrings1a.cubicTo(size.width*0.3304875,size.height*0.6218235,size.width*0.3208488,size.height*0.6304454,size.width*0.3034425,size.height*0.6371933);
    hamstrings1a.cubicTo(size.width*0.2937600,size.height*0.6409454,size.width*0.2596963,size.height*0.6538697,size.width*0.2558563,size.height*0.6490714);
    hamstrings1a.cubicTo(size.width*0.2232588,size.height*0.6083193,size.width*0.2150313,size.height*0.5398277,size.width*0.2234262,size.height*0.5044958);
    hamstrings1a.cubicTo(size.width*0.2242212,size.height*0.5011555,size.width*0.2335463,size.height*0.4988025,size.width*0.2433413,size.height*0.4994328);
    hamstrings1a.close();

Paint paint_26_fill = Paint()..style=PaintingStyle.fill;
paint_26_fill.color = hamstringsColor;
canvas.drawPath(hamstrings1a,paint_26_fill);
_hamstringsPath.addPath(hamstrings1a, Offset.zero);

Path hamstrings1b = Path();
    hamstrings1b.moveTo(size.width*0.3588200,size.height*0.5070756);
    hamstrings1b.lineTo(size.width*0.4268925,size.height*0.5021471);
    hamstrings1b.cubicTo(size.width*0.4338438,size.height*0.5018571,size.width*0.4404700,size.height*0.5032605,size.width*0.4425863,size.height*0.5055000);
    hamstrings1b.cubicTo(size.width*0.4699888,size.height*0.5345546,size.width*0.4198625,size.height*0.6143109,size.width*0.3821712,size.height*0.6365462);
    hamstrings1b.cubicTo(size.width*0.3777500,size.height*0.6388697,size.width*0.3767762,size.height*0.6389286,size.width*0.3728013,size.height*0.6390798);
    hamstrings1b.lineTo(size.width*0.3663762,size.height*0.6389580);
    hamstrings1b.cubicTo(size.width*0.3600963,size.height*0.6388403,size.width*0.3556413,size.height*0.6263866,size.width*0.3554737,size.height*0.6242773);
    hamstrings1b.lineTo(size.width*0.3460138,size.height*0.5120798);
    hamstrings1b.cubicTo(size.width*0.3458013,size.height*0.5095504,size.width*0.3513538,size.height*0.5073824,size.width*0.3588200,size.height*0.5070756);
    hamstrings1b.close();

Paint paint_27_fill = Paint()..style=PaintingStyle.fill;
paint_27_fill.color = hamstringsColor;
canvas.drawPath(hamstrings1b,paint_27_fill);
_hamstringsPath.addPath(hamstrings1b, Offset.zero);

Path hamstrings2a = Path();
    hamstrings2a.moveTo(size.width*0.7511163,size.height*0.4990378);
    hamstrings2a.lineTo(size.width*0.6764850,size.height*0.5065798);
    hamstrings2a.cubicTo(size.width*0.6685250,size.height*0.5070882,size.width*0.6627713,size.height*0.5094286,size.width*0.6628050,size.height*0.5121513);
    hamstrings2a.lineTo(size.width*0.6638800,size.height*0.6125000);
    hamstrings2a.cubicTo(size.width*0.6639700,size.height*0.6214328,size.width*0.6736075,size.height*0.6300504,size.width*0.6910150,size.height*0.6367983);
    hamstrings2a.cubicTo(size.width*0.7006975,size.height*0.6405504,size.width*0.7347613,size.height*0.6534748,size.width*0.7386012,size.height*0.6486807);
    hamstrings2a.cubicTo(size.width*0.7711988,size.height*0.6079286,size.width*0.7794262,size.height*0.5394328,size.width*0.7710300,size.height*0.5041008);
    hamstrings2a.cubicTo(size.width*0.7702350,size.height*0.5007647,size.width*0.7609113,size.height*0.4984118,size.width*0.7511163,size.height*0.4990378);
    hamstrings2a.close();

Paint paint_28_fill = Paint()..style=PaintingStyle.fill;
paint_28_fill.color = hamstringsColor;
canvas.drawPath(hamstrings2a,paint_28_fill);
_hamstringsPath.addPath(hamstrings2a, Offset.zero);

Path hamstrings2b = Path();
    hamstrings2b.moveTo(size.width*0.6356425,size.height*0.5069496);
    hamstrings2b.lineTo(size.width*0.5675713,size.height*0.5017521);
    hamstrings2b.cubicTo(size.width*0.5606187,size.height*0.5014622,size.width*0.5539925,size.height*0.5028655,size.width*0.5518763,size.height*0.5051050);
    hamstrings2b.cubicTo(size.width*0.5244738,size.height*0.5341639,size.width*0.5746012,size.height*0.6139160,size.width*0.6122912,size.height*0.6361513);
    hamstrings2b.cubicTo(size.width*0.6167125,size.height*0.6384748,size.width*0.6176875,size.height*0.6385378,size.width*0.6216613,size.height*0.6386849);
    hamstrings2b.lineTo(size.width*0.6280862,size.height*0.6385630);
    hamstrings2b.cubicTo(size.width*0.6343663,size.height*0.6384454,size.width*0.6388213,size.height*0.6259916,size.width*0.6389900,size.height*0.6238824);
    hamstrings2b.lineTo(size.width*0.6484488,size.height*0.5119496);
    hamstrings2b.cubicTo(size.width*0.6486612,size.height*0.5094244,size.width*0.6431088,size.height*0.5072563,size.width*0.6356425,size.height*0.5069454);
    hamstrings2b.lineTo(size.width*0.6356425,size.height*0.5069496);
    hamstrings2b.close();

Paint paint_29_fill = Paint()..style=PaintingStyle.fill;
paint_29_fill.color = hamstringsColor;
canvas.drawPath(hamstrings2b,paint_29_fill);
_hamstringsPath.addPath(hamstrings2b, Offset.zero);

Path calves1a = Path();
    calves1a.moveTo(size.width*0.2506912,size.height*0.7199580);
    calves1a.cubicTo(size.width*0.2372125,size.height*0.7210882,size.width*0.2253475,size.height*0.7298445,size.width*0.2140862,size.height*0.7414538);
    calves1a.cubicTo(size.width*0.1971938,size.height*0.7588697,size.width*0.1949437,size.height*0.7775168,size.width*0.2074250,size.height*0.7953487);
    calves1a.lineTo(size.width*0.2234437,size.height*0.8412143);
    calves1a.cubicTo(size.width*0.2277425,size.height*0.8452479,size.width*0.2444338,size.height*0.8456639,size.width*0.2501987,size.height*0.8418403);
    calves1a.cubicTo(size.width*0.2893662,size.height*0.8158782,size.width*0.2807025,size.height*0.7510924,size.width*0.2638550,size.height*0.7229286);
    calves1a.cubicTo(size.width*0.2626350,size.height*0.7208950,size.width*0.2566912,size.height*0.7194580,size.width*0.2507025,size.height*0.7199622);
    calves1a.lineTo(size.width*0.2506912,size.height*0.7199580);
    calves1a.close();

Paint paint_30_fill = Paint()..style=PaintingStyle.fill;
paint_30_fill.color = calvesColor;
canvas.drawPath(calves1a,paint_30_fill);
_calvesPath.addPath(calves1a, Offset.zero);

Path calves1b = Path();
    calves1b.moveTo(size.width*0.3122750,size.height*0.7202983);
    calves1b.cubicTo(size.width*0.2885313,size.height*0.7214832,size.width*0.2962000,size.height*0.7574622,size.width*0.3013037,size.height*0.7748193);
    calves1b.cubicTo(size.width*0.3031963,size.height*0.7812479,size.width*0.3030725,size.height*0.7877227,size.width*0.3009350,size.height*0.7941429);
    calves1b.lineTo(size.width*0.2827325,size.height*0.8488908);
    calves1b.cubicTo(size.width*0.2816250,size.height*0.8522311,size.width*0.2945313,size.height*0.8538571,size.width*0.3002525,size.height*0.8510966);
    calves1b.lineTo(size.width*0.3099688,size.height*0.8463992);
    calves1b.cubicTo(size.width*0.3319762,size.height*0.8357605,size.width*0.3461250,size.height*0.8235126,size.width*0.3512525,size.height*0.8106723);
    calves1b.lineTo(size.width*0.3684462,size.height*0.7676218);
    calves1b.cubicTo(size.width*0.3709650,size.height*0.7613193,size.width*0.3694200,size.height*0.7549160,size.width*0.3639013,size.height*0.7488403);
    calves1b.cubicTo(size.width*0.3532562,size.height*0.7371218,size.width*0.3334312,size.height*0.7192479,size.width*0.3122750,size.height*0.7202983);
    calves1b.close();

Paint paint_31_fill = Paint()..style=PaintingStyle.fill;
paint_31_fill.color = calvesColor;
canvas.drawPath(calves1b,paint_31_fill);
_calvesPath.addPath(calves1b, Offset.zero);

Path calves2a = Path();
    calves2a.moveTo(size.width*0.7571562,size.height*0.7199580);
    calves2a.cubicTo(size.width*0.7706350,size.height*0.7210882,size.width*0.7825000,size.height*0.7298445,size.width*0.7937612,size.height*0.7414538);
    calves2a.cubicTo(size.width*0.8106537,size.height*0.7588697,size.width*0.8129038,size.height*0.7775168,size.width*0.8004225,size.height*0.7953487);
    calves2a.lineTo(size.width*0.7844037,size.height*0.8412143);
    calves2a.cubicTo(size.width*0.7801050,size.height*0.8452479,size.width*0.7634138,size.height*0.8456639,size.width*0.7576487,size.height*0.8418403);
    calves2a.cubicTo(size.width*0.7184812,size.height*0.8158782,size.width*0.7271450,size.height*0.7510924,size.width*0.7439925,size.height*0.7229286);
    calves2a.cubicTo(size.width*0.7452125,size.height*0.7208950,size.width*0.7511562,size.height*0.7194580,size.width*0.7571450,size.height*0.7199622);
    calves2a.lineTo(size.width*0.7571562,size.height*0.7199580);
    calves2a.close();

Paint paint_32_fill = Paint()..style=PaintingStyle.fill;
paint_32_fill.color = calvesColor;
canvas.drawPath(calves2a,paint_32_fill);
_calvesPath.addPath(calves2a, Offset.zero);

Path calves2b = Path();
    calves2b.moveTo(size.width*0.6955537,size.height*0.7202983);
    calves2b.cubicTo(size.width*0.7192962,size.height*0.7214832,size.width*0.7116288,size.height*0.7574622,size.width*0.7065238,size.height*0.7748193);
    calves2b.cubicTo(size.width*0.7046325,size.height*0.7812479,size.width*0.7047550,size.height*0.7877227,size.width*0.7068937,size.height*0.7941429);
    calves2b.lineTo(size.width*0.7250950,size.height*0.8488908);
    calves2b.cubicTo(size.width*0.7262038,size.height*0.8522311,size.width*0.7132962,size.height*0.8538571,size.width*0.7075763,size.height*0.8510966);
    calves2b.lineTo(size.width*0.6978600,size.height*0.8463992);
    calves2b.cubicTo(size.width*0.6758525,size.height*0.8357605,size.width*0.6617025,size.height*0.8235126,size.width*0.6565762,size.height*0.8106723);
    calves2b.lineTo(size.width*0.6393813,size.height*0.7676218);
    calves2b.cubicTo(size.width*0.6368625,size.height*0.7613193,size.width*0.6384075,size.height*0.7549160,size.width*0.6439263,size.height*0.7488403);
    calves2b.cubicTo(size.width*0.6545725,size.height*0.7371218,size.width*0.6743963,size.height*0.7192479,size.width*0.6955537,size.height*0.7202983);
    calves2b.close();

Paint paint_33_fill = Paint()..style=PaintingStyle.fill;
paint_33_fill.color = calvesColor;
canvas.drawPath(calves2b,paint_33_fill);
_calvesPath.addPath(calves2b, Offset.zero);

Path triceps1 = Path();
    triceps1.moveTo(size.width*0.8381887,size.height*0.2684555);
    triceps1.cubicTo(size.width*0.7829012,size.height*0.2917412,size.width*0.8059500,size.height*0.3158807,size.width*0.8264800,size.height*0.3424303);
    triceps1.cubicTo(size.width*0.8277337,size.height*0.3440542,size.width*0.8347300,size.height*0.3439227,size.width*0.8354463,size.height*0.3422647);
    triceps1.lineTo(size.width*0.8458562,size.height*0.3182454);
    triceps1.cubicTo(size.width*0.8464725,size.height*0.3168319,size.width*0.8519800,size.height*0.3164374,size.width*0.8542637,size.height*0.3176403);
    triceps1.lineTo(size.width*0.8970588,size.height*0.3402647);
    triceps1.cubicTo(size.width*0.8993313,size.height*0.3414676,size.width*0.9048388,size.height*0.3410731,size.width*0.9054763,size.height*0.3396630);
    triceps1.cubicTo(size.width*0.9217525,size.height*0.3037151,size.width*0.9081413,size.height*0.2775345,size.width*0.8436063,size.height*0.2680004);
    triceps1.cubicTo(size.width*0.8417263,size.height*0.2677223,size.width*0.8394650,size.height*0.2679139,size.width*0.8381887,size.height*0.2684555);
    triceps1.close();

Paint paint_34_fill = Paint()..style=PaintingStyle.fill;
paint_34_fill.color = tricepsColor;
canvas.drawPath(triceps1,paint_34_fill);
_tricepsPath.addPath(triceps1, Offset.zero);

Path triceps2 = Path();
    triceps2.moveTo(size.width*0.1526475,size.height*0.2686013);
    triceps2.cubicTo(size.width*0.2066475,size.height*0.2914849,size.width*0.1851775,size.height*0.3151996,size.width*0.1649500,size.height*0.3412151);
    triceps2.cubicTo(size.width*0.1634837,size.height*0.3431059,size.width*0.1553450,size.height*0.3429559,size.width*0.1545063,size.height*0.3410235);
    triceps2.lineTo(size.width*0.1449237,size.height*0.3189139);
    triceps2.cubicTo(size.width*0.1442075,size.height*0.3172672,size.width*0.1377925,size.height*0.3168088,size.width*0.1351400,size.height*0.3182109);
    triceps2.lineTo(size.width*0.09451637,size.height*0.3396887);
    triceps2.cubicTo(size.width*0.09187450,size.height*0.3410874,size.width*0.08544913,size.height*0.3406286,size.width*0.08472150,size.height*0.3389895);
    triceps2.cubicTo(size.width*0.06896013,size.height*0.3034815,size.width*0.08268412,size.height*0.2776088,size.width*0.1463788,size.height*0.2680710);
    triceps2.cubicTo(size.width*0.1485613,size.height*0.2677441,size.width*0.1511700,size.height*0.2679697,size.width*0.1526588,size.height*0.2685975);
    triceps2.lineTo(size.width*0.1526475,size.height*0.2686013);
    triceps2.close();

Paint paint_35_fill = Paint()..style=PaintingStyle.fill;
paint_35_fill.color = tricepsColor;
canvas.drawPath(triceps2,paint_35_fill);
_tricepsPath.addPath(triceps2, Offset.zero);

Path path_36 = Path();
    path_36.moveTo(size.width*0.05442512,size.height*0.3760261);
    path_36.cubicTo(size.width*0.09641437,size.height*0.3999626,size.width*0.07326487,size.height*0.4499622,size.width*0.05061913,size.height*0.4841723);
    path_36.cubicTo(size.width*0.04964525,size.height*0.4856429,size.width*0.04321975,size.height*0.4854706,size.width*0.04295112,size.height*0.4839664);
    path_36.cubicTo(size.width*0.03833913,size.height*0.4584958,size.width*0.04941012,size.height*0.4320714,size.width*0.03013387,size.height*0.4010752);
    path_36.cubicTo(size.width*0.02845475,size.height*0.3983798,size.width*0.02863375,size.height*0.3955903,size.width*0.03062638,size.height*0.3929172);
    path_36.lineTo(size.width*0.04278325,size.height*0.3765824);
    path_36.cubicTo(size.width*0.04416013,size.height*0.3747290,size.width*0.05153700,size.height*0.3743794,size.width*0.05442512,size.height*0.3760223);
    path_36.lineTo(size.width*0.05442512,size.height*0.3760261);
    path_36.close();

Paint paint_36_fill = Paint()..style=PaintingStyle.fill;
paint_36_fill.color = Color(0xff6C7180).withOpacity(1.0);
canvas.drawPath(path_36,paint_36_fill);

Path path_37 = Path();
    path_37.moveTo(size.width*0.1735800,size.height*0.3845580);
    path_37.cubicTo(size.width*0.1634837,size.height*0.3858513,size.width*0.1537562,size.height*0.3877046,size.width*0.1443975,size.height*0.3901672);
    path_37.cubicTo(size.width*0.1246623,size.height*0.3953626,size.width*0.1115203,size.height*0.4028777,size.width*0.1068411,size.height*0.4111487);
    path_37.lineTo(size.width*0.07107587,size.height*0.4744244);
    path_37.cubicTo(size.width*0.06842288,size.height*0.4791261,size.width*0.06889300,size.height*0.4839706,size.width*0.07247513,size.height*0.4886050);
    path_37.lineTo(size.width*0.07798262,size.height*0.4957437);
    path_37.cubicTo(size.width*0.07887812,size.height*0.4969076,size.width*0.08390438,size.height*0.4967815,size.width*0.08428488,size.height*0.4955840);
    path_37.lineTo(size.width*0.08946788,size.height*0.4792185);
    path_37.cubicTo(size.width*0.09195288,size.height*0.4713824,size.width*0.09898287,size.height*0.4637815,size.width*0.1101210,size.height*0.4568487);
    path_37.cubicTo(size.width*0.1586250,size.height*0.4266807,size.width*0.1756288,size.height*0.4034983,size.width*0.1735700,size.height*0.3845542);
    path_37.lineTo(size.width*0.1735800,size.height*0.3845580);
    path_37.close();

Paint paint_37_fill = Paint()..style=PaintingStyle.fill;
paint_37_fill.color = Color(0xff6C7180).withOpacity(1.0);
canvas.drawPath(path_37,paint_37_fill);

Path path_38 = Path();
    path_38.moveTo(size.width*0.9392425,size.height*0.3760261);
    path_38.cubicTo(size.width*0.8972537,size.height*0.3999626,size.width*0.9204025,size.height*0.4499622,size.width*0.9430487,size.height*0.4841723);
    path_38.cubicTo(size.width*0.9440225,size.height*0.4856429,size.width*0.9504475,size.height*0.4854706,size.width*0.9507162,size.height*0.4839664);
    path_38.cubicTo(size.width*0.9553287,size.height*0.4584958,size.width*0.9442575,size.height*0.4320714,size.width*0.9635338,size.height*0.4010752);
    path_38.cubicTo(size.width*0.9652125,size.height*0.3983798,size.width*0.9650337,size.height*0.3955903,size.width*0.9630413,size.height*0.3929172);
    path_38.lineTo(size.width*0.9508838,size.height*0.3765824);
    path_38.cubicTo(size.width*0.9495075,size.height*0.3747290,size.width*0.9421300,size.height*0.3743794,size.width*0.9392425,size.height*0.3760223);
    path_38.lineTo(size.width*0.9392425,size.height*0.3760261);
    path_38.close();

Paint paint_38_fill = Paint()..style=PaintingStyle.fill;
paint_38_fill.color = Color(0xff6C7180).withOpacity(1.0);
canvas.drawPath(path_38,paint_38_fill);

Path path_39 = Path();
    path_39.moveTo(size.width*0.8200762,size.height*0.3845580);
    path_39.cubicTo(size.width*0.8301725,size.height*0.3858513,size.width*0.8399000,size.height*0.3877046,size.width*0.8492588,size.height*0.3901672);
    path_39.cubicTo(size.width*0.8689937,size.height*0.3953626,size.width*0.8821362,size.height*0.4028777,size.width*0.8868150,size.height*0.4111487);
    path_39.lineTo(size.width*0.9225800,size.height*0.4744244);
    path_39.cubicTo(size.width*0.9252337,size.height*0.4791261,size.width*0.9247637,size.height*0.4839706,size.width*0.9211813,size.height*0.4886050);
    path_39.lineTo(size.width*0.9156738,size.height*0.4957437);
    path_39.cubicTo(size.width*0.9147787,size.height*0.4969076,size.width*0.9097525,size.height*0.4967815,size.width*0.9093713,size.height*0.4955840);
    path_39.lineTo(size.width*0.9041887,size.height*0.4792185);
    path_39.cubicTo(size.width*0.9017038,size.height*0.4713824,size.width*0.8946737,size.height*0.4637815,size.width*0.8835350,size.height*0.4568487);
    path_39.cubicTo(size.width*0.8350312,size.height*0.4266807,size.width*0.8180275,size.height*0.4034983,size.width*0.8200862,size.height*0.3845542);
    path_39.lineTo(size.width*0.8200762,size.height*0.3845580);
    path_39.close();

Paint paint_39_fill = Paint()..style=PaintingStyle.fill;
paint_39_fill.color = Color(0xff6C7180).withOpacity(1.0);
canvas.drawPath(path_39,paint_39_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
}
}