import 'package:flutter/material.dart';
import 'package:meeting/theme/app_color.dart';

class AppDropDown extends StatefulWidget {
  final List<dynamic> items;
  final bool isEnable;
  dynamic selectedValue;
  final Function(dynamic) onSelected;

  AppDropDown({
    Key? key,
    required this.items,
    required this.selectedValue,
    this.isEnable = true,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<AppDropDown> createState() => _AppDropDownState();
}

class _AppDropDownState extends State<AppDropDown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: AppColor.surface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: AppColor.divider,
          width: 0.5,
        ),
      ),
      child: ButtonTheme(
        alignedDropdown: true,
        child: DropdownButton<dynamic>(
          isExpanded: true,
          value: widget.selectedValue,
          underline: const SizedBox(),
          items: widget.items
              .map(
                (e) => DropdownMenuItem<dynamic>(
                  value: e,
                  child: Text(e.toString()),
                ),
              )
              .toList(),
          onChanged: widget.isEnable
              ? (value) {
                  setState(() {
                    widget.selectedValue = value!;
                    widget.onSelected.call(value);
                  });
                }
              : null,
        ),
      ),
    );
  }
}
