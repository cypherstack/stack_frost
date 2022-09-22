import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stackwallet/providers/providers.dart';
import 'package:stackwallet/utilities/assets.dart';
import 'package:stackwallet/utilities/constants.dart';
import 'package:stackwallet/utilities/enums/languages_enum.dart';
import 'package:stackwallet/utilities/text_styles.dart';
import 'package:stackwallet/utilities/theme/stack_theme.dart';
import 'package:stackwallet/widgets/custom_buttons/app_bar_icon_button.dart';
import 'package:stackwallet/widgets/icon_widgets/x_icon.dart';
import 'package:stackwallet/widgets/rounded_container.dart';
import 'package:stackwallet/widgets/stack_text_field.dart';
import 'package:stackwallet/widgets/textfield_icon_button.dart';

class LanguageSettingsView extends ConsumerStatefulWidget {
  const LanguageSettingsView({Key? key}) : super(key: key);

  static const String routeName = "/languageSettings";

  @override
  ConsumerState<LanguageSettingsView> createState() => _LanguageViewState();
}

class _LanguageViewState extends ConsumerState<LanguageSettingsView> {
  // TODO: list of translations/localisations
  final languages = Language.values.map((e) => e.description).toList();

  late String current;
  late List<String> listWithoutSelected;

  late TextEditingController _searchController;

  final _searchFocusNode = FocusNode();

  void onTap(int index) {
    if (index == 0 || current.isEmpty) {
      // ignore if already selected language
      return;
    }
    current = listWithoutSelected[index];
    listWithoutSelected.remove(current);
    listWithoutSelected.insert(0, current);
    ref.read(prefsChangeNotifierProvider).language = current;
  }

  BorderRadius? _borderRadius(int index) {
    if (index == 0 && listWithoutSelected.length == 1) {
      return BorderRadius.circular(
        Constants.size.circularBorderRadius,
      );
    } else if (index == 0) {
      return BorderRadius.vertical(
        top: Radius.circular(
          Constants.size.circularBorderRadius,
        ),
      );
    } else if (index == listWithoutSelected.length - 1) {
      return BorderRadius.vertical(
        bottom: Radius.circular(
          Constants.size.circularBorderRadius,
        ),
      );
    }
    return null;
  }

  String filter = "";

  List<String> _filtered() {
    return listWithoutSelected
        .where(
            (element) => element.toLowerCase().contains(filter.toLowerCase()))
        .toList();
  }

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    current = ref
        .watch(prefsChangeNotifierProvider.select((value) => value.language));

    listWithoutSelected = languages;
    if (current.isNotEmpty) {
      listWithoutSelected.remove(current);
      listWithoutSelected.insert(0, current);
    }
    listWithoutSelected = _filtered();
    return Scaffold(
      backgroundColor: StackTheme.instance.color.background,
      appBar: AppBar(
        leading: AppBarBackButton(
          onPressed: () async {
            if (FocusScope.of(context).hasFocus) {
              FocusScope.of(context).unfocus();
              await Future<void>.delayed(const Duration(milliseconds: 75));
            }
            if (mounted) {
              Navigator.of(context).pop();
            }
          },
        ),
        title: Text(
          "Language",
          style: STextStyles.navBarTitle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 12,
          left: 16,
          right: 16,
        ),
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Constants.size.circularBorderRadius,
                      ),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onChanged: (newString) {
                          setState(() => filter = newString);
                        },
                        style: STextStyles.field,
                        decoration: standardInputDecoration(
                          "Search",
                          _searchFocusNode,
                        ).copyWith(
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 16,
                            ),
                            child: SvgPicture.asset(
                              Assets.svg.search,
                              width: 16,
                              height: 16,
                            ),
                          ),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 0),
                                  child: UnconstrainedBox(
                                    child: Row(
                                      children: [
                                        TextFieldIconButton(
                                          child: const XIcon(),
                                          onTap: () async {
                                            setState(() {
                                              _searchController.text = "";
                                              filter = "";
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: Builder(
            builder: (context) {
              return CustomScrollView(
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: StackTheme.instance.color.popupBG,
                            borderRadius: _borderRadius(index),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            key: Key(
                                "languageSelect_${listWithoutSelected[index]}"),
                            child: RoundedContainer(
                              padding: const EdgeInsets.all(0),
                              color: index == 0
                                  ? StackTheme.instance.color.currencyListItemBG
                                  : StackTheme.instance.color.popupBG,
                              child: RawMaterialButton(
                                onPressed: () async {
                                  onTap(index);
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    Constants.size.circularBorderRadius,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: Radio(
                                          activeColor: StackTheme.instance.color
                                              .radioButtonIconEnabled,
                                          value: true,
                                          groupValue: index == 0,
                                          onChanged: (_) {
                                            onTap(index);
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            listWithoutSelected[index],
                                            key: (index == 0)
                                                ? const Key(
                                                    "selectedLanguageSettingsLanguageText")
                                                : null,
                                            style: STextStyles.largeMedium14,
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          Text(
                                            listWithoutSelected[index],
                                            key: (index == 0)
                                                ? const Key(
                                                    "selectedLanguageSettingsLanguageTextDescription")
                                                : null,
                                            style: STextStyles.itemSubtitle,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      childCount: listWithoutSelected.length,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
