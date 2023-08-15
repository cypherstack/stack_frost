import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stackfrost/pages/settings_views/wallet_settings_view/frost_ms/reshare_ms_config_view.dart';
import 'package:stackfrost/pages_desktop_specific/my_stack_view/exit_to_my_stack_button.dart';
import 'package:stackfrost/providers/frost_wallet/frost_wallet_providers.dart';
import 'package:stackfrost/providers/global/wallets_provider.dart';
import 'package:stackfrost/services/coins/bitcoin/frost_wallet.dart';
import 'package:stackfrost/services/frost.dart';
import 'package:stackfrost/themes/stack_colors.dart';
import 'package:stackfrost/utilities/text_styles.dart';
import 'package:stackfrost/utilities/util.dart';
import 'package:stackfrost/widgets/background.dart';
import 'package:stackfrost/widgets/conditional_parent.dart';
import 'package:stackfrost/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackfrost/widgets/desktop/desktop_app_bar.dart';
import 'package:stackfrost/widgets/desktop/desktop_scaffold.dart';
import 'package:stackfrost/widgets/desktop/primary_button.dart';
import 'package:stackfrost/widgets/stack_dialog.dart';

final class ModifyParticipantsView extends ConsumerStatefulWidget {
  const ModifyParticipantsView({
    super.key,
    required this.walletId,
  });

  static const String routeName = "/modifyParticipantsView";

  final String walletId;

  @override
  ConsumerState<ModifyParticipantsView> createState() =>
      _ModifyParticipantsViewState();
}

class _ModifyParticipantsViewState
    extends ConsumerState<ModifyParticipantsView> {
  final _thresholdController = TextEditingController();
  final _participantsController = TextEditingController();

  final List<TextEditingController> controllers = [];

  int _participantsCount = 0;

  String _validateInputData(FrostWallet wallet) {
    final threshold = int.tryParse(_thresholdController.text);
    if (threshold == null) {
      return "Choose a threshold";
    }

    final partsCount = int.tryParse(_participantsController.text);
    if (partsCount == null) {
      return "Choose total number of participants";
    }

    if (threshold > partsCount) {
      return "Threshold cannot be greater than the number of participants";
    }

    if (controllers.length != partsCount) {
      return "Participants count error";
    }

    int oldSignersCount = 0;
    for (final controller in controllers) {
      if (wallet.participants.contains(controller.text)) {
        oldSignersCount++;
      }
    }
    if (wallet.threshold > oldSignersCount) {
      return "Must keep at least ${wallet.threshold} previous participants";
    }

    final hasEmptyParticipants = controllers
        .map((e) => e.text.isEmpty)
        .reduce((value, element) => value |= element);
    if (hasEmptyParticipants) {
      return "Participants must not be empty";
    }

    // TODO not sure if duplicate participant names are allowed
    if (controllers.length != controllers.map((e) => e.text).toSet().length) {
      return "Duplicate participant name found";
    }

    return "valid";
  }

  void _participantsCountChanged(String newValue) {
    final count = int.tryParse(newValue);
    if (count != null) {
      if (count > _participantsCount) {
        for (int i = _participantsCount; i < count; i++) {
          controllers.add(TextEditingController());
        }

        _participantsCount = count;
        setState(() {});
      } else if (count < _participantsCount) {
        for (int i = _participantsCount; i > count; i--) {
          final last = controllers.removeLast();
          last.dispose();
        }

        _participantsCount = count;
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    final wallet = ref
        .read(walletsChangeNotifierProvider)
        .getManager(widget.walletId)
        .wallet as FrostWallet;

    ref.read(pFrostMyName.state).state = wallet.myName;

    for (final participant in wallet.participants) {
      controllers.add(TextEditingController()..text = participant);
    }

    _thresholdController.text = wallet.threshold.toString();
    _participantsController.text = wallet.participants.length.toString();

    super.initState();
  }

  @override
  void dispose() {
    _thresholdController.dispose();
    _participantsController.dispose();
    for (final e in controllers) {
      e.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConditionalParent(
      condition: Util.isDesktop,
      builder: (child) => DesktopScaffold(
        background: Theme.of(context).extension<StackColors>()!.background,
        appBar: const DesktopAppBar(
          isCompactHeight: false,
          leading: AppBarBackButton(),
          trailing: ExitToMyStackButton(),
        ),
        body: SizedBox(
          width: 480,
          child: child,
        ),
      ),
      child: ConditionalParent(
        condition: !Util.isDesktop,
        builder: (child) => Background(
          child: Scaffold(
            backgroundColor:
                Theme.of(context).extension<StackColors>()!.background,
            appBar: AppBar(
              leading: AppBarBackButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              title: Text(
                "Modify Participants",
                style: STextStyles.navBarTitle(context),
              ),
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: child,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Edit threshold",
              style: STextStyles.label(context),
            ),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _thresholdController,
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Edit number of participants",
              style: STextStyles.label(context),
            ),
            TextField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _participantsController,
              onChanged: _participantsCountChanged,
            ),
            const SizedBox(
              height: 16,
            ),
            if (controllers.isNotEmpty)
              Column(
                children: [
                  for (int i = 0; i < controllers.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ),
                      child: TextField(
                        enabled: controllers[i].text !=
                            ref.watch(pFrostMyName.state).state!,
                        controller: controllers[i],
                      ),
                    ),
                ],
              ),
            if (!Util.isDesktop) const Spacer(),
            const SizedBox(
              height: 16,
            ),
            PrimaryButton(
              label: "Generate",
              onPressed: () async {
                if (FocusScope.of(context).hasFocus) {
                  FocusScope.of(context).unfocus();
                }
                final wallet = ref
                    .read(walletsChangeNotifierProvider)
                    .getManager(widget.walletId)
                    .wallet as FrostWallet;
                final validationMessage = _validateInputData(wallet);

                if (validationMessage != "valid") {
                  return await showDialog<void>(
                    context: context,
                    builder: (_) => StackOkDialog(
                      title: validationMessage,
                      desktopPopRootNavigator: Util.isDesktop,
                    ),
                  );
                }

                final config = Frost.createMultisigConfig(
                  name: ref.watch(pFrostMyName.state).state!,
                  threshold: int.parse(_thresholdController.text),
                  participants: controllers.map((e) => e.text).toList(),
                );

                ref.read(pFrostMyName.notifier).state = controllers.first.text;
                ref.read(pFrostMultisigConfig.notifier).state = config;

                await Navigator.of(context).pushNamed(
                  ReshareMultisigConfigView.routeName,
                  arguments: widget.walletId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
