import 'package:flutter/material.dart';
import 'package:meeting/theme/app_color.dart';

class ConfirmDialog extends StatelessWidget {
  final String title;
  final Function() onSubmit;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        // color: AppColor.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: AppColor.primaryText,
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      onSubmit.call();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Yes'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
