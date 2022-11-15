import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/pages/settings_views/global_settings_view/syncing_preferences_views/syncing_options_view.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/widgets/desktop/primary_button.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';

class SyncingPreferencesSettings extends ConsumerStatefulWidget {
  const SyncingPreferencesSettings({Key? key}) : super(key: key);

  static const String routeName = "/settingsMenuSyncingPref";

  @override
  ConsumerState<SyncingPreferencesSettings> createState() =>
      _SyncingPreferencesSettings();
}

class _SyncingPreferencesSettings
    extends ConsumerState<SyncingPreferencesSettings> {
  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            right: 30,
          ),
          child: RoundedWhiteContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    Assets.svg.circleArrowRotate,
                    width: 48,
                    height: 48,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: RichText(
                        textAlign: TextAlign.start,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Syncing Preferences",
                              style: STextStyles.desktopTextSmall(context),
                            ),
                            TextSpan(
                              text:
                                  "\nSet up your syncing preferences for all wallets in your Stack.",
                              style: STextStyles.desktopTextExtraExtraSmall(
                                  context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                ///TODO: ONLY SHOW SYNC OPTIONS ON BUTTON PRESS
                Column(
                  children: [
                    SyncingOptionsView(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(
                        10,
                      ),
                      child: PrimaryButton(
                        width: 210,
                        desktopMed: true,
                        enabled: true,
                        label: "Change preferences",
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
