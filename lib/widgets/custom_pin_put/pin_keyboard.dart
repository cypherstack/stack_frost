import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';

class NumberKey extends StatefulWidget {
  const NumberKey({
    Key? key,
    required this.number,
    required this.onPressed,
  }) : super(key: key);

  final String number;
  final ValueSetter<String> onPressed;

  @override
  State<NumberKey> createState() => _NumberKeyState();
}

class _NumberKeyState extends State<NumberKey> {
  late final String number;
  late final ValueSetter<String> onPressed;

  Color? _color;

  @override
  void initState() {
    number = widget.number;
    onPressed = widget.onPressed;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _color ??= Theme.of(context).extension<StackColors>()!.numberBackDefault;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 72,
      width: 72,
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: _color,
        shadows: const [],
      ),
      child: MaterialButton(
        // splashColor: Theme.of(context).extension<StackColors>()!.highlight,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        onPressed: () async {
          onPressed.call(number);
          setState(() {
            _color = Theme.of(context)
                .extension<StackColors>()!
                .numberBackDefault
                .withOpacity(0.8);
          });

          Future<void>.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              setState(() {
                _color = Theme.of(context)
                    .extension<StackColors>()!
                    .numberBackDefault;
              });
            }
          });
        },
        child: Center(
          child: Text(
            number,
            style: STextStyles.numberDefault(context),
          ),
        ),
      ),
    );
  }
}

class BackspaceKey extends StatefulWidget {
  const BackspaceKey({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  State<BackspaceKey> createState() => _BackspaceKeyState();
}

class _BackspaceKeyState extends State<BackspaceKey> {
  late final VoidCallback onPressed;

  Color? _color;

  @override
  void initState() {
    onPressed = widget.onPressed;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _color ??= Theme.of(context).extension<StackColors>()!.numpadBackDefault;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 72,
      width: 72,
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: _color,
        shadows: const [],
      ),
      child: MaterialButton(
        // splashColor: Theme.of(context).extension<StackColors>()!.highlight,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        onPressed: () {
          onPressed.call();
          setState(() {
            _color = Theme.of(context)
                .extension<StackColors>()!
                .numpadBackDefault
                .withOpacity(0.8);
          });

          Future<void>.delayed(const Duration(milliseconds: 200), () {
            if (mounted) {
              setState(() {
                _color = Theme.of(context)
                    .extension<StackColors>()!
                    .numpadBackDefault;
              });
            }
          });
        },
        child: Center(
          child: SvgPicture.asset(
            Assets.svg.delete,
            width: 20,
            height: 20,
            color:
                Theme.of(context).extension<StackColors>()!.numpadTextDefault,
          ),
        ),
      ),
    );
  }
}

class SubmitKey extends StatelessWidget {
  const SubmitKey({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: 72,
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: Theme.of(context).extension<StackColors>()!.numpadBackDefault,
        shadows: const [],
      ),
      child: MaterialButton(
        // splashColor: Theme.of(context).extension<StackColors>()!.highlight,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        onPressed: () {
          onPressed.call();
        },
        child: Center(
          child: SvgPicture.asset(
            Assets.svg.arrowRight,
            width: 20,
            height: 20,
            color:
                Theme.of(context).extension<StackColors>()!.numpadTextDefault,
          ),
        ),
      ),
    );
  }
}

class CustomKey extends StatelessWidget {
  const CustomKey({
    Key? key,
    required this.onPressed,
    this.iconAssetName,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String? iconAssetName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      width: 72,
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: Theme.of(context).extension<StackColors>()!.numpadBackDefault,
        shadows: const [],
      ),
      child: MaterialButton(
        // splashColor: Theme.of(context).extension<StackColors>()!.highlight,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        onPressed: () {
          onPressed.call();
        },
        child: Center(
          child: iconAssetName == null
              ? null
              : SvgPicture.asset(
                  iconAssetName!,
                  width: 20,
                  height: 20,
                  color: Theme.of(context)
                      .extension<StackColors>()!
                      .numpadTextDefault,
                ),
        ),
      ),
    );
  }
}

class PinKeyboard extends ConsumerWidget {
  const PinKeyboard({
    Key? key,
    required this.onNumberKeyPressed,
    required this.onBackPressed,
    required this.onSubmitPressed,
    this.backgroundColor,
    this.width = 264,
    this.height = 360,
    this.customKey,
  }) : super(key: key);

  final ValueSetter<String> onNumberKeyPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onSubmitPressed;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final CustomKey? customKey;

  void _backHandler() {
    onBackPressed.call();
  }

  void _submitHandler() {
    onSubmitPressed.call();
  }

  void _numberHandler(String number) {
    onNumberKeyPressed.call(number);
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "0",
    ];

    // if (ref.read(prefsChangeNotifierProvider).randomizePIN == true)
    list.shuffle();

    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? Colors.transparent,
      child: Column(
        children: [
          Row(
            children: [
              NumberKey(
                number: list[0],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[1],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[2],
                onPressed: _numberHandler,
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              NumberKey(
                number: list[3],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[4],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[5],
                onPressed: _numberHandler,
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              NumberKey(
                number: list[6],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[7],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[8],
                onPressed: _numberHandler,
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              BackspaceKey(
                onPressed: _backHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[9],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              SubmitKey(
                onPressed: _submitHandler,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class RandomKeyboard extends StatelessWidget {
  const RandomKeyboard({
    Key? key,
    required this.onNumberKeyPressed,
    required this.onBackPressed,
    required this.onSubmitPressed,
    this.backgroundColor,
    this.width = 264,
    this.height = 360,
    this.customKey,
  }) : super(key: key);

  final ValueSetter<String> onNumberKeyPressed;
  final VoidCallback onBackPressed;
  final VoidCallback onSubmitPressed;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final CustomKey? customKey;

  void _backHandler() {
    onBackPressed.call();
  }

  void _submitHandler() {
    onSubmitPressed.call();
  }

  void _numberHandler(String number) {
    onNumberKeyPressed.call(number);
    HapticFeedback.lightImpact();
    debugPrint("NUMBER: $number");
  }

  @override
  Widget build(BuildContext context) {
    final list = [
      "1",
      "2",
      "3",
      "4",
      "5",
      "6",
      "7",
      "8",
      "9",
      "0",
    ];
    list.shuffle();
    return Container(
      width: width,
      height: height,
      color: backgroundColor ?? Colors.transparent,
      child: Column(
        children: [
          Row(
            children: [
              NumberKey(
                number: list[0],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[1],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[2],
                onPressed: _numberHandler,
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              NumberKey(
                number: list[3],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[4],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[5],
                onPressed: _numberHandler,
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              NumberKey(
                number: list[6],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[7],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[8],
                onPressed: _numberHandler,
              ),
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          Row(
            children: [
              BackspaceKey(
                onPressed: _backHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              NumberKey(
                number: list[9],
                onPressed: _numberHandler,
              ),
              const SizedBox(
                width: 24,
              ),
              SubmitKey(
                onPressed: _submitHandler,
              ),
            ],
          )
        ],
      ),
    );
  }
}
