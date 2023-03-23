import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:isar/isar.dart';
import 'package:stackwallet/models/contact.dart';
import 'package:stackwallet/models/isar/models/blockchain_data/transaction.dart';
import 'package:stackwallet/models/isar/models/isar_models.dart';
import 'package:stackwallet/pages/address_book_views/subviews/add_new_contact_address_view.dart';
import 'package:stackwallet/pages_desktop_specific/address_book_view/subwidgets/desktop_address_card.dart';
import 'package:stackwallet/pages_desktop_specific/address_book_view/subwidgets/desktop_contact_options_menu_popup.dart';
import 'package:stackwallet/providers/global/address_book_service_provider.dart';
import 'package:stackwallet/providers/global/wallets_provider.dart';
import 'package:stackwallet/providers/ui/address_book_providers/address_entry_data_provider.dart';
import 'package:stackwallet/services/coins/manager.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/custom_buttons/blue_text_button.dart';
import 'package:stackwallet/widgets/desktop/desktop_dialog.dart';
import 'package:stackwallet/widgets/desktop/secondary_button.dart';
import 'package:stackwallet/widgets/loading_indicator.dart';
import 'package:stackwallet/widgets/rounded_white_container.dart';
import 'package:stackwallet/widgets/transaction_card.dart';
import 'package:tuple/tuple.dart';

import '../../../db/main_db.dart';

class DesktopContactDetails extends ConsumerStatefulWidget {
  const DesktopContactDetails({
    Key? key,
    required this.contactId,
  }) : super(key: key);

  final String contactId;

  @override
  ConsumerState<DesktopContactDetails> createState() =>
      _DesktopContactDetailsState();
}

class _DesktopContactDetailsState extends ConsumerState<DesktopContactDetails> {
  List<Tuple2<String, Transaction>> _cachedTransactions = [];

  bool _contactHasAddress(String address, Contact contact) {
    for (final entry in contact.addresses) {
      if (entry.address == address) {
        return true;
      }
    }
    return false;
  }

  Future<List<Tuple2<String, Transaction>>> _filteredTransactionsByContact(
    List<Manager> managers,
  ) async {
    final contact =
        ref.read(addressBookServiceProvider).getContactById(widget.contactId);

    // TODO: optimise

    List<Tuple2<String, Transaction>> result = [];
    for (final manager in managers) {
      final transactions = await MainDB.instance
          .getTransactions(manager.walletId)
          .filter()
          .anyOf(contact.addresses.map((e) => e.address),
              (q, String e) => q.address((q) => q.valueEqualTo(e)))
          .sortByTimestampDesc()
          .findAll();

      for (final tx in transactions) {
        result.add(Tuple2(manager.walletId, tx));
      }
    }
    // sort by date
    result.sort((a, b) => b.item2.timestamp - a.item2.timestamp);

    return result;
  }

  @override
  Widget build(BuildContext context) {
    // provider hack to prevent trying to update widget with deleted contact
    Contact? _contact;
    try {
      _contact = ref.watch(addressBookServiceProvider
          .select((value) => value.getContactById(widget.contactId)));
    } catch (_) {
      return Container();
    }

    final contact = _contact!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: RoundedWhiteContainer(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: contact.id == "default"
                                ? Colors.transparent
                                : Theme.of(context)
                                    .extension<StackColors>()!
                                    .textFieldDefaultBG,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: contact.id == "default"
                              ? Center(
                                  child: SvgPicture.asset(
                                    Assets.svg.stackIcon(context),
                                    width: 32,
                                  ),
                                )
                              : contact.emojiChar != null
                                  ? Center(
                                      child: Text(contact.emojiChar!),
                                    )
                                  : Center(
                                      child: SvgPicture.asset(
                                        Assets.svg.user,
                                        width: 18,
                                      ),
                                    ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          contact.name,
                          style: STextStyles.desktopTextSmall(context),
                        ),
                      ],
                    ),
                    if (widget.contactId != "default")
                      SecondaryButton(
                        label: "Options",
                        width: 96,
                        buttonHeight: ButtonHeight.xxs,
                        onPressed: () async {
                          await showDialog<void>(
                            context: context,
                            barrierColor: Colors.transparent,
                            builder: (context) {
                              return DesktopContactOptionsMenuPopup(
                                contactId: contact.id,
                              );
                            },
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(
                  height: 24,
                ),
                Flexible(
                  child: ListView(
                    primary: false,
                    shrinkWrap: true,
                    // child: Column(
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Addresses",
                            style:
                                STextStyles.desktopTextExtraExtraSmall(context),
                          ),
                          CustomTextButton(
                            text: "Add new",
                            onTap: () async {
                              ref.refresh(
                                  addressEntryDataProviderFamilyRefresher);

                              await showDialog<void>(
                                context: context,
                                builder: (context) => DesktopDialog(
                                  maxWidth: 580,
                                  maxHeight: 566,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          const SizedBox(
                                            width: 8,
                                          ),
                                          const AppBarBackButton(
                                            isCompact: true,
                                          ),
                                          Text(
                                            "Add new address",
                                            style:
                                                STextStyles.desktopH3(context),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            top: 20,
                                            left: 32,
                                            right: 32,
                                            bottom: 32,
                                          ),
                                          child: AddNewContactAddressView(
                                            contactId: widget.contactId,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      RoundedWhiteContainer(
                        padding: const EdgeInsets.all(0),
                        borderColor: Theme.of(context)
                            .extension<StackColors>()!
                            .background,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int i = 0; i < contact.addresses.length; i++)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (i > 0)
                                    Container(
                                      color: Theme.of(context)
                                          .extension<StackColors>()!
                                          .background,
                                      height: 1,
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: DesktopAddressCard(
                                      entry: contact.addresses[i],
                                      contactId: contact.id,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 12,
                        ),
                        child: Text(
                          "Transaction history",
                          style:
                              STextStyles.desktopTextExtraExtraSmall(context),
                        ),
                      ),
                      FutureBuilder(
                        future: _filteredTransactionsByContact(
                            ref.watch(walletsChangeNotifierProvider).managers),
                        builder: (_,
                            AsyncSnapshot<List<Tuple2<String, Transaction>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.done &&
                              snapshot.hasData) {
                            _cachedTransactions = snapshot.data!;

                            if (_cachedTransactions.isNotEmpty) {
                              return RoundedWhiteContainer(
                                padding: const EdgeInsets.all(0),
                                borderColor: Theme.of(context)
                                    .extension<StackColors>()!
                                    .background,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ..._cachedTransactions.map(
                                      (e) => TransactionCard(
                                        key: Key(
                                            "contactDetailsTransaction_${e.item1}_${e.item2.txid}_cardKey"),
                                        transaction: e.item2,
                                        walletId: e.item1,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return RoundedWhiteContainer(
                                child: Center(
                                  child: Text(
                                    "No transactions found",
                                    style: STextStyles.itemSubtitle(context),
                                  ),
                                ),
                              );
                            }
                          } else {
                            // TODO: proper loading animation
                            if (_cachedTransactions.isEmpty) {
                              return const LoadingIndicator();
                            } else {
                              return RoundedWhiteContainer(
                                padding: const EdgeInsets.all(0),
                                borderColor: Theme.of(context)
                                    .extension<StackColors>()!
                                    .background,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ..._cachedTransactions.map(
                                      (e) => TransactionCard(
                                        key: Key(
                                            "contactDetailsTransaction_${e.item1}_${e.item2.txid}_cardKey"),
                                        transaction: e.item2,
                                        walletId: e.item1,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
