import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stackfrost/utilities/enums/coin_enum.dart';
import 'package:stackfrost/utilities/text_styles.dart';

class FeeSlider extends StatefulWidget {
  const FeeSlider({
    super.key,
    required this.onSatVByteChanged,
    required this.coin,
  });

  final Coin coin;
  final void Function(int) onSatVByteChanged;

  @override
  State<FeeSlider> createState() => _FeeSliderState();
}

class _FeeSliderState extends State<FeeSlider> {
  static const double min = 1;
  static const double max = 4;

  double sliderValue = 0;

  int rate = min.toInt();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Fees (sat/vByte)",
              style: STextStyles.smallMed12(context),
            ),
            Text(
              "$rate",
              style: STextStyles.smallMed12(context),
            ),
          ],
        ),
        Slider(
          value: sliderValue,
          onChanged: (value) {
            setState(() {
              sliderValue = value;
              final number = pow(sliderValue * (max - min) + min, 4).toDouble();
              rate = number.toInt();
            });
            widget.onSatVByteChanged(rate);
          },
        ),
      ],
    );
  }
}
