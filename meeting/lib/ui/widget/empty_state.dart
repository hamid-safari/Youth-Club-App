import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final Widget image;
  final String title;

  const EmptyState({
    Key? key,
    required this.image,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Opacity(
          opacity: 0.7,
          child: image,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    ));
  }
}
