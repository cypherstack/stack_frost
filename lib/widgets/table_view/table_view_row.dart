import 'package:flutter/material.dart';
import 'package:stackwallet/utilities/theme/stack_colors.dart';
import 'package:stackwallet/widgets/expandable.dart';
import 'package:stackwallet/widgets/table_view/table_view_cell.dart';

class TableViewRow extends StatefulWidget {
  const TableViewRow({
    Key? key,
    required this.cells,
    required this.expandingChild,
    this.decoration,
    this.onExpandChanged,
    this.padding = const EdgeInsets.all(0),
    this.spacing = 0.0,
    this.crossAxisAlignment = CrossAxisAlignment.center,
  }) : super(key: key);

  final List<TableViewCell> cells;
  final Widget? expandingChild;
  final BoxDecoration? decoration;
  final void Function(ExpandableState)? onExpandChanged;
  final EdgeInsetsGeometry padding;
  final double spacing;
  final CrossAxisAlignment crossAxisAlignment;

  @override
  State<TableViewRow> createState() => _TableViewRowState();
}

class _TableViewRowState extends State<TableViewRow> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    debugPrint("BUILD: $runtimeType");
    return Container(
      decoration: !_hovering
          ? widget.decoration
          : widget.decoration?.copyWith(
              boxShadow: [
                Theme.of(context).extension<StackColors>()!.standardBoxShadow,
                Theme.of(context).extension<StackColors>()!.standardBoxShadow,
              ],
            ),
      child: widget.expandingChild == null
          ? MouseRegion(
              onEnter: (_) {
                setState(() {
                  _hovering = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _hovering = false;
                });
              },
              child: Padding(
                padding: widget.padding,
                child: Row(
                  crossAxisAlignment: widget.crossAxisAlignment,
                  children: [
                    for (int i = 0; i < widget.cells.length; i++) ...[
                      if (i != 0 && i != widget.cells.length)
                        SizedBox(
                          width: widget.spacing,
                        ),
                      Expanded(
                        flex: widget.cells[i].flex,
                        child: widget.cells[i],
                      ),
                    ],
                  ],
                ),
              ),
            )
          : Expandable(
              onExpandChanged: widget.onExpandChanged,
              header: MouseRegion(
                onEnter: (_) {
                  setState(() {
                    _hovering = true;
                  });
                },
                onExit: (_) {
                  setState(() {
                    _hovering = false;
                  });
                },
                child: Padding(
                  padding: widget.padding,
                  child: Row(
                    children: [
                      for (int i = 0; i < widget.cells.length; i++) ...[
                        if (i != 0 && i != widget.cells.length)
                          SizedBox(
                            width: widget.spacing,
                          ),
                        Expanded(
                          flex: widget.cells[i].flex,
                          child: widget.cells[i],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              body: Column(
                children: [
                  Container(
                    color: Theme.of(context)
                        .extension<StackColors>()!
                        .buttonBackSecondary,
                    width: double.infinity,
                    height: 1,
                  ),
                  widget.expandingChild!,
                ],
              ),
            ),
    );
  }
}
