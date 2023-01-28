import 'package:flutter/material.dart';
import 'package:meeting/data/event/event.dart';
import 'package:meeting/utils/strings.dart';

class CreateEventDialog extends StatefulWidget {
  final Function(String) onTap;
  final Event? event;
  const CreateEventDialog({
    Key? key,
    required this.onTap,
    this.event,
  }) : super(key: key);

  @override
  State<CreateEventDialog> createState() => _CreateEventDialogState();
}

class _CreateEventDialogState extends State<CreateEventDialog> {
  String errorText = '';
  late TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(text: widget.event?.title);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Wrap(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              children: [
                Text(
                  Strings.enterEventNameTitle,
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _controller,
                  keyboardType: TextInputType.name,
                  autofocus: true,
                  decoration: InputDecoration(
                    errorText: errorText,
                    errorMaxLines: 1,
                    errorStyle: Theme.of(context).textTheme.caption?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isEmpty) {
                      errorText = Strings.enterEventName;
                      setState(() {});
                    } else {
                      widget.onTap.call(_controller.text);
                    }
                  },
                  child: Text(widget.event == null ? Strings.create : Strings.edit),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
