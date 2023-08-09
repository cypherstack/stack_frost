import 'package:flutter/material.dart';
import 'package:stackfrost/services/frost.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';

class ShareNewMultisigConfigView extends StatefulWidget {
  const ShareNewMultisigConfigView({
    super.key,
    required this.config,
    required this.participants,
  });

  static const String routeName = "/shareNewMultisigConfigView";

  final String config;
  final List<String> participants;

  @override
  State<ShareNewMultisigConfigView> createState() =>
      _ShareNewMultisigConfigViewState();
}

class _ShareNewMultisigConfigViewState
    extends State<ShareNewMultisigConfigView> {
  @override
  Widget build(BuildContext context) {
    return Background(
      child: Scaffold(
        backgroundColor: Theme.of(context).extension<StackColors>()!.background,
        appBar: AppBar(
          leading: AppBarBackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            "Multisig config",
            style: STextStyles.navBarTitle(context),
          ),
        ),
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "Config",
                          style: STextStyles.label(context),
                        ),

                        const SizedBox(
                          height: 16,
                        ),
                        SelectableText(
                          widget.config,
                          style: STextStyles.itemSubtitle(context),
                        ),

                        // TODO QR code

                        const Spacer(),
                        PrimaryButton(
                          label: "Start key generation",
                          onPressed: () async {
                            final data = Frost.startKeyGeneration(
                              multisigConfig: widget.config,
                              myName: widget.participants.first,
                            );

                            print(data.seed);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
