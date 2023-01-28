// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:meeting/theme/app_color.dart';
import 'package:meeting/utils/strings.dart';

class SearchView extends StatefulWidget {
  final Function(String) onChnage;
  const SearchView({
    Key? key,
    required this.onChnage,
  }) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool _showClearBtn = false;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        widget.onChnage.call(value);
        setState(() {
          _showClearBtn = value.isNotEmpty;
        });
      },
      autofocus: false,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: Strings.search,
        prefixIcon: const Icon(
          Icons.search,
          color: AppColor.secondaryText,
        ),
        suffixIcon: _showClearBtn
            ? IconButton(
                onPressed: () {
                  _controller.clear();
                  widget.onChnage.call('');
                  setState(() {
                    _showClearBtn = false;
                  });
                },
                icon: Icon(
                  Icons.clear,
                  color: AppColor.secondaryText,
                ),
                splashRadius: 0.1,
              )
            : null,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColor.divider, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide:
              const BorderSide(color: AppColor.secondaryText, width: 0.5),
        ),
      ),
    );
  }
}
