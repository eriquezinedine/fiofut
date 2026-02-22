import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';


class RPSFrontCustomPainter extends CustomPainter {
  final Color chest1Color;
  final Color chest2Color;
  final Color absColor;
  final Color bicep1Color;
  final Color bicep2Color;
  final Color obliques1Color;
  final Color obliques2Color;
  final Color forearms1Color;
  final Color forearms2Color;
  final Color quadriceps2Color;
  final Color quadriceps1Color;
  final Color adductors1Color;
  final Color adductors2Color;
  final Color abductors1Color;
  final Color abductors2Color;
  final Color lateralDeltoid1Color;
  final Color lateralDeltoid2Color;
  final Color frontDeltoid1Color;
  final Color frontDeltoid2Color;

  RPSFrontCustomPainter({
    this.chest1Color =  AppColors.muscleDefaultColor,
    this.chest2Color =  AppColors.muscleDefaultColor,
    this.absColor = AppColors.muscleDefaultColor,
    this.bicep1Color = AppColors.muscleDefaultColor,
    this.bicep2Color = AppColors.muscleDefaultColor,
    this.obliques1Color = AppColors.muscleDefaultColor,
    this.obliques2Color = AppColors.muscleDefaultColor,
    this.forearms1Color = AppColors.muscleDefaultColor,
    this.forearms2Color = AppColors.muscleDefaultColor,
    this.quadriceps2Color = AppColors.muscleDefaultColor,
    this.quadriceps1Color = AppColors.muscleDefaultColor,
    this.adductors1Color = AppColors.muscleDefaultColor,
    this.adductors2Color = AppColors.muscleDefaultColor,
    this.abductors1Color = AppColors.muscleDefaultColor,
    this.abductors2Color = AppColors.muscleDefaultColor,
    this.lateralDeltoid1Color = AppColors.muscleDefaultColor,
    this.lateralDeltoid2Color = AppColors.muscleDefaultColor,
    this.frontDeltoid1Color = AppColors.muscleDefaultColor,
    this.frontDeltoid2Color = AppColors.muscleDefaultColor,
  });

  Path _chest1Path = Path();
  Path _chest2Path = Path();
  Path _absPath = Path();
  Path _bicep1Path = Path();
  Path _bicep2Path = Path();
  Path _obliques1Path = Path();
  Path _obliques2Path = Path();
  Path _forearms1Path = Path();
  Path _forearms2Path = Path();
  Path _quadriceps2Path = Path();
  Path _quadriceps1Path = Path();
  Path _adductors1Path = Path();
  Path _adductors2Path = Path();
  Path _abductors1Path = Path();
  Path _abductors2Path = Path();
  Path _lateralDeltoid1Path = Path();
  Path _lateralDeltoid2Path = Path();
  Path _frontDeltoid1Path = Path();
  Path _frontDeltoid2Path = Path();

  String? hitTestMuscle(Offset position) {
    if (_chest1Path.contains(position)) return 'chest1';
    if (_chest2Path.contains(position)) return 'chest2';
    if (_absPath.contains(position)) return 'abs';
    if (_bicep1Path.contains(position)) return 'bicep1';
    if (_bicep2Path.contains(position)) return 'bicep2';
    if (_obliques1Path.contains(position)) return 'obliques1';
    if (_obliques2Path.contains(position)) return 'obliques2';
    if (_forearms1Path.contains(position)) return 'forearms1';
    if (_forearms2Path.contains(position)) return 'forearms2';
    if (_quadriceps2Path.contains(position)) return 'quadriceps2';
    if (_quadriceps1Path.contains(position)) return 'quadriceps1';
    if (_adductors1Path.contains(position)) return 'adductors1';
    if (_adductors2Path.contains(position)) return 'adductors2';
    if (_abductors1Path.contains(position)) return 'abductors1';
    if (_abductors2Path.contains(position)) return 'abductors2';
    if (_lateralDeltoid1Path.contains(position)) return 'lateralDeltoid1';
    if (_lateralDeltoid2Path.contains(position)) return 'lateralDeltoid2';
    if (_frontDeltoid1Path.contains(position)) return 'frontDeltoid1';
    if (_frontDeltoid2Path.contains(position)) return 'frontDeltoid2';
    return null;
  }

    @override
    void paint(Canvas canvas, Size size) {
            
Path path_0 = Path();
    path_0.moveTo(size.width*0.6022663,size.height*0.08634748);
    path_0.cubicTo(size.width*0.6274875,size.height*0.07767269,size.width*0.6444237,size.height*0.05882563,size.width*0.6179613,size.height*0.05523529);
    path_0.cubicTo(size.width*0.6135725,size.height*0.05464076,size.width*0.6108975,size.height*0.05315798,size.width*0.6117813,size.height*0.05159622);
    path_0.cubicTo(size.width*0.6495625,size.height*-0.01561479,size.width*0.3383762,size.height*-0.01882500,size.width*0.3671900,size.height*0.05176555);
    path_0.cubicTo(size.width*0.3678050,size.height*0.05326723,size.width*0.3651862,size.height*0.05467437,size.width*0.3609775,size.height*0.05521639);
    path_0.cubicTo(size.width*0.3333500,size.height*0.05877647,size.width*0.3515288,size.height*0.07706303,size.width*0.3779812,size.height*0.08656933);
    path_0.cubicTo(size.width*0.3850775,size.height*0.08912101,size.width*0.3906525,size.height*0.09210168,size.width*0.3950075,size.height*0.09527059);
    path_0.cubicTo(size.width*0.4091337,size.height*0.1055408,size.width*0.4432537,size.height*0.1261643,size.width*0.4901237,size.height*0.1267891);
    path_0.cubicTo(size.width*0.5346200,size.height*0.1273836,size.width*0.5663563,size.height*0.1082618,size.width*0.5809412,size.height*0.09719748);
    path_0.cubicTo(size.width*0.5862025,size.height*0.09320420,size.width*0.5931663,size.height*0.08946345,size.width*0.6022550,size.height*0.08633992);
    path_0.lineTo(size.width*0.6022663,size.height*0.08634748);
    path_0.close();

Paint paint_0_fill = Paint()..style=PaintingStyle.fill;
paint_0_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_0,paint_0_fill);

Path path_1 = Path();
    path_1.moveTo(size.width*0.6025413,size.height*0.4917647);
    path_1.lineTo(size.width*0.7215350,size.height*0.4331471);
    path_1.cubicTo(size.width*0.7383038,size.height*0.4253908,size.width*0.7450425,size.height*0.4156920,size.width*0.7402513,size.height*0.4062458);
    path_1.lineTo(size.width*0.7257775,size.height*0.3777756);
    path_1.cubicTo(size.width*0.7226537,size.height*0.3716261,size.width*0.7235613,size.height*0.3653227,size.width*0.7284525,size.height*0.3593084);
    path_1.cubicTo(size.width*0.7490725,size.height*0.3445223,size.width*0.7656837,size.height*0.3296340,size.width*0.7649013,size.height*0.3142567);
    path_1.cubicTo(size.width*0.7704300,size.height*0.2830391,size.width*0.7934012,size.height*0.2690845,size.width*0.8138637,size.height*0.2580878);
    path_1.cubicTo(size.width*0.8191475,size.height*0.2552424,size.width*0.8300500,size.height*0.2542378,size.width*0.8389387,size.height*0.2557546);
    path_1.lineTo(size.width*0.9303725,size.height*0.2736496);
    path_1.cubicTo(size.width*0.9312788,size.height*0.2717113,size.width*0.9326113,size.height*0.2645723,size.width*0.9333612,size.height*0.2627055);
    path_1.cubicTo(size.width*0.9618275,size.height*0.1920361,size.width*0.8728462,size.height*0.1693462,size.width*0.6914900,size.height*0.1844151);
    path_1.lineTo(size.width*0.6852650,size.height*0.1847387);
    path_1.lineTo(size.width*0.6586688,size.height*0.1861050);
    path_1.lineTo(size.width*0.5388350,size.height*0.1922353);
    path_1.cubicTo(size.width*0.5186188,size.height*0.1932668,size.width*0.5037413,size.height*0.1991412,size.width*0.5038975,size.height*0.2060097);
    path_1.lineTo(size.width*0.5053650,size.height*0.2685424);
    path_1.lineTo(size.width*0.5056775,size.height*0.2781315);
    path_1.cubicTo(size.width*0.5496937,size.height*0.2803408,size.width*0.5921075,size.height*0.2819441,size.width*0.6245825,size.height*0.2851580);
    path_1.cubicTo(size.width*0.6359325,size.height*0.2862794,size.width*0.6443400,size.height*0.2893429,size.width*0.6471500,size.height*0.2930685);
    path_1.cubicTo(size.width*0.6479225,size.height*0.2940471,size.width*0.6482687,size.height*0.2950710,size.width*0.6481900,size.height*0.2961210);
    path_1.cubicTo(size.width*0.6472837,size.height*0.3082765,size.width*0.6447200,size.height*0.3195782,size.width*0.6410600,size.height*0.3356290);
    path_1.cubicTo(size.width*0.6400413,size.height*0.3400550,size.width*0.6389550,size.height*0.3445975,size.width*0.6377800,size.height*0.3492492);
    path_1.cubicTo(size.width*0.6353287,size.height*0.3590714,size.width*0.6325412,size.height*0.3693605,size.width*0.6295300,size.height*0.3799471);
    path_1.cubicTo(size.width*0.6279850,size.height*0.3854794,size.width*0.6263513,size.height*0.3910983,size.width*0.6246937,size.height*0.3967811);
    path_1.cubicTo(size.width*0.6190638,size.height*0.4160046,size.width*0.6129175,size.height*0.4359160,size.width*0.6069062,size.height*0.4556513);
    path_1.cubicTo(size.width*0.6067950,size.height*0.4559748,size.width*0.6067163,size.height*0.4562899,size.width*0.6066150,size.height*0.4566134);
    path_1.cubicTo(size.width*0.6066150,size.height*0.4566134,size.width*0.5944925,size.height*0.5082899,size.width*0.4936000,size.height*0.5075924);
    path_1.cubicTo(size.width*0.4023675,size.height*0.5069538,size.width*0.3860800,size.height*0.4642059,size.width*0.3837850,size.height*0.4560378);
    path_1.cubicTo(size.width*0.3835387,size.height*0.4551681,size.width*0.3834600,size.height*0.4546891,size.width*0.3834600,size.height*0.4546891);
    path_1.lineTo(size.width*0.3673850,size.height*0.3989601);
    path_1.lineTo(size.width*0.3618887,size.height*0.3798908);
    path_1.lineTo(size.width*0.3534262,size.height*0.3504761);
    path_1.lineTo(size.width*0.3492288,size.height*0.3359752);
    path_1.lineTo(size.width*0.3373737,size.height*0.2980815);
    path_1.cubicTo(size.width*0.3368363,size.height*0.2961773,size.width*0.3376650,size.height*0.2943294,size.width*0.3396688,size.height*0.2926395);
    path_1.cubicTo(size.width*0.3433850,size.height*0.2894786,size.width*0.3511538,size.height*0.2869193,size.width*0.3612738,size.height*0.2858353);
    path_1.cubicTo(size.width*0.3930537,size.height*0.2824143,size.width*0.4352450,size.height*0.2804987,size.width*0.4809050,size.height*0.2781282);
    path_1.lineTo(size.width*0.4807263,size.height*0.2049824);
    path_1.cubicTo(size.width*0.4807263,size.height*0.1983361,size.width*0.4661400,size.height*0.1927172,size.width*0.4465725,size.height*0.1918214);
    path_1.lineTo(size.width*0.3313400,size.height*0.1865076);
    path_1.lineTo(size.width*0.3017762,size.height*0.1851416);
    path_1.lineTo(size.width*0.2038500,size.height*0.1806252);
    path_1.cubicTo(size.width*0.1229839,size.height*0.1768996,size.width*0.05140850,size.height*0.1983849,size.width*0.05333387,size.height*0.2258126);
    path_1.lineTo(size.width*0.05335625,size.height*0.2595555);
    path_1.lineTo(size.width*0.05543837,size.height*0.2796748);
    path_1.cubicTo(size.width*0.05543837,size.height*0.2796748,size.width*0.1439500,size.height*0.2520962,size.width*0.1705812,size.height*0.2562059);
    path_1.cubicTo(size.width*0.1941337,size.height*0.2598416,size.width*0.2257238,size.height*0.2874046,size.width*0.2286000,size.height*0.2944874);
    path_1.cubicTo(size.width*0.2314888,size.height*0.3015626,size.width*0.2361562,size.height*0.3183777,size.width*0.2401413,size.height*0.3269433);
    path_1.cubicTo(size.width*0.2444175,size.height*0.3361450,size.width*0.2662912,size.height*0.3539945,size.width*0.2690113,size.height*0.3694021);
    path_1.cubicTo(size.width*0.2710712,size.height*0.3809105,size.width*0.2583550,size.height*0.4073975,size.width*0.2517838,size.height*0.4200840);
    path_1.cubicTo(size.width*0.2494887,size.height*0.4245756,size.width*0.2531937,size.height*0.4291597,size.width*0.2619588,size.height*0.4326345);
    path_1.lineTo(size.width*0.3540425,size.height*0.4747269);
    path_1.cubicTo(size.width*0.3669713,size.height*0.4798529,size.width*0.3763850,size.height*0.4843992,size.width*0.3894050,size.height*0.4921639);
    path_1.cubicTo(size.width*0.3894050,size.height*0.4921639,size.width*0.4295013,size.height*0.5182395,size.width*0.4918312,size.height*0.5182395);
    path_1.cubicTo(size.width*0.5541600,size.height*0.5182395,size.width*0.6025525,size.height*0.4917689,size.width*0.6025525,size.height*0.4917689);
    path_1.lineTo(size.width*0.6025413,size.height*0.4917647);
    path_1.close();
    path_1.moveTo(size.width*0.2626975,size.height*0.3319861);
    path_1.cubicTo(size.width*0.2626425,size.height*0.3314555,size.width*0.2633700,size.height*0.3310076,size.width*0.2644887,size.height*0.3307290);
    path_1.cubicTo(size.width*0.2635600,size.height*0.3310076,size.width*0.2630787,size.height*0.3314744,size.width*0.2626975,size.height*0.3319861);
    path_1.close();
    path_1.moveTo(size.width*0.2659550,size.height*0.3304769);
    path_1.cubicTo(size.width*0.2671863,size.height*0.3303416,size.width*0.2686312,size.height*0.3303866,size.width*0.2698850,size.height*0.3306840);
    path_1.cubicTo(size.width*0.2682050,size.height*0.3304584,size.width*0.2669513,size.height*0.3304055,size.width*0.2659550,size.height*0.3304769);
    path_1.close();

Paint paint_1_fill = Paint()..style=PaintingStyle.fill;
paint_1_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_1,paint_1_fill);

Path abs8 = Path();
    abs8.moveTo(size.width*0.4645875,size.height*0.2868387);
    abs8.cubicTo(size.width*0.4710075,size.height*0.2864550,size.width*0.4768912,size.height*0.2881139,size.width*0.4768925,size.height*0.2903059);
    abs8.lineTo(size.width*0.4768925,size.height*0.3160122);
    abs8.cubicTo(size.width*0.4768900,size.height*0.3191492,size.width*0.4695812,size.height*0.3217324,size.width*0.4602787,size.height*0.3218924);
    abs8.lineTo(size.width*0.3882937,size.height*0.3231353);
    abs8.cubicTo(size.width*0.3802400,size.height*0.3232739,size.width*0.3733812,size.height*0.3211815,size.width*0.3729975,size.height*0.3184702);
    abs8.lineTo(size.width*0.3696538,size.height*0.2947332);
    abs8.lineTo(size.width*0.3696413,size.height*0.2946840);
    abs8.cubicTo(size.width*0.3695363,size.height*0.2934592,size.width*0.3721200,size.height*0.2923853,size.width*0.3757325,size.height*0.2921685);
    abs8.lineTo(size.width*0.4645875,size.height*0.2868387);
    abs8.close();

Paint paint_2_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01437200;
paint_2_stroke.color=absColor;
canvas.drawPath(abs8,paint_2_stroke);

Paint paint_2_fill = Paint()..style=PaintingStyle.fill;
paint_2_fill.color = absColor;
canvas.drawPath(abs8,paint_2_fill);

Path abs7 = Path();
    abs7.moveTo(size.width*0.4636838,size.height*0.3351189);
    abs7.cubicTo(size.width*0.4707763,size.height*0.3348739,size.width*0.4769275,size.height*0.3367408,size.width*0.4769288,size.height*0.3391361);
    abs7.lineTo(size.width*0.4769288,size.height*0.3622655);
    abs7.cubicTo(size.width*0.4769288,size.height*0.3652445,size.width*0.4699788,size.height*0.3676983,size.width*0.4611325,size.height*0.3678462);
    abs7.lineTo(size.width*0.4007325,size.height*0.3688471);
    abs7.cubicTo(size.width*0.3914238,size.height*0.3690000,size.width*0.3834437,size.height*0.3666391,size.width*0.3827150,size.height*0.3635130);
    abs7.lineTo(size.width*0.3776363,size.height*0.3416021);
    abs7.lineTo(size.width*0.3776125,size.height*0.3415239);
    abs7.cubicTo(size.width*0.3772950,size.height*0.3396231,size.width*0.3814800,size.height*0.3379693,size.width*0.3871212,size.height*0.3377735);
    abs7.lineTo(size.width*0.3871337,size.height*0.3377735);
    abs7.lineTo(size.width*0.4636838,size.height*0.3351189);
    abs7.close();

Paint paint_3_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01437200;
paint_3_stroke.color=absColor;
canvas.drawPath(abs7,paint_3_stroke);

Paint paint_3_fill = Paint()..style=PaintingStyle.fill;
paint_3_fill.color = absColor;
canvas.drawPath(abs7,paint_3_fill);

Path abs6 = Path();
    abs6.moveTo(size.width*0.4633550,size.height*0.3790408);
    abs6.cubicTo(size.width*0.4706025,size.height*0.3787479,size.width*0.4770950,size.height*0.3806622,size.width*0.4771725,size.height*0.3831357);
    abs6.lineTo(size.width*0.4771725,size.height*0.3831399);
    abs6.lineTo(size.width*0.4786738,size.height*0.4208739);
    abs6.cubicTo(size.width*0.4787425,size.height*0.4225630,size.width*0.4746775,size.height*0.4239496,size.width*0.4696537,size.height*0.4239496);
    abs6.lineTo(size.width*0.4029537,size.height*0.4239496);
    abs6.cubicTo(size.width*0.4014050,size.height*0.4207479,size.width*0.3998100,size.height*0.4156727,size.width*0.3982050,size.height*0.4095765);
    abs6.cubicTo(size.width*0.3962512,size.height*0.4021538,size.width*0.3943062,size.height*0.3934462,size.width*0.3922850,size.height*0.3851584);
    abs6.lineTo(size.width*0.3922850,size.height*0.3851378);
    abs6.lineTo(size.width*0.3922487,size.height*0.3848218);
    abs6.cubicTo(size.width*0.3923025,size.height*0.3832420,size.width*0.3958900,size.height*0.3818429,size.width*0.4007562,size.height*0.3816340);
    abs6.lineTo(size.width*0.4633662,size.height*0.3790445);
    abs6.lineTo(size.width*0.4633550,size.height*0.3790408);
    abs6.close();

Paint paint_4_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01437200;
paint_4_stroke.color=absColor;
canvas.drawPath(abs6,paint_4_stroke);

Paint paint_4_fill = Paint()..style=PaintingStyle.fill;
paint_4_fill.color = absColor;
canvas.drawPath(abs6,paint_4_fill);

Path abs5 = Path();
    abs5.moveTo(size.width*0.4686763,size.height*0.4350840);
    abs5.cubicTo(size.width*0.4744025,size.height*0.4350840,size.width*0.4790650,size.height*0.4366345,size.width*0.4791388,size.height*0.4385588);
    abs5.lineTo(size.width*0.4812250,size.height*0.4928824);
    abs5.lineTo(size.width*0.4812250,size.height*0.4928866);
    abs5.cubicTo(size.width*0.4812800,size.height*0.4943109,size.width*0.4777637,size.height*0.4954034,size.width*0.4738525,size.height*0.4953151);
    abs5.cubicTo(size.width*0.4643287,size.height*0.4950756,size.width*0.4564762,size.height*0.4939370,size.width*0.4496100,size.height*0.4917311);
    abs5.cubicTo(size.width*0.4425725,size.height*0.4894706,size.width*0.4362725,size.height*0.4859958,size.width*0.4306275,size.height*0.4809538);
    abs5.cubicTo(size.width*0.4197387,size.height*0.4712311,size.width*0.4120638,size.height*0.4563655,size.width*0.4050413,size.height*0.4350840);
    abs5.lineTo(size.width*0.4686763,size.height*0.4350840);
    abs5.close();

Paint paint_5_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01437200;
paint_5_stroke.color=absColor;
canvas.drawPath(abs5,paint_5_stroke);

Paint paint_5_fill = Paint()..style=PaintingStyle.fill;
paint_5_fill.color = absColor;
canvas.drawPath(abs5,paint_5_fill);

Path abs4 = Path();
    abs4.moveTo(size.width*0.5176762,size.height*0.3797042);
    abs4.lineTo(size.width*0.5176762,size.height*0.3797084);
    abs4.lineTo(size.width*0.5833012,size.height*0.3828475);
    abs4.lineTo(size.width*0.5833250,size.height*0.3828475);
    abs4.cubicTo(size.width*0.5911363,size.height*0.3832080,size.width*0.5968138,size.height*0.3855038,size.width*0.5964963,size.height*0.3881282);
    abs4.lineTo(size.width*0.5964600,size.height*0.3883294);
    abs4.cubicTo(size.width*0.5947912,size.height*0.3961307,size.width*0.5930175,size.height*0.4042349,size.width*0.5911250,size.height*0.4110529);
    abs4.cubicTo(size.width*0.5895913,size.height*0.4165832,size.width*0.5879988,size.height*0.4211134,size.width*0.5864375,size.height*0.4239496);
    abs4.lineTo(size.width*0.5163813,size.height*0.4239496);
    abs4.cubicTo(size.width*0.5120838,size.height*0.4239496,size.width*0.5086062,size.height*0.4227773,size.width*0.5086062,size.height*0.4213319);
    abs4.lineTo(size.width*0.5086062,size.height*0.3823878);
    abs4.cubicTo(size.width*0.5086075,size.height*0.3807508,size.width*0.5129337,size.height*0.3794878,size.width*0.5176762,size.height*0.3797042);
    abs4.close();

Paint paint_6_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01437200;
paint_6_stroke.color=absColor;
canvas.drawPath(abs4,paint_6_stroke);

Paint paint_6_fill = Paint()..style=PaintingStyle.fill;
paint_6_fill.color = absColor;
canvas.drawPath(abs4,paint_6_fill);

Path abs3 = Path();
    abs3.moveTo(size.width*0.5173337,size.height*0.4350840);
    abs3.lineTo(size.width*0.5840825,size.height*0.4350840);
    abs3.cubicTo(size.width*0.5734450,size.height*0.4629958,size.width*0.5604237,size.height*0.4793866,size.width*0.5462162,size.height*0.4879496);
    abs3.cubicTo(size.width*0.5389213,size.height*0.4923487,size.width*0.5319162,size.height*0.4943151,size.width*0.5258175,size.height*0.4949916);
    abs3.cubicTo(size.width*0.5208075,size.height*0.4955462,size.width*0.5151963,size.height*0.4953529,size.width*0.5086062,size.height*0.4942731);
    abs3.lineTo(size.width*0.5086062,size.height*0.4380210);
    abs3.cubicTo(size.width*0.5086075,size.height*0.4363992,size.width*0.5125175,size.height*0.4350840,size.width*0.5173337,size.height*0.4350840);
    abs3.close();

Paint paint_7_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01437200;
paint_7_stroke.color=absColor;
canvas.drawPath(abs3,paint_7_stroke);

Paint paint_7_fill = Paint()..style=PaintingStyle.fill;
paint_7_fill.color = absColor;
canvas.drawPath(abs3,paint_7_fill);

Path abs1 = Path();
    abs1.moveTo(size.width*0.5989013,size.height*0.3367487);
    abs1.cubicTo(size.width*0.6060787,size.height*0.3368937,size.width*0.6115312,size.height*0.3389933,size.width*0.6109863,size.height*0.3414101);
    abs1.lineTo(size.width*0.6059087,size.height*0.3637479);
    abs1.cubicTo(size.width*0.6051313,size.height*0.3671517,size.width*0.5964200,size.height*0.3697210,size.width*0.5862913,size.height*0.3695336);
    abs1.lineTo(size.width*0.5261725,size.height*0.3684298);
    abs1.lineTo(size.width*0.5261600,size.height*0.3684298);
    abs1.cubicTo(size.width*0.5163138,size.height*0.3682504,size.width*0.5086075,size.height*0.3655101,size.width*0.5086062,size.height*0.3621929);
    abs1.lineTo(size.width*0.5086062,size.height*0.3380987);
    abs1.cubicTo(size.width*0.5086062,size.height*0.3364508,size.width*0.5125450,size.height*0.3351160,size.width*0.5174313,size.height*0.3350996);
    abs1.lineTo(size.width*0.5989013,size.height*0.3367487);
    abs1.close();

Paint paint_8_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01437200;
paint_8_stroke.color=absColor;
canvas.drawPath(abs1,paint_8_stroke);

Paint paint_8_fill = Paint()..style=PaintingStyle.fill;
paint_8_fill.color = absColor;
canvas.drawPath(abs1,paint_8_fill);

Path abs2 = Path();
    abs2.moveTo(size.width*0.5111088,size.height*0.2885454);
    abs2.cubicTo(size.width*0.5111762,size.height*0.2877996,size.width*0.5131400,size.height*0.2872366,size.width*0.5153437,size.height*0.2873391);
    abs2.lineTo(size.width*0.5153562,size.height*0.2873391);
    abs2.lineTo(size.width*0.6158938,size.height*0.2920374);
    abs2.cubicTo(size.width*0.6196763,size.height*0.2922147,size.width*0.6223388,size.height*0.2933786,size.width*0.6218875,size.height*0.2946513);
    abs2.lineTo(size.width*0.6218625,size.height*0.2947168);
    abs2.lineTo(size.width*0.6218500,size.height*0.2947866);
    abs2.lineTo(size.width*0.6174075,size.height*0.3183756);
    abs2.cubicTo(size.width*0.6169463,size.height*0.3208277,size.width*0.6110463,size.height*0.3227332,size.width*0.6038938,size.height*0.3228399);
    abs2.lineTo(size.width*0.6024538,size.height*0.3228361);
    abs2.lineTo(size.width*0.5225713,size.height*0.3213261);
    abs2.cubicTo(size.width*0.5161425,size.height*0.3212029,size.width*0.5111088,size.height*0.3194130,size.width*0.5111088,size.height*0.3172475);
    abs2.lineTo(size.width*0.5111088,size.height*0.2885454);
    abs2.close();

Paint paint_9_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01437200;
paint_9_stroke.color=absColor;
canvas.drawPath(abs2,paint_9_stroke);

Paint paint_9_fill = Paint()..style=PaintingStyle.fill;
paint_9_fill.color = absColor;
canvas.drawPath(abs2,paint_9_fill);

_absPath = Path()
  ..addPath(abs1, Offset.zero)
  ..addPath(abs2, Offset.zero)
  ..addPath(abs3, Offset.zero)
  ..addPath(abs4, Offset.zero)
  ..addPath(abs5, Offset.zero)
  ..addPath(abs6, Offset.zero)
  ..addPath(abs7, Offset.zero)
  ..addPath(abs8, Offset.zero);

Path path_10 = Path();
    path_10.moveTo(size.width*0.1087749,size.height*0.3858248);
    path_10.cubicTo(size.width*0.06649463,size.height*0.3613328,size.width*0.04724075,size.height*0.3346462,size.width*0.04887513,size.height*0.3160550);
    path_10.cubicTo(size.width*0.05066612,size.height*0.2952697,size.width*0.08081200,size.height*0.2782815,size.width*0.1412825,size.height*0.2653731);
    path_10.cubicTo(size.width*0.1444837,size.height*0.2646731,size.width*0.1477975,size.height*0.2639992,size.width*0.1511900,size.height*0.2633332);
    path_10.cubicTo(size.width*0.1564737,size.height*0.2623021,size.width*0.1639063,size.height*0.2626597,size.width*0.1668613,size.height*0.2644660);
    path_10.cubicTo(size.width*0.2688737,size.height*0.3264718,size.width*0.1617350,size.height*0.3727282,size.width*0.1087749,size.height*0.3858286);
    path_10.lineTo(size.width*0.1087749,size.height*0.3858248);
    path_10.close();

Paint paint_10_fill = Paint()..style=PaintingStyle.fill;
paint_10_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_10,paint_10_fill);

Path path_11 = Path();
    path_11.moveTo(size.width*0.1449200,size.height*0.5412101);
    path_11.cubicTo(size.width*0.1520287,size.height*0.5463739,size.width*0.1565625,size.height*0.5512017,size.width*0.1569875,size.height*0.5555294);
    path_11.cubicTo(size.width*0.1572787,size.height*0.5588277,size.width*0.1498012,size.height*0.5611429,size.width*0.1402975,size.height*0.5603193);
    path_11.cubicTo(size.width*0.1352262,size.height*0.5598866,size.width*0.1302787,size.height*0.5587311,size.width*0.1254987,size.height*0.5567437);
    path_11.cubicTo(size.width*0.1183903,size.height*0.5537521,size.width*0.1144723,size.height*0.5500420,size.width*0.1137222,size.height*0.5462395);
    path_11.cubicTo(size.width*0.1126029,size.height*0.5406975,size.width*0.1084610,size.height*0.5310630,size.width*0.09315862,size.height*0.5313151);
    path_11.cubicTo(size.width*0.06014713,size.height*0.5318361,size.width*0.07267337,size.height*0.5512227,size.width*0.07563987,size.height*0.5552521);
    path_11.cubicTo(size.width*0.07609875,size.height*0.5558739,size.width*0.07649063,size.height*0.5564916,size.width*0.07683762,size.height*0.5571092);
    path_11.lineTo(size.width*0.08052050,size.height*0.5636471);
    path_11.cubicTo(size.width*0.08252425,size.height*0.5672101,size.width*0.08703550,size.height*0.5705672,size.width*0.09366237,size.height*0.5734244);
    path_11.lineTo(size.width*0.1224201,size.height*0.5858151);
    path_11.cubicTo(size.width*0.1260025,size.height*0.5873571,size.width*0.1280850,size.height*0.5892437,size.width*0.1283525,size.height*0.5912017);
    path_11.lineTo(size.width*0.1283525,size.height*0.5912899);
    path_11.cubicTo(size.width*0.1288125,size.height*0.5943950,size.width*0.1205060,size.height*0.5969202,size.width*0.1114162,size.height*0.5962983);
    path_11.cubicTo(size.width*0.09403175,size.height*0.5951050,size.width*0.07666975,size.height*0.5893866,size.width*0.05677775,size.height*0.5838067);
    path_11.cubicTo(size.width*0.04895300,size.height*0.5816261,size.width*0.04249400,size.height*0.5789370,size.width*0.03784838,size.height*0.5759076);
    path_11.lineTo(size.width*0.008262287,size.height*0.5566597);
    path_11.cubicTo(size.width*0.001769687,size.height*0.5524286,size.width*-0.001006463,size.height*0.5476723,size.width*0.0003256412,size.height*0.5429286);
    path_11.lineTo(size.width*0.01151979,size.height*0.5028950);
    path_11.cubicTo(size.width*0.01253850,size.height*0.4993067,size.width*0.01408325,size.height*0.4957227,size.width*0.01598625,size.height*0.4921639);
    path_11.cubicTo(size.width*0.04352388,size.height*0.4413571,size.width*-0.02583512,size.height*0.3915244,size.width*0.04709475,size.height*0.3561408);
    path_11.cubicTo(size.width*0.04950150,size.height*0.3591739,size.width*0.05185225,size.height*0.3620118,size.width*0.05424788,size.height*0.3646874);
    path_11.cubicTo(size.width*0.06180387,size.height*0.3730723,size.width*0.07000913,size.height*0.3799971,size.width*0.08261375,size.height*0.3871172);
    path_11.cubicTo(size.width*0.08849075,size.height*0.3904479,size.width*0.09533037,size.height*0.3938349,size.width*0.1035245,size.height*0.3974252);
    path_11.cubicTo(size.width*0.1037371,size.height*0.3975042,size.width*0.1224425,size.height*0.3930445,size.width*0.1226552,size.height*0.3931349);
    path_11.cubicTo(size.width*0.1464763,size.height*0.3876214,size.width*0.1483900,size.height*0.3861689,size.width*0.1652600,size.height*0.3796130);
    path_11.cubicTo(size.width*0.1713275,size.height*0.3772798,size.width*0.1769025,size.height*0.3748710,size.width*0.1820288,size.height*0.3723950);
    path_11.cubicTo(size.width*0.2247900,size.height*0.4199080,size.width*0.1293162,size.height*0.4443992,size.width*0.1009497,size.height*0.4888613);
    path_11.cubicTo(size.width*0.09779300,size.height*0.4938361,size.width*0.1000430,size.height*0.4990336,size.width*0.1072745,size.height*0.5035042);
    path_11.lineTo(size.width*0.1201701,size.height*0.5102563);
    path_11.cubicTo(size.width*0.1261475,size.height*0.5133739,size.width*0.1301100,size.height*0.5168739,size.width*0.1318125,size.height*0.5205252);
    path_11.lineTo(size.width*0.1376887,size.height*0.5331513);
    path_11.cubicTo(size.width*0.1389988,size.height*0.5359328,size.width*0.1414050,size.height*0.5386513,size.width*0.1448975,size.height*0.5412017);
    path_11.lineTo(size.width*0.1449200,size.height*0.5412101);
    path_11.close();

Paint paint_11_fill = Paint()..style=PaintingStyle.fill;
paint_11_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_11,paint_11_fill);

Path path_12 = Path();
    path_12.moveTo(size.width*0.2178337,size.height*0.7055966);
    path_12.cubicTo(size.width*0.2326325,size.height*0.6983697,size.width*0.2522675,size.height*0.6917353,size.width*0.2782713,size.height*0.6858782);
    path_12.cubicTo(size.width*0.2861300,size.height*0.6841050,size.width*0.2967862,size.height*0.6847941,size.width*0.3022937,size.height*0.6873824);
    path_12.lineTo(size.width*0.3567425,size.height*0.7130084);
    path_12.cubicTo(size.width*0.3628425,size.height*0.7158824,size.width*0.3621600,size.height*0.7197983,size.width*0.3550737,size.height*0.7223992);
    path_12.cubicTo(size.width*0.3203162,size.height*0.7351387,size.width*0.2945700,size.height*0.7488487,size.width*0.2726300,size.height*0.7629706);
    path_12.cubicTo(size.width*0.2700887,size.height*0.7646050,size.width*0.2632262,size.height*0.7647017,size.width*0.2602825,size.height*0.7631429);
    path_12.cubicTo(size.width*0.2315912,size.height*0.7479748,size.width*0.2111400,size.height*0.7333403,size.width*0.2069875,size.height*0.7197437);
    path_12.cubicTo(size.width*0.2054650,size.height*0.7147563,size.width*0.2093825,size.height*0.7097227,size.width*0.2178450,size.height*0.7055924);
    path_12.lineTo(size.width*0.2178337,size.height*0.7055966);
    path_12.close();

Paint paint_12_fill = Paint()..style=PaintingStyle.fill;
paint_12_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_12,paint_12_fill);

Path path_13 = Path();
    path_13.moveTo(size.width*0.7802412,size.height*0.7055966);
    path_13.cubicTo(size.width*0.7654425,size.height*0.6983697,size.width*0.7458075,size.height*0.6917353,size.width*0.7198037,size.height*0.6858782);
    path_13.cubicTo(size.width*0.7119450,size.height*0.6841050,size.width*0.7012888,size.height*0.6847941,size.width*0.6957813,size.height*0.6873824);
    path_13.lineTo(size.width*0.6413325,size.height*0.7130084);
    path_13.cubicTo(size.width*0.6352325,size.height*0.7158824,size.width*0.6359150,size.height*0.7197983,size.width*0.6430012,size.height*0.7223992);
    path_13.cubicTo(size.width*0.6777587,size.height*0.7351387,size.width*0.7035050,size.height*0.7488487,size.width*0.7254462,size.height*0.7629706);
    path_13.cubicTo(size.width*0.7279863,size.height*0.7646050,size.width*0.7348488,size.height*0.7647017,size.width*0.7377925,size.height*0.7631429);
    path_13.cubicTo(size.width*0.7664838,size.height*0.7479748,size.width*0.7869350,size.height*0.7333403,size.width*0.7910888,size.height*0.7197437);
    path_13.cubicTo(size.width*0.7926100,size.height*0.7147563,size.width*0.7886925,size.height*0.7097227,size.width*0.7802300,size.height*0.7055924);
    path_13.lineTo(size.width*0.7802412,size.height*0.7055966);
    path_13.close();

Paint paint_13_fill = Paint()..style=PaintingStyle.fill;
paint_13_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_13,paint_13_fill);

Path path_14 = Path();
    path_14.moveTo(size.width*0.3013150,size.height*0.9237269);
    path_14.cubicTo(size.width*0.3005425,size.height*0.9279286,size.width*0.3014712,size.height*0.9321555,size.width*0.3040913,size.height*0.9362773);
    path_14.cubicTo(size.width*0.3094300,size.height*0.9446807,size.width*0.3135500,size.height*0.9526471,size.width*0.3144562,size.height*0.9594244);
    path_14.cubicTo(size.width*0.3146138,size.height*0.9605252,size.width*0.3148813,size.height*0.9616218,size.width*0.3154413,size.height*0.9627101);
    path_14.cubicTo(size.width*0.3291650,size.height*0.9896555,size.width*0.3356800,size.height*1.001109,size.width*0.2941050,size.height*1.003651);
    path_14.lineTo(size.width*0.1290137,size.height*1.003651);
    path_14.cubicTo(size.width*0.1181672,size.height*1.003651,size.width*0.1093575,size.height*1.000508,size.width*0.1105887,size.height*0.9968824);
    path_14.cubicTo(size.width*0.1105887,size.height*0.9968445,size.width*0.1106113,size.height*0.9968025,size.width*0.1106113,size.height*0.9967647);
    path_14.cubicTo(size.width*0.1115962,size.height*0.9941597,size.width*0.1159844,size.height*0.9918319,size.width*0.1221188,size.height*0.9902185);
    path_14.cubicTo(size.width*0.1570775,size.height*0.9810462,size.width*0.1779888,size.height*0.9724244,size.width*0.1890488,size.height*0.9642101);
    path_14.cubicTo(size.width*0.1921488,size.height*0.9619034,size.width*0.1934812,size.height*0.9593529,size.width*0.1925525,size.height*0.9568361);
    path_14.cubicTo(size.width*0.1901788,size.height*0.9505462,size.width*0.1922050,size.height*0.9443319,size.width*0.1996825,size.height*0.9382101);
    path_14.cubicTo(size.width*0.2043625,size.height*0.9343992,size.width*0.2059850,size.height*0.9302647,size.width*0.2040375,size.height*0.9261975);
    path_14.cubicTo(size.width*0.1869438,size.height*0.8908908,size.width*0.1636037,size.height*0.8557773,size.width*0.1521187,size.height*0.8237857);
    path_14.cubicTo(size.width*0.1404212,size.height*0.7912731,size.width*0.1409813,size.height*0.7619874,size.width*0.1727613,size.height*0.7389916);
    path_14.cubicTo(size.width*0.1768475,size.height*0.7360126,size.width*0.1814925,size.height*0.7331387,size.width*0.1866975,size.height*0.7303739);
    path_14.lineTo(size.width*0.2528775,size.height*0.7719244);
    path_14.cubicTo(size.width*0.2584075,size.height*0.7753992,size.width*0.2728700,size.height*0.7757017,size.width*0.2796425,size.height*0.7724832);
    path_14.lineTo(size.width*0.3520125,size.height*0.7380756);
    path_14.cubicTo(size.width*0.3919087,size.height*0.7869160,size.width*0.3812850,size.height*0.8242479,size.width*0.3353788,size.height*0.8535546);
    path_14.cubicTo(size.width*0.3269938,size.height*0.8588950,size.width*0.3209600,size.height*0.8646092,size.width*0.3178600,size.height*0.8705420);
    path_14.cubicTo(size.width*0.3105950,size.height*0.8844664,size.width*0.3053113,size.height*0.9026933,size.width*0.3013263,size.height*0.9237227);
    path_14.lineTo(size.width*0.3013150,size.height*0.9237269);
    path_14.close();

Paint paint_14_fill = Paint()..style=PaintingStyle.fill;
paint_14_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_14,paint_14_fill);

Path path_15 = Path();
    path_15.moveTo(size.width*0.8706288,size.height*1.003655);
    path_15.lineTo(size.width*0.7055375,size.height*1.003655);
    path_15.cubicTo(size.width*0.6639512,size.height*1.001113,size.width*0.6704775,size.height*0.9896597,size.width*0.6842012,size.height*0.9627143);
    path_15.cubicTo(size.width*0.6847612,size.height*0.9616261,size.width*0.6850300,size.height*0.9605294,size.width*0.6851862,size.height*0.9594286);
    path_15.cubicTo(size.width*0.6860938,size.height*0.9526513,size.width*0.6902125,size.height*0.9446849,size.width*0.6955525,size.height*0.9362815);
    path_15.cubicTo(size.width*0.6981725,size.height*0.9321597,size.width*0.6991013,size.height*0.9279328,size.width*0.6983288,size.height*0.9237311);
    path_15.cubicTo(size.width*0.6943438,size.height*0.9027059,size.width*0.6890600,size.height*0.8844790,size.width*0.6817950,size.height*0.8705504);
    path_15.cubicTo(size.width*0.6786937,size.height*0.8646134,size.width*0.6726600,size.height*0.8589076,size.width*0.6642763,size.height*0.8535630);
    path_15.cubicTo(size.width*0.6183687,size.height*0.8242563,size.width*0.6077350,size.height*0.7869244,size.width*0.6476413,size.height*0.7380798);
    path_15.lineTo(size.width*0.7186575,size.height*0.7718487);
    path_15.cubicTo(size.width*0.7260450,size.height*0.7753571,size.width*0.7418288,size.height*0.7750294,size.width*0.7478738,size.height*0.7712395);
    path_15.lineTo(size.width*0.8129563,size.height*0.7303739);
    path_15.cubicTo(size.width*0.8181625,size.height*0.7331387,size.width*0.8228075,size.height*0.7360126,size.width*0.8268937,size.height*0.7389916);
    path_15.cubicTo(size.width*0.8586738,size.height*0.7619874,size.width*0.8592337,size.height*0.7912731,size.width*0.8475350,size.height*0.8237857);
    path_15.cubicTo(size.width*0.8360500,size.height*0.8557731,size.width*0.8127100,size.height*0.8908908,size.width*0.7956175,size.height*0.9261975);
    path_15.cubicTo(size.width*0.7936687,size.height*0.9302647,size.width*0.7952925,size.height*0.9344034,size.width*0.7999713,size.height*0.9382101);
    path_15.cubicTo(size.width*0.8074488,size.height*0.9443319,size.width*0.8094750,size.height*0.9505462,size.width*0.8071025,size.height*0.9568361);
    path_15.cubicTo(size.width*0.8061625,size.height*0.9593529,size.width*0.8075050,size.height*0.9619034,size.width*0.8106062,size.height*0.9642101);
    path_15.cubicTo(size.width*0.8216663,size.height*0.9724244,size.width*0.8425762,size.height*0.9810462,size.width*0.8775363,size.height*0.9902185);
    path_15.cubicTo(size.width*0.8836813,size.height*0.9918319,size.width*0.8880588,size.height*0.9941597,size.width*0.8890438,size.height*0.9967647);
    path_15.cubicTo(size.width*0.8890438,size.height*0.9968025,size.width*0.8890662,size.height*0.9968445,size.width*0.8890662,size.height*0.9968824);
    path_15.cubicTo(size.width*0.8902975,size.height*1.000508,size.width*0.8814763,size.height*1.003651,size.width*0.8706400,size.height*1.003651);
    path_15.lineTo(size.width*0.8706288,size.height*1.003655);
    path_15.close();

Paint paint_15_fill = Paint()..style=PaintingStyle.fill;
paint_15_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_15,paint_15_fill);

Path path_16 = Path();
    path_16.moveTo(size.width*0.3830112,size.height*0.6897311);
    path_16.cubicTo(size.width*0.3775375,size.height*0.6945378,size.width*0.3718063,size.height*0.6991807,size.width*0.3658288,size.height*0.7036597);
    path_16.lineTo(size.width*0.3250588,size.height*0.6822479);
    path_16.cubicTo(size.width*0.3116937,size.height*0.6752269,size.width*0.2836300,size.height*0.6733529,size.width*0.2633012,size.height*0.6781261);
    path_16.lineTo(size.width*0.2032225,size.height*0.6922269);
    path_16.cubicTo(size.width*0.1148780,size.height*0.6139370,size.width*0.2174838,size.height*0.4916429,size.width*0.2436325,size.height*0.4439034);
    path_16.cubicTo(size.width*0.2671850,size.height*0.4527017,size.width*0.3010025,size.height*0.4653319,size.width*0.3403388,size.height*0.4800168);
    path_16.cubicTo(size.width*0.3494625,size.height*0.4834244,size.width*0.3579250,size.height*0.4870294,size.width*0.3656600,size.height*0.4907983);
    path_16.lineTo(size.width*0.3922237,size.height*0.5037563);
    path_16.cubicTo(size.width*0.4142312,size.height*0.5144916,size.width*0.4258063,size.height*0.5272479,size.width*0.4253588,size.height*0.5402857);
    path_16.lineTo(size.width*0.4227175,size.height*0.6178613);
    path_16.cubicTo(size.width*0.4218775,size.height*0.6424034,size.width*0.4090937,size.height*0.6668109,size.width*0.3830112,size.height*0.6897353);
    path_16.lineTo(size.width*0.3830112,size.height*0.6897311);
    path_16.close();

Paint paint_16_fill = Paint()..style=PaintingStyle.fill;
paint_16_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_16,paint_16_fill);

Path path_17 = Path();
    path_17.moveTo(size.width*0.6111100,size.height*0.6897311);
    path_17.cubicTo(size.width*0.6165837,size.height*0.6945378,size.width*0.6223150,size.height*0.6991807,size.width*0.6282925,size.height*0.7036597);
    path_17.lineTo(size.width*0.6690625,size.height*0.6822479);
    path_17.cubicTo(size.width*0.6824275,size.height*0.6752269,size.width*0.7104913,size.height*0.6733529,size.width*0.7308200,size.height*0.6781261);
    path_17.lineTo(size.width*0.7908987,size.height*0.6922269);
    path_17.cubicTo(size.width*0.8792437,size.height*0.6139370,size.width*0.7766375,size.height*0.4916429,size.width*0.7504887,size.height*0.4439034);
    path_17.cubicTo(size.width*0.7269362,size.height*0.4527017,size.width*0.6931188,size.height*0.4653319,size.width*0.6537825,size.height*0.4800168);
    path_17.cubicTo(size.width*0.6446587,size.height*0.4834244,size.width*0.6361963,size.height*0.4870294,size.width*0.6284612,size.height*0.4907983);
    path_17.lineTo(size.width*0.6018975,size.height*0.5037563);
    path_17.cubicTo(size.width*0.5798900,size.height*0.5144916,size.width*0.5683150,size.height*0.5272479,size.width*0.5687625,size.height*0.5402857);
    path_17.lineTo(size.width*0.5714037,size.height*0.6178613);
    path_17.cubicTo(size.width*0.5722437,size.height*0.6424034,size.width*0.5850275,size.height*0.6668109,size.width*0.6111100,size.height*0.6897353);
    path_17.lineTo(size.width*0.6111100,size.height*0.6897311);
    path_17.close();

Paint paint_17_fill = Paint()..style=PaintingStyle.fill;
paint_17_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_17,paint_17_fill);

Path path_18 = Path();
    path_18.moveTo(size.width*0.8829100,size.height*0.3849261);
    path_18.cubicTo(size.width*0.8299500,size.height*0.3718256,size.width*0.7228113,size.height*0.3255693,size.width*0.8248237,size.height*0.2635634);
    path_18.cubicTo(size.width*0.8277900,size.height*0.2617567,size.width*0.8352113,size.height*0.2613992,size.width*0.8404950,size.height*0.2624307);
    path_18.cubicTo(size.width*0.8438875,size.height*0.2630929,size.width*0.8471675,size.height*0.2637664,size.width*0.8504025,size.height*0.2644702);
    path_18.cubicTo(size.width*0.9108612,size.height*0.2773824,size.width*0.9410187,size.height*0.2943668,size.width*0.9428100,size.height*0.3151521);
    path_18.cubicTo(size.width*0.9444100,size.height*0.3337471,size.width*0.9251788,size.height*0.3604298,size.width*0.8829100,size.height*0.3849223);
    path_18.lineTo(size.width*0.8829100,size.height*0.3849261);
    path_18.close();

Paint paint_18_fill = Paint()..style=PaintingStyle.fill;
paint_18_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_18,paint_18_fill);

Path path_19 = Path();
    path_19.moveTo(size.width*0.9834088,size.height*0.5557647);
    path_19.lineTo(size.width*0.9538225,size.height*0.5750126);
    path_19.cubicTo(size.width*0.9491763,size.height*0.5780378,size.width*0.9427175,size.height*0.5807353,size.width*0.9348812,size.height*0.5829118);
    path_19.cubicTo(size.width*0.9149900,size.height*0.5884916,size.width*0.8976275,size.height*0.5942059,size.width*0.8802437,size.height*0.5954034);
    path_19.cubicTo(size.width*0.8711650,size.height*0.5960252,size.width*0.8628588,size.height*0.5935000,size.width*0.8633062,size.height*0.5903950);
    path_19.lineTo(size.width*0.8633062,size.height*0.5903025);
    path_19.cubicTo(size.width*0.8635750,size.height*0.5883487,size.width*0.8656575,size.height*0.5864622,size.width*0.8692388,size.height*0.5849202);
    path_19.lineTo(size.width*0.8979975,size.height*0.5725294);
    path_19.cubicTo(size.width*0.9046238,size.height*0.5696723,size.width*0.9091350,size.height*0.5663151,size.width*0.9111387,size.height*0.5627521);
    path_19.lineTo(size.width*0.9148212,size.height*0.5562143);
    path_19.cubicTo(size.width*0.9151687,size.height*0.5555966,size.width*0.9155712,size.height*0.5549748,size.width*0.9160200,size.height*0.5543571);
    path_19.cubicTo(size.width*0.9189863,size.height*0.5503235,size.width*0.9315125,size.height*0.5309412,size.width*0.8985013,size.height*0.5304202);
    path_19.cubicTo(size.width*0.8831988,size.height*0.5301681,size.width*0.8790562,size.height*0.5398025,size.width*0.8779375,size.height*0.5453445);
    path_19.cubicTo(size.width*0.8771875,size.height*0.5491513,size.width*0.8732575,size.height*0.5528571,size.width*0.8661612,size.height*0.5558445);
    path_19.cubicTo(size.width*0.8613812,size.height*0.5578277,size.width*0.8564438,size.height*0.5589874,size.width*0.8513625,size.height*0.5594202);
    path_19.cubicTo(size.width*0.8418587,size.height*0.5602437,size.width*0.8343813,size.height*0.5579328,size.width*0.8346713,size.height*0.5546345);
    path_19.cubicTo(size.width*0.8350975,size.height*0.5503067,size.width*0.8396425,size.height*0.5454790,size.width*0.8467387,size.height*0.5403151);
    path_19.cubicTo(size.width*0.8502425,size.height*0.5377647,size.width*0.8526388,size.height*0.5350462,size.width*0.8539475,size.height*0.5322605);
    path_19.lineTo(size.width*0.8598250,size.height*0.5196387);
    path_19.cubicTo(size.width*0.8615375,size.height*0.5159832,size.width*0.8654887,size.height*0.5124832,size.width*0.8714675,size.height*0.5093697);
    path_19.lineTo(size.width*0.8843625,size.height*0.5026176);
    path_19.cubicTo(size.width*0.8916050,size.height*0.4981471,size.width*0.8938437,size.height*0.4929496,size.width*0.8906875,size.height*0.4879748);
    path_19.cubicTo(size.width*0.8623212,size.height*0.4435126,size.width*0.7668463,size.height*0.4190197,size.width*0.8096075,size.height*0.3715063);
    path_19.cubicTo(size.width*0.8147350,size.height*0.3739828,size.width*0.8203212,size.height*0.3763916,size.width*0.8263763,size.height*0.3787248);
    path_19.cubicTo(size.width*0.8432575,size.height*0.3852807,size.width*0.8636537,size.height*0.3912870,size.width*0.8875075,size.height*0.3967966);
    path_19.cubicTo(size.width*0.8877213,size.height*0.3967063,size.width*0.8879112,size.height*0.3966160,size.width*0.8881237,size.height*0.3965370);
    path_19.cubicTo(size.width*0.8963175,size.height*0.3929466,size.width*0.9031575,size.height*0.3895597,size.width*0.9090350,size.height*0.3862290);
    path_19.cubicTo(size.width*0.9216387,size.height*0.3791084,size.width*0.9298338,size.height*0.3721878,size.width*0.9374000,size.height*0.3637992);
    path_19.cubicTo(size.width*0.9398075,size.height*0.3611231,size.width*0.9421575,size.height*0.3582857,size.width*0.9445538,size.height*0.3552521);
    path_19.cubicTo(size.width*1.017484,size.height*0.3906361,size.width*0.9481350,size.height*0.4404664,size.width*0.9756625,size.height*0.4912773);
    path_19.cubicTo(size.width*0.9775537,size.height*0.4948319,size.width*0.9791100,size.height*0.4984160,size.width*0.9801175,size.height*0.5020084);
    path_19.lineTo(size.width*0.9913113,size.height*0.5420420);
    path_19.cubicTo(size.width*0.9926438,size.height*0.5467857,size.width*0.9898675,size.height*0.5515420,size.width*0.9833863,size.height*0.5557689);
    path_19.lineTo(size.width*0.9834088,size.height*0.5557647);
    path_19.close();

Paint paint_19_fill = Paint()..style=PaintingStyle.fill;
paint_19_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_19,paint_19_fill);

Path path_20 = Path();
    path_20.moveTo(size.width*0.4149575,size.height*0.1199252);
    path_20.cubicTo(size.width*0.4163787,size.height*0.1402853,size.width*0.3412888,size.height*0.1570929,size.width*0.2222163,size.height*0.1718605);
    path_20.cubicTo(size.width*0.4080063,size.height*0.1900979,size.width*0.5848513,size.height*0.1898231,size.width*0.7536700,size.height*0.1723387);
    path_20.cubicTo(size.width*0.6516800,size.height*0.1612588,size.width*0.5793437,size.height*0.1457576,size.width*0.5666050,size.height*0.1213592);
    path_20.cubicTo(size.width*0.5238312,size.height*0.1381403,size.width*0.4763912,size.height*0.1458403,size.width*0.4149575,size.height*0.1199290);
    path_20.lineTo(size.width*0.4149575,size.height*0.1199252);
    path_20.close();

Paint paint_20_fill = Paint()..style=PaintingStyle.fill;
paint_20_fill.color = Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_20,paint_20_fill);

Path path_21 = Path();
    path_21.moveTo(size.width*0.4318238,size.height*0.1388433);
    path_21.cubicTo(size.width*0.4281512,size.height*0.1379139,size.width*0.4228688,size.height*0.1388622,size.width*0.4231038,size.height*0.1404055);
    path_21.cubicTo(size.width*0.4242788,size.height*0.1482521,size.width*0.4292037,size.height*0.1669109,size.width*0.4498012,size.height*0.1728458);
    path_21.cubicTo(size.width*0.4746750,size.height*0.1800113,size.width*0.4804288,size.height*0.1511197,size.width*0.4318350,size.height*0.1388433);
    path_21.lineTo(size.width*0.4318238,size.height*0.1388433);
    path_21.close();

Paint paint_21_fill = Paint()..style=PaintingStyle.fill;
paint_21_fill.color = AppColors.muscleDefaultColor;
canvas.drawPath(path_21,paint_21_fill);

Path path_22 = Path();
    path_22.moveTo(size.width*0.5499700,size.height*0.1388433);
    path_22.cubicTo(size.width*0.5536412,size.height*0.1379139,size.width*0.5589250,size.height*0.1388622,size.width*0.5586900,size.height*0.1404055);
    path_22.cubicTo(size.width*0.5575150,size.height*0.1482521,size.width*0.5525900,size.height*0.1669109,size.width*0.5319925,size.height*0.1728458);
    path_22.cubicTo(size.width*0.5071187,size.height*0.1800113,size.width*0.5013650,size.height*0.1511197,size.width*0.5499587,size.height*0.1388433);
    path_22.lineTo(size.width*0.5499700,size.height*0.1388433);
    path_22.close();

Paint paint_22_fill = Paint()..style=PaintingStyle.fill;
paint_22_fill.color = AppColors.muscleDefaultColor;
canvas.drawPath(path_22,paint_22_fill);

Path path_23 = Path();
    path_23.moveTo(size.width*0.3668825,size.height*0.1540130);
    path_23.cubicTo(size.width*0.3445613,size.height*0.1600345,size.width*0.3186575,size.height*0.1650697,size.width*0.2881425,size.height*0.1688332);
    path_23.cubicTo(size.width*0.2852438,size.height*0.1691908,size.width*0.2852662,size.height*0.1705832,size.width*0.2882212,size.height*0.1708882);
    path_23.cubicTo(size.width*0.3274225,size.height*0.1749336,size.width*0.3644750,size.height*0.1768492,size.width*0.3974763,size.height*0.1747756);
    path_23.cubicTo(size.width*0.3998375,size.height*0.1746290,size.width*0.4008113,size.height*0.1736618,size.width*0.3993450,size.height*0.1730218);
    path_23.cubicTo(size.width*0.3853750,size.height*0.1669252,size.width*0.3749312,size.height*0.1608210,size.width*0.3719650,size.height*0.1547055);
    path_23.cubicTo(size.width*0.3715613,size.height*0.1538735,size.width*0.3688413,size.height*0.1534861,size.width*0.3668825,size.height*0.1540168);
    path_23.lineTo(size.width*0.3668825,size.height*0.1540130);
    path_23.close();

Paint paint_23_fill = Paint()..style=PaintingStyle.fill;
paint_23_fill.color = AppColors.muscleDefaultColor;
canvas.drawPath(path_23,paint_23_fill);

Path path_24 = Path();
    path_24.moveTo(size.width*0.6082775,size.height*0.1540130);
    path_24.cubicTo(size.width*0.6305987,size.height*0.1600345,size.width*0.6565025,size.height*0.1650697,size.width*0.6870175,size.height*0.1688332);
    path_24.cubicTo(size.width*0.6899163,size.height*0.1691908,size.width*0.6898937,size.height*0.1705832,size.width*0.6869388,size.height*0.1708882);
    path_24.cubicTo(size.width*0.6477375,size.height*0.1749336,size.width*0.6106850,size.height*0.1768492,size.width*0.5776838,size.height*0.1747756);
    path_24.cubicTo(size.width*0.5753225,size.height*0.1746290,size.width*0.5743487,size.height*0.1736618,size.width*0.5758150,size.height*0.1730218);
    path_24.cubicTo(size.width*0.5897850,size.height*0.1669252,size.width*0.6002288,size.height*0.1608210,size.width*0.6031950,size.height*0.1547055);
    path_24.cubicTo(size.width*0.6035987,size.height*0.1538735,size.width*0.6063188,size.height*0.1534861,size.width*0.6082775,size.height*0.1540168);
    path_24.lineTo(size.width*0.6082775,size.height*0.1540130);
    path_24.close();

Paint paint_24_fill = Paint()..style=PaintingStyle.fill;
paint_24_fill.color = AppColors.muscleDefaultColor;
canvas.drawPath(path_24,paint_24_fill);

Path lateralDeltoid1 = Path();
    lateralDeltoid1.moveTo(size.width*0.1467200,size.height*0.1881483);
    lateralDeltoid1.cubicTo(size.width*0.07814500,size.height*0.1963487,size.width*0.05768212,size.height*0.2184139,size.width*0.07499950,size.height*0.2594013);
    lateralDeltoid1.cubicTo(size.width*0.1004661,size.height*0.2319996,size.width*0.1092536,size.height*0.2136529,size.width*0.1555975,size.height*0.1922807);
    lateralDeltoid1.cubicTo(size.width*0.1601875,size.height*0.1901618,size.width*0.1540637,size.height*0.1872676,size.width*0.1467200,size.height*0.1881483);
    lateralDeltoid1.close();

Paint paint_25_fill = Paint()..style=PaintingStyle.fill;
paint_25_fill.color = lateralDeltoid1Color;
canvas.drawPath(lateralDeltoid1,paint_25_fill);

_lateralDeltoid1Path = Path()..addPath(lateralDeltoid1, Offset.zero);

Path frontDeltoid1 = Path();
    frontDeltoid1.moveTo(size.width*0.1036621,size.height*0.2533954);
    frontDeltoid1.cubicTo(size.width*0.1754162,size.height*0.2426735,size.width*0.1897675,size.height*0.2169429,size.width*0.2487713,size.height*0.1890672);
    frontDeltoid1.cubicTo(size.width*0.1530950,size.height*0.1762000,size.width*0.1212034,size.height*0.2174811,size.width*0.1036621,size.height*0.2533954);
    frontDeltoid1.close();

Paint paint_26_fill = Paint()..style=PaintingStyle.fill;
paint_26_fill.color = frontDeltoid1Color;
canvas.drawPath(frontDeltoid1,paint_26_fill);

_frontDeltoid1Path = Path()..addPath(frontDeltoid1, Offset.zero);

Path chest1a = Path();
    chest1a.moveTo(size.width*0.1664550,size.height*0.2489765);
    chest1a.cubicTo(size.width*0.2462025,size.height*0.1878508,size.width*0.2701237,size.height*0.1835605,size.width*0.4136663,size.height*0.1980387);
    chest1a.cubicTo(size.width*0.4136663,size.height*0.1980387,size.width*0.2332725,size.height*0.2427067,size.width*0.1664550,size.height*0.2489765);
    chest1a.close();

Paint paint_27_fill = Paint()..style=PaintingStyle.fill;
paint_27_fill.color = chest1Color;
canvas.drawPath(chest1a,paint_27_fill);

Path chest1b = Path();
    chest1b.moveTo(size.width*0.2003412,size.height*0.2519370);
    chest1b.cubicTo(size.width*0.2963987,size.height*0.2395403,size.width*0.3902837,size.height*0.2072618,size.width*0.4411275,size.height*0.2032122);
    chest1b.cubicTo(size.width*0.4495350,size.height*0.2025424,size.width*0.4575613,size.height*0.2046912,size.width*0.4575613,size.height*0.2075966);
    chest1b.lineTo(size.width*0.4575613,size.height*0.2484185);
    chest1b.cubicTo(size.width*0.4575613,size.height*0.2521971,size.width*0.4476987,size.height*0.2551210,size.width*0.4365500,size.height*0.2546504);
    chest1b.lineTo(size.width*0.2003412,size.height*0.2519370);
    chest1b.close();

Paint paint_28_fill = Paint()..style=PaintingStyle.fill;
paint_28_fill.color = chest1Color;
canvas.drawPath(chest1b,paint_28_fill);

Path chest1c = Path();
    chest1c.moveTo(size.width*0.2016713,size.height*0.2576521);
    chest1c.cubicTo(size.width*0.2378950,size.height*0.2858403,size.width*0.3616800,size.height*0.2824718,size.width*0.4500912,size.height*0.2700189);
    chest1c.cubicTo(size.width*0.4564612,size.height*0.2691193,size.width*0.4562262,size.height*0.2661349,size.width*0.4498900,size.height*0.2652092);
    chest1c.cubicTo(size.width*0.3879750,size.height*0.2561466,size.width*0.2223688,size.height*0.2564929,size.width*0.2016600,size.height*0.2576559);
    chest1c.lineTo(size.width*0.2016713,size.height*0.2576521);
    chest1c.close();

Paint paint_29_fill = Paint()..style=PaintingStyle.fill;
paint_29_fill.color = chest1Color;
canvas.drawPath(chest1c,paint_29_fill);

_chest1Path = Path()
  ..addPath(chest1a, Offset.zero)
  ..addPath(chest1b, Offset.zero)
  ..addPath(chest1c, Offset.zero);

Path lateralDeltoid2 = Path();
    lateralDeltoid2.moveTo(size.width*0.8370725,size.height*0.1881483);
    lateralDeltoid2.cubicTo(size.width*0.9056487,size.height*0.1963487,size.width*0.9261112,size.height*0.2184139,size.width*0.9087938,size.height*0.2594013);
    lateralDeltoid2.cubicTo(size.width*0.8833275,size.height*0.2319996,size.width*0.8745400,size.height*0.2136529,size.width*0.8281963,size.height*0.1922807);
    lateralDeltoid2.cubicTo(size.width*0.8236062,size.height*0.1901618,size.width*0.8297300,size.height*0.1872676,size.width*0.8370725,size.height*0.1881483);
    lateralDeltoid2.close();

Paint paint_30_fill = Paint()..style=PaintingStyle.fill;
paint_30_fill.color = lateralDeltoid2Color;
canvas.drawPath(lateralDeltoid2,paint_30_fill);

_lateralDeltoid2Path = Path()..addPath(lateralDeltoid2, Offset.zero);

Path frontDeltoid2 = Path();
    frontDeltoid2.moveTo(size.width*0.8801438,size.height*0.2533954);
    frontDeltoid2.cubicTo(size.width*0.8083900,size.height*0.2426735,size.width*0.7940388,size.height*0.2169429,size.width*0.7350338,size.height*0.1890672);
    frontDeltoid2.cubicTo(size.width*0.8307100,size.height*0.1762000,size.width*0.8626025,size.height*0.2174811,size.width*0.8801438,size.height*0.2533954);
    frontDeltoid2.close();

Paint paint_31_fill = Paint()..style=PaintingStyle.fill;
paint_31_fill.color = frontDeltoid2Color;
canvas.drawPath(frontDeltoid2,paint_31_fill);

_frontDeltoid2Path = Path()..addPath(frontDeltoid2, Offset.zero);

Path chest2a = Path();
    chest2a.moveTo(size.width*0.8173037,size.height*0.2489765);
    chest2a.cubicTo(size.width*0.7375575,size.height*0.1878508,size.width*0.7136350,size.height*0.1835605,size.width*0.5700925,size.height*0.1980387);
    chest2a.cubicTo(size.width*0.5700925,size.height*0.1980387,size.width*0.7504863,size.height*0.2427067,size.width*0.8173037,size.height*0.2489765);
    chest2a.close();

Paint paint_32_fill = Paint()..style=PaintingStyle.fill;
paint_32_fill.color = chest2Color;
canvas.drawPath(chest2a,paint_32_fill);

Path chest2b = Path();
    chest2b.moveTo(size.width*0.7834400,size.height*0.2519370);
    chest2b.cubicTo(size.width*0.6873825,size.height*0.2395403,size.width*0.5934975,size.height*0.2072618,size.width*0.5426538,size.height*0.2032122);
    chest2b.cubicTo(size.width*0.5342475,size.height*0.2025424,size.width*0.5262213,size.height*0.2046912,size.width*0.5262213,size.height*0.2075966);
    chest2b.lineTo(size.width*0.5262213,size.height*0.2484185);
    chest2b.cubicTo(size.width*0.5262213,size.height*0.2521971,size.width*0.5360825,size.height*0.2551210,size.width*0.5472325,size.height*0.2546504);
    chest2b.lineTo(size.width*0.7834400,size.height*0.2519370);
    chest2b.close();

Paint paint_33_fill = Paint()..style=PaintingStyle.fill;
paint_33_fill.color = chest2Color;
canvas.drawPath(chest2b,paint_33_fill);

Path chest2c = Path();
    chest2c.moveTo(size.width*0.7820900,size.height*0.2576521);
    chest2c.cubicTo(size.width*0.7458650,size.height*0.2858403,size.width*0.6220800,size.height*0.2824718,size.width*0.5336688,size.height*0.2700189);
    chest2c.cubicTo(size.width*0.5273000,size.height*0.2691193,size.width*0.5275350,size.height*0.2661349,size.width*0.5338700,size.height*0.2652092);
    chest2c.cubicTo(size.width*0.5957850,size.height*0.2561466,size.width*0.7613912,size.height*0.2564929,size.width*0.7821012,size.height*0.2576559);
    chest2c.lineTo(size.width*0.7820900,size.height*0.2576521);
    chest2c.close();

Paint paint_34_fill = Paint()..style=PaintingStyle.fill;
paint_34_fill.color = chest2Color;
canvas.drawPath(chest2c,paint_34_fill);

_chest2Path = Path()
  ..addPath(chest2a, Offset.zero)
  ..addPath(chest2b, Offset.zero)
  ..addPath(chest2c, Offset.zero);

Path obliques1a = Path();
    obliques1a.moveTo(size.width*0.2423938,size.height*0.2823803);
    obliques1a.cubicTo(size.width*0.2745212,size.height*0.2890790,size.width*0.2885700,size.height*0.2968164,size.width*0.3210325,size.height*0.2968164);
    obliques1a.lineTo(size.width*0.3293950,size.height*0.3263143);
    obliques1a.cubicTo(size.width*0.2799162,size.height*0.3217265,size.width*0.2449350,size.height*0.3099660,size.width*0.2423825,size.height*0.2823765);
    obliques1a.lineTo(size.width*0.2423938,size.height*0.2823803);
    obliques1a.close();

Paint paint_35_fill = Paint()..style=PaintingStyle.fill;
paint_35_fill.color = obliques1Color;
canvas.drawPath(obliques1a,paint_35_fill);

Path obliques1b = Path();
    obliques1b.moveTo(size.width*0.2529050,size.height*0.3162626);
    obliques1b.cubicTo(size.width*0.2803875,size.height*0.3266046,size.width*0.3067262,size.height*0.3330626,size.width*0.3313650,size.height*0.3336836);
    obliques1b.lineTo(size.width*0.3417312,size.height*0.3784756);
    obliques1b.cubicTo(size.width*0.2853350,size.height*0.3678441,size.width*0.2609650,size.height*0.3451357,size.width*0.2529050,size.height*0.3162664);
    obliques1b.lineTo(size.width*0.2529050,size.height*0.3162626);
    obliques1b.close();

Paint paint_36_fill = Paint()..style=PaintingStyle.fill;
paint_36_fill.color = obliques1Color;
canvas.drawPath(obliques1b,paint_36_fill);

Path obliques1c = Path();
    obliques1c.moveTo(size.width*0.2876025,size.height*0.3746214);
    obliques1c.lineTo(size.width*0.2808638,size.height*0.3968143);
    obliques1c.cubicTo(size.width*0.2780875,size.height*0.4096664,size.width*0.2891700,size.height*0.4224244,size.width*0.3120837,size.height*0.4327563);
    obliques1c.lineTo(size.width*0.3576213,size.height*0.4532857);
    obliques1c.lineTo(size.width*0.3484087,size.height*0.3944433);
    obliques1c.lineTo(size.width*0.2876138,size.height*0.3746252);
    obliques1c.lineTo(size.width*0.2876025,size.height*0.3746214);
    obliques1c.close();

Paint paint_37_fill = Paint()..style=PaintingStyle.fill;
paint_37_fill.color = obliques1Color;
canvas.drawPath(obliques1c,paint_37_fill);

_obliques1Path = Path()
  ..addPath(obliques1a, Offset.zero)
  ..addPath(obliques1b, Offset.zero)
  ..addPath(obliques1c, Offset.zero);

Path obliques2a = Path();
    obliques2a.moveTo(size.width*0.7518938,size.height*0.2823803);
    obliques2a.cubicTo(size.width*0.7197662,size.height*0.2890790,size.width*0.7057175,size.height*0.2968164,size.width*0.6732550,size.height*0.2968164);
    obliques2a.lineTo(size.width*0.6648925,size.height*0.3263143);
    obliques2a.cubicTo(size.width*0.7143713,size.height*0.3217265,size.width*0.7493525,size.height*0.3099660,size.width*0.7519050,size.height*0.2823765);
    obliques2a.lineTo(size.width*0.7518938,size.height*0.2823803);
    obliques2a.close();

Paint paint_38_fill = Paint()..style=PaintingStyle.fill;
paint_38_fill.color = obliques2Color;
canvas.drawPath(obliques2a,paint_38_fill);

Path obliques2b = Path();
    obliques2b.moveTo(size.width*0.7413650,size.height*0.3162626);
    obliques2b.cubicTo(size.width*0.7138825,size.height*0.3266046,size.width*0.6875438,size.height*0.3330626,size.width*0.6629050,size.height*0.3336836);
    obliques2b.lineTo(size.width*0.6525387,size.height*0.3784756);
    obliques2b.cubicTo(size.width*0.7089350,size.height*0.3678441,size.width*0.7333050,size.height*0.3451357,size.width*0.7413650,size.height*0.3162664);
    obliques2b.lineTo(size.width*0.7413650,size.height*0.3162626);
    obliques2b.close();

Paint paint_39_fill = Paint()..style=PaintingStyle.fill;
paint_39_fill.color = obliques2Color;
canvas.drawPath(obliques2b,paint_39_fill);

Path obliques2c = Path();
    obliques2c.moveTo(size.width*0.7066650,size.height*0.3746214);
    obliques2c.lineTo(size.width*0.7134038,size.height*0.3968143);
    obliques2c.cubicTo(size.width*0.7161800,size.height*0.4096664,size.width*0.7050975,size.height*0.4224244,size.width*0.6821837,size.height*0.4327563);
    obliques2c.lineTo(size.width*0.6366450,size.height*0.4532857);
    obliques2c.lineTo(size.width*0.6458588,size.height*0.3944433);
    obliques2c.lineTo(size.width*0.7066537,size.height*0.3746252);
    obliques2c.lineTo(size.width*0.7066650,size.height*0.3746214);
    obliques2c.close();

Paint paint_40_fill = Paint()..style=PaintingStyle.fill;
paint_40_fill.color = obliques2Color;
canvas.drawPath(obliques2c,paint_40_fill);

_obliques2Path = Path()
  ..addPath(obliques2a, Offset.zero)
  ..addPath(obliques2b, Offset.zero)
  ..addPath(obliques2c, Offset.zero);

Path path_41 = Path();
    path_41.moveTo(size.width*0.1010566,size.height*0.2844462);
    path_41.cubicTo(size.width*0.03707087,size.height*0.3089840,size.width*0.07386600,size.height*0.3463697,size.width*0.1081872,size.height*0.3707941);
    path_41.cubicTo(size.width*0.09063488,size.height*0.3401639,size.width*0.08439963,size.height*0.3109109,size.width*0.1010566,size.height*0.2844462);
    path_41.close();

Paint paint_41_fill = Paint()..style=PaintingStyle.fill;
paint_41_fill.color = AppColors.muscleDefaultColor;
canvas.drawPath(path_41,paint_41_fill);

Path bicep1 = Path();
    bicep1.moveTo(size.width*0.1539250,size.height*0.2712454);
    bicep1.cubicTo(size.width*0.1971125,size.height*0.2930244,size.width*0.2079150,size.height*0.3402176,size.width*0.1350300,size.height*0.3656282);
    bicep1.cubicTo(size.width*0.1053316,size.height*0.3620000,size.width*0.08643587,size.height*0.2757840,size.width*0.1539250,size.height*0.2712454);
    bicep1.close();

Paint paint_42_fill = Paint()..style=PaintingStyle.fill;
paint_42_fill.color = bicep1Color;
canvas.drawPath(bicep1,paint_42_fill);

_bicep1Path = Path()..addPath(bicep1, Offset.zero);

Path path_43 = Path();
    path_43.moveTo(size.width*0.8903825,size.height*0.2844462);
    path_43.cubicTo(size.width*0.9543688,size.height*0.3089840,size.width*0.9175738,size.height*0.3463697,size.width*0.8832525,size.height*0.3707941);
    path_43.cubicTo(size.width*0.9008038,size.height*0.3401639,size.width*0.9070400,size.height*0.3109109,size.width*0.8903825,size.height*0.2844462);
    path_43.close();

Paint paint_43_fill = Paint()..style=PaintingStyle.fill;
paint_43_fill.color = AppColors.muscleDefaultColor;
canvas.drawPath(path_43,paint_43_fill);

Path bicep2 = Path();
    bicep2.moveTo(size.width*0.8375013,size.height*0.2712454);
    bicep2.cubicTo(size.width*0.7943150,size.height*0.2930244,size.width*0.7835125,size.height*0.3402176,size.width*0.8563975,size.height*0.3656282);
    bicep2.cubicTo(size.width*0.8860950,size.height*0.3620000,size.width*0.9049912,size.height*0.2757840,size.width*0.8375013,size.height*0.2712454);
    bicep2.close();

Paint paint_44_fill = Paint()..style=PaintingStyle.fill;
paint_44_fill.color = bicep2Color;
canvas.drawPath(bicep2,paint_44_fill);

_bicep2Path = Path()..addPath(bicep2, Offset.zero);

Path abductors1 = Path();
    abductors1.moveTo(size.width*0.2556038,size.height*0.4590378);
    abductors1.lineTo(size.width*0.2753613,size.height*0.4663445);
    abductors1.cubicTo(size.width*0.2583575,size.height*0.4766723,size.width*0.2349725,size.height*0.5078361,size.width*0.2153387,size.height*0.5341092);
    abductors1.cubicTo(size.width*0.2145100,size.height*0.5105882,size.width*0.2303725,size.height*0.4834748,size.width*0.2556038,size.height*0.4590378);
    abductors1.close();

Paint paint_45_fill = Paint()..style=PaintingStyle.fill;
paint_45_fill.color = abductors1Color;
canvas.drawPath(abductors1,paint_45_fill);

_abductors1Path = Path()..addPath(abductors1, Offset.zero);

Path quadriceps1a = Path();
    quadriceps1a.moveTo(size.width*0.2972988,size.height*0.4736555);
    quadriceps1a.cubicTo(size.width*0.2769362,size.height*0.4634748,size.width*0.2373537,size.height*0.5526008,size.width*0.2373537,size.height*0.5750252);
    quadriceps1a.cubicTo(size.width*0.2373537,size.height*0.5974538,size.width*0.2418087,size.height*0.6179916,size.width*0.2816038,size.height*0.6260126);
    quadriceps1a.cubicTo(size.width*0.3152537,size.height*0.6327983,size.width*0.3298062,size.height*0.5988361,size.width*0.3369138,size.height*0.5730294);
    quadriceps1a.cubicTo(size.width*0.3470450,size.height*0.5362017,size.width*0.3418738,size.height*0.4959370,size.width*0.2972988,size.height*0.4736555);
    quadriceps1a.close();

Paint paint_46_fill = Paint()..style=PaintingStyle.fill;
paint_46_fill.color = quadriceps1Color;
canvas.drawPath(quadriceps1a,paint_46_fill);

Path adductors1 = Path();
    adductors1.moveTo(size.width*0.3432863,size.height*0.4891891);
    adductors1.lineTo(size.width*0.3890137,size.height*0.5168571);
    adductors1.cubicTo(size.width*0.4003650,size.height*0.5237269,size.width*0.4063650,size.height*0.5314496,size.width*0.4064438,size.height*0.5393151);
    adductors1.lineTo(size.width*0.4013725,size.height*0.5974244);
    adductors1.cubicTo(size.width*0.3541000,size.height*0.5570966,size.width*0.3663012,size.height*0.5091933,size.width*0.3432975,size.height*0.4891891);
    adductors1.lineTo(size.width*0.3432863,size.height*0.4891891);
    adductors1.close();

Paint paint_47_fill = Paint()..style=PaintingStyle.fill;
paint_47_fill.color = adductors1Color;
canvas.drawPath(adductors1,paint_47_fill);

_adductors1Path = Path()..addPath(adductors1, Offset.zero);

Path quadriceps1b = Path();
    quadriceps1b.moveTo(size.width*0.2153675,size.height*0.5440420);
    quadriceps1b.cubicTo(size.width*0.1868225,size.height*0.5769538,size.width*0.1789875,size.height*0.6420672,size.width*0.2166000,size.height*0.6688361);
    quadriceps1b.cubicTo(size.width*0.2245588,size.height*0.6745042,size.width*0.2488725,size.height*0.6741975,size.width*0.2557225,size.height*0.6683697);
    quadriceps1b.lineTo(size.width*0.2650137,size.height*0.6511261);
    quadriceps1b.cubicTo(size.width*0.2722562,size.height*0.6449580,size.width*0.2683838,size.height*0.6381303,size.width*0.2565850,size.height*0.6328193);
    quadriceps1b.cubicTo(size.width*0.2176400,size.height*0.6153067,size.width*0.2099388,size.height*0.5754958,size.width*0.2153788,size.height*0.5440420);
    quadriceps1b.lineTo(size.width*0.2153675,size.height*0.5440420);
    quadriceps1b.close();

Paint paint_48_fill = Paint()..style=PaintingStyle.fill;
paint_48_fill.color = quadriceps1Color;
canvas.drawPath(quadriceps1b,paint_48_fill);

Path quadriceps1c = Path();
    quadriceps1c.moveTo(size.width*0.3546937,size.height*0.5804664);
    quadriceps1c.cubicTo(size.width*0.3510888,size.height*0.6036681,size.width*0.3333238,size.height*0.6239412,size.width*0.3037037,size.height*0.6417773);
    quadriceps1c.cubicTo(size.width*0.2992825,size.height*0.6444412,size.width*0.2964837,size.height*0.6473697,size.width*0.2959138,size.height*0.6504118);
    quadriceps1c.lineTo(size.width*0.2951850,size.height*0.6543403);
    quadriceps1c.cubicTo(size.width*0.2938537,size.height*0.6614832,size.width*0.3039500,size.height*0.6683277,size.width*0.3216600,size.height*0.6722983);
    quadriceps1c.lineTo(size.width*0.3414850,size.height*0.6767395);
    quadriceps1c.cubicTo(size.width*0.3535075,size.height*0.6794328,size.width*0.3699062,size.height*0.6773067,size.width*0.3733650,size.height*0.6725882);
    quadriceps1c.cubicTo(size.width*0.3965937,size.height*0.6408782,size.width*0.4044738,size.height*0.6096891,size.width*0.3546937,size.height*0.5804622);
    quadriceps1c.lineTo(size.width*0.3546937,size.height*0.5804664);
    quadriceps1c.close();

Paint paint_49_fill = Paint()..style=PaintingStyle.fill;
paint_49_fill.color = quadriceps1Color;
canvas.drawPath(quadriceps1c,paint_49_fill);

_quadriceps1Path = Path()
  ..addPath(quadriceps1a, Offset.zero)
  ..addPath(quadriceps1b, Offset.zero)
  ..addPath(quadriceps1c, Offset.zero);

Path abductors2 = Path();
    abductors2.moveTo(size.width*0.7419237,size.height*0.4596765);
    abductors2.lineTo(size.width*0.7185063,size.height*0.4670840);
    abductors2.cubicTo(size.width*0.7355100,size.height*0.4774118,size.width*0.7588938,size.height*0.5085756,size.width*0.7785287,size.height*0.5348445);
    abductors2.cubicTo(size.width*0.7793575,size.height*0.5113277,size.width*0.7671550,size.height*0.4841134,size.width*0.7419350,size.height*0.4596765);
    abductors2.lineTo(size.width*0.7419237,size.height*0.4596765);
    abductors2.close();

Paint paint_50_fill = Paint()..style=PaintingStyle.fill;
paint_50_fill.color = abductors2Color;
canvas.drawPath(abductors2,paint_50_fill);

_abductors2Path = Path()..addPath(abductors2, Offset.zero);

Path quadriceps2a = Path();
    quadriceps2a.moveTo(size.width*0.6966138,size.height*0.4743950);
    quadriceps2a.cubicTo(size.width*0.7169762,size.height*0.4642143,size.width*0.7565588,size.height*0.5533403,size.width*0.7565588,size.height*0.5757647);
    quadriceps2a.cubicTo(size.width*0.7565588,size.height*0.5981891,size.width*0.7521025,size.height*0.6187269,size.width*0.7123075,size.height*0.6267521);
    quadriceps2a.cubicTo(size.width*0.6786588,size.height*0.6335378,size.width*0.6641063,size.height*0.5995714,size.width*0.6569975,size.height*0.5737647);
    quadriceps2a.cubicTo(size.width*0.6468675,size.height*0.5369412,size.width*0.6520388,size.height*0.4966723,size.width*0.6966138,size.height*0.4743950);
    quadriceps2a.close();

Paint paint_51_fill = Paint()..style=PaintingStyle.fill;
paint_51_fill.color = quadriceps2Color;
canvas.drawPath(quadriceps2a,paint_51_fill);

Path adductors2 = Path();
    adductors2.moveTo(size.width*0.6505600,size.height*0.4899244);
    adductors2.lineTo(size.width*0.6048312,size.height*0.5175924);
    adductors2.cubicTo(size.width*0.5934812,size.height*0.5244664,size.width*0.5874812,size.height*0.5321891,size.width*0.5874025,size.height*0.5400504);
    adductors2.lineTo(size.width*0.5924738,size.height*0.5981597);
    adductors2.cubicTo(size.width*0.6397462,size.height*0.5578319,size.width*0.6275450,size.height*0.5099328,size.width*0.6505488,size.height*0.4899244);
    adductors2.lineTo(size.width*0.6505600,size.height*0.4899244);
    adductors2.close();

Paint paint_52_fill = Paint()..style=PaintingStyle.fill;
paint_52_fill.color = adductors2Color;
canvas.drawPath(adductors2,paint_52_fill);

_adductors2Path = Path()..addPath(adductors2, Offset.zero);

Path quadriceps2b = Path();
    quadriceps2b.moveTo(size.width*0.7784750,size.height*0.5447815);
    quadriceps2b.cubicTo(size.width*0.8070200,size.height*0.5776933,size.width*0.8148563,size.height*0.6428025,size.width*0.7772438,size.height*0.6695714);
    quadriceps2b.cubicTo(size.width*0.7692850,size.height*0.6752395,size.width*0.7449713,size.height*0.6749328,size.width*0.7381200,size.height*0.6691050);
    quadriceps2b.lineTo(size.width*0.7288288,size.height*0.6518613);
    quadriceps2b.cubicTo(size.width*0.7215862,size.height*0.6456975,size.width*0.7254600,size.height*0.6388655,size.width*0.7372587,size.height*0.6335546);
    quadriceps2b.cubicTo(size.width*0.7762025,size.height*0.6160462,size.width*0.7839038,size.height*0.5762311,size.width*0.7784638,size.height*0.5447815);
    quadriceps2b.lineTo(size.width*0.7784750,size.height*0.5447815);
    quadriceps2b.close();

Paint paint_53_fill = Paint()..style=PaintingStyle.fill;
paint_53_fill.color = quadriceps2Color;
canvas.drawPath(quadriceps2b,paint_53_fill);

Path quadriceps2c = Path();
    quadriceps2c.moveTo(size.width*0.6391850,size.height*0.5812017);
    quadriceps2c.cubicTo(size.width*0.6427900,size.height*0.6044034,size.width*0.6605550,size.height*0.6246765,size.width*0.6901738,size.height*0.6425084);
    quadriceps2c.cubicTo(size.width*0.6945963,size.height*0.6451723,size.width*0.6973950,size.height*0.6481008,size.width*0.6979650,size.height*0.6511471);
    quadriceps2c.lineTo(size.width*0.6986925,size.height*0.6550756);
    quadriceps2c.cubicTo(size.width*0.7000250,size.height*0.6622185,size.width*0.6899275,size.height*0.6690588,size.width*0.6722188,size.height*0.6730294);
    quadriceps2c.lineTo(size.width*0.6523937,size.height*0.6774706);
    quadriceps2c.cubicTo(size.width*0.6403713,size.height*0.6801681,size.width*0.6239725,size.height*0.6780420,size.width*0.6205137,size.height*0.6733235);
    quadriceps2c.cubicTo(size.width*0.5972850,size.height*0.6416134,size.width*0.5894050,size.height*0.6104244,size.width*0.6391850,size.height*0.5811975);
    quadriceps2c.lineTo(size.width*0.6391850,size.height*0.5812017);
    quadriceps2c.close();

Paint paint_54_fill = Paint()..style=PaintingStyle.fill;
paint_54_fill.color = quadriceps2Color;
canvas.drawPath(quadriceps2c,paint_54_fill);

_quadriceps2Path = Path()
  ..addPath(quadriceps2a, Offset.zero)
  ..addPath(quadriceps2b, Offset.zero)
  ..addPath(quadriceps2c, Offset.zero);

Path forearms1a = Path();
    forearms1a.moveTo(size.width*0.03262050,size.height*0.3986588);
    forearms1a.cubicTo(size.width*0.03689675,size.height*0.4209538,size.width*0.05200875,size.height*0.4522395,size.width*0.06831862,size.height*0.4899244);
    forearms1a.cubicTo(size.width*0.06941575,size.height*0.4924664,size.width*0.06584475,size.height*0.4950042,size.width*0.05928500,size.height*0.4963109);
    forearms1a.lineTo(size.width*0.05196400,size.height*0.4977689);
    forearms1a.cubicTo(size.width*0.04388188,size.height*0.4993739,size.width*0.03388550,size.height*0.4971681,size.width*0.03511687,size.height*0.4940420);
    forearms1a.cubicTo(size.width*0.04665800,size.height*0.4645672,size.width*0.009101650,size.height*0.3992345,size.width*0.02600475,size.height*0.3793525);

Paint paint_55_fill = Paint()..style=PaintingStyle.fill;
paint_55_fill.color = forearms1Color;
canvas.drawPath(forearms1a,paint_55_fill);

Path forearms1b = Path();
    forearms1b.moveTo(size.width*0.04894288,size.height*0.3783067);
    forearms1b.cubicTo(size.width*0.08043200,size.height*0.3909181,size.width*0.1265513,size.height*0.4321050,size.width*0.08059988,size.height*0.4832185);
    forearms1b.cubicTo(size.width*0.04597637,size.height*0.4326261,size.width*0.03467037,size.height*0.3725903,size.width*0.04894288,size.height*0.3783067);
    forearms1b.close();

Paint paint_56_fill = Paint()..style=PaintingStyle.fill;
paint_56_fill.color = forearms1Color;
canvas.drawPath(forearms1b,paint_56_fill);

Path forearms1c = Path();
    forearms1c.moveTo(size.width*0.1687562,size.height*0.3884340);
    forearms1c.cubicTo(size.width*0.1858950,size.height*0.4060277,size.width*0.1652425,size.height*0.4273025,size.width*0.1211258,size.height*0.4500126);
    forearms1c.cubicTo(size.width*0.1075025,size.height*0.4226303,size.width*0.1053532,size.height*0.4001567,size.width*0.1687562,size.height*0.3884340);
    forearms1c.close();

Paint paint_57_fill = Paint()..style=PaintingStyle.fill;
paint_57_fill.color = forearms1Color;
canvas.drawPath(forearms1c,paint_57_fill);

_forearms1Path = Path()
  ..addPath(forearms1a, Offset.zero)
  ..addPath(forearms1b, Offset.zero)
  ..addPath(forearms1c, Offset.zero);

Path forearms2a = Path();
    forearms2a.moveTo(size.width*0.9565238,size.height*0.3977542);
    forearms2a.cubicTo(size.width*0.9522475,size.height*0.4200487,size.width*0.9371363,size.height*0.4513319,size.width*0.9208262,size.height*0.4890210);
    forearms2a.cubicTo(size.width*0.9197287,size.height*0.4915630,size.width*0.9233000,size.height*0.4940966,size.width*0.9298600,size.height*0.4954076);
    forearms2a.lineTo(size.width*0.9371813,size.height*0.4968655);
    forearms2a.cubicTo(size.width*0.9452625,size.height*0.4984706,size.width*0.9552587,size.height*0.4962647,size.width*0.9540275,size.height*0.4931387);
    forearms2a.cubicTo(size.width*0.9424862,size.height*0.4636639,size.width*0.9800425,size.height*0.3983298,size.width*0.9631400,size.height*0.3784479);

Paint paint_58_fill = Paint()..style=PaintingStyle.fill;
paint_58_fill.color = forearms2Color;
canvas.drawPath(forearms2a,paint_58_fill);

Path forearms2b = Path();
    forearms2b.moveTo(size.width*0.9401725,size.height*0.3774063);
    forearms2b.cubicTo(size.width*0.9086838,size.height*0.3900172,size.width*0.8625637,size.height*0.4312059,size.width*0.9085150,size.height*0.4823193);
    forearms2b.cubicTo(size.width*0.9431387,size.height*0.4317227,size.width*0.9544450,size.height*0.3716895,size.width*0.9401725,size.height*0.3774063);
    forearms2b.close();

Paint paint_59_fill = Paint()..style=PaintingStyle.fill;
paint_59_fill.color = forearms2Color;
canvas.drawPath(forearms2b,paint_59_fill);

Path forearms2c = Path();
    forearms2c.moveTo(size.width*0.8203388,size.height*0.3875332);
    forearms2c.cubicTo(size.width*0.8032013,size.height*0.4051273,size.width*0.8238537,size.height*0.4264034,size.width*0.8679700,size.height*0.4491092);
    forearms2c.cubicTo(size.width*0.8815938,size.height*0.4217311,size.width*0.8837425,size.height*0.3992563,size.width*0.8203388,size.height*0.3875332);
    forearms2c.close();

Paint paint_60_fill = Paint()..style=PaintingStyle.fill;
paint_60_fill.color = forearms2Color;
canvas.drawPath(forearms2c,paint_60_fill);

_forearms2Path = Path()
  ..addPath(forearms2a, Offset.zero)
  ..addPath(forearms2b, Offset.zero)
  ..addPath(forearms2c, Offset.zero);

Path path_61 = Path();
    path_61.moveTo(size.width*0.1886913,size.height*0.7548193);
    path_61.cubicTo(size.width*0.2111463,size.height*0.7538739,size.width*0.2305125,size.height*0.7799580,size.width*0.2392100,size.height*0.7938782);
    path_61.cubicTo(size.width*0.2424012,size.height*0.7989832,size.width*0.2444050,size.height*0.8041513,size.width*0.2452663,size.height*0.8093571);
    path_61.lineTo(size.width*0.2562025,size.height*0.8752647);
    path_61.cubicTo(size.width*0.2567850,size.height*0.8787899,size.width*0.2569088,size.height*0.8823277,size.width*0.2565725,size.height*0.8858571);
    path_61.lineTo(size.width*0.2526438,size.height*0.9266134);
    path_61.cubicTo(size.width*0.2513450,size.height*0.9302143,size.width*0.2360875,size.height*0.9304748,size.width*0.2337588,size.height*0.9269328);
    path_61.cubicTo(size.width*0.2245350,size.height*0.9129622,size.width*0.2110125,size.height*0.8916849,size.width*0.1963362,size.height*0.8659622);
    path_61.cubicTo(size.width*0.1695825,size.height*0.8190630,size.width*0.1581200,size.height*0.7561050,size.width*0.1886913,size.height*0.7548193);
    path_61.close();

Paint paint_61_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01437200;
paint_61_stroke.color=Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_61,paint_61_stroke);

Paint paint_61_fill = Paint()..style=PaintingStyle.fill;
paint_61_fill.color = AppColors.muscleDefaultColor;
canvas.drawPath(path_61,paint_61_fill);

Path path_62 = Path();
    path_62.moveTo(size.width*0.3174088,size.height*0.7693824);
    path_62.cubicTo(size.width*0.3227488,size.height*0.7653361,size.width*0.3402225,size.height*0.7657899,size.width*0.3434575,size.height*0.7700798);
    path_62.cubicTo(size.width*0.3505213,size.height*0.7794412,size.width*0.3614025,size.height*0.7940672,size.width*0.3536338,size.height*0.8092857);
    path_62.cubicTo(size.width*0.3395513,size.height*0.8368613,size.width*0.2999125,size.height*0.8420168,size.width*0.2865362,size.height*0.8782101);
    path_62.cubicTo(size.width*0.2857750,size.height*0.8802773,size.width*0.2755875,size.height*0.8795210,size.width*0.2756100,size.height*0.8774412);
    path_62.cubicTo(size.width*0.2758788,size.height*0.8429244,size.width*0.2812075,size.height*0.7968025,size.width*0.3174200,size.height*0.7693782);
    path_62.lineTo(size.width*0.3174088,size.height*0.7693824);
    path_62.close();

Paint paint_62_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01437200;
paint_62_stroke.color=Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_62,paint_62_stroke);

Paint paint_62_fill = Paint()..style=PaintingStyle.fill;
paint_62_fill.color = AppColors.muscleDefaultColor;
canvas.drawPath(path_62,paint_62_fill);

Path path_63 = Path();
    path_63.moveTo(size.width*0.8163325,size.height*0.7548193);
    path_63.cubicTo(size.width*0.7938763,size.height*0.7538739,size.width*0.7745112,size.height*0.7799580,size.width*0.7658125,size.height*0.7938782);
    path_63.cubicTo(size.width*0.7626225,size.height*0.7989832,size.width*0.7606188,size.height*0.8041513,size.width*0.7597575,size.height*0.8093571);
    path_63.lineTo(size.width*0.7488200,size.height*0.8752647);
    path_63.cubicTo(size.width*0.7482387,size.height*0.8787899,size.width*0.7481150,size.height*0.8823277,size.width*0.7484513,size.height*0.8858571);
    path_63.lineTo(size.width*0.7523800,size.height*0.9266134);
    path_63.cubicTo(size.width*0.7536787,size.height*0.9302143,size.width*0.7689362,size.height*0.9304748,size.width*0.7712650,size.height*0.9269328);
    path_63.cubicTo(size.width*0.7804888,size.height*0.9129622,size.width*0.7940112,size.height*0.8916849,size.width*0.8086863,size.height*0.8659622);
    path_63.cubicTo(size.width*0.8354400,size.height*0.8190630,size.width*0.8469038,size.height*0.7561050,size.width*0.8163325,size.height*0.7548193);
    path_63.close();

Paint paint_63_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01437200;
paint_63_stroke.color=Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_63,paint_63_stroke);

Paint paint_63_fill = Paint()..style=PaintingStyle.fill;
paint_63_fill.color = AppColors.muscleDefaultColor;
canvas.drawPath(path_63,paint_63_fill);

Path path_64 = Path();
    path_64.moveTo(size.width*0.6848063,size.height*0.7693824);
    path_64.cubicTo(size.width*0.6794675,size.height*0.7653361,size.width*0.6619925,size.height*0.7657899,size.width*0.6587575,size.height*0.7700798);
    path_64.cubicTo(size.width*0.6516937,size.height*0.7794412,size.width*0.6441050,size.height*0.7939244,size.width*0.6485825,size.height*0.8092857);
    path_64.cubicTo(size.width*0.6543362,size.height*0.8290210,size.width*0.6914225,size.height*0.8374874,size.width*0.7156800,size.height*0.8782101);
    path_64.cubicTo(size.width*0.7169000,size.height*0.8802521,size.width*0.7266275,size.height*0.8795210,size.width*0.7266050,size.height*0.8774412);
    path_64.cubicTo(size.width*0.7263375,size.height*0.8429244,size.width*0.7210087,size.height*0.7968025,size.width*0.6847950,size.height*0.7693782);
    path_64.lineTo(size.width*0.6848063,size.height*0.7693824);
    path_64.close();

Paint paint_64_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.01437200;
paint_64_stroke.color=Color(0xff242424).withOpacity(1.0);
canvas.drawPath(path_64,paint_64_stroke);

Paint paint_64_fill = Paint()..style=PaintingStyle.fill;
paint_64_fill.color = AppColors.muscleDefaultColor;
canvas.drawPath(path_64,paint_64_fill);

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
}
}