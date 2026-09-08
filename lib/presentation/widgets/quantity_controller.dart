import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantityController extends StatefulWidget {
  const QuantityController({
    super.key,
    this.initialValue = 1,
    this.minValue = 0,
    this.maxValue,
    this.onChanged,
    this.onIncrement,
    this.onDecrement,
  });

  final int initialValue;
  final int minValue;
  final int? maxValue;
  final ValueChanged<int>? onChanged;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  State<QuantityController> createState() => _QuantityControllerState();
}

class _QuantityControllerState extends State<QuantityController> {
  late final TextEditingController _textController;
  late int _value;
  bool _syncingText = false;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _textController = TextEditingController(text: _value.toString());
    _textController.addListener(_handleTextChanged);
  }

  @override
  void didUpdateWidget(QuantityController oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue) {
      _setValue(widget.initialValue, notify: false, syncText: true);
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleTextChanged() {
    if (_syncingText) return;
    final parsed = int.tryParse(_textController.text);
    if (parsed == null || parsed == _value) return;
    _setValue(parsed, notify: true, syncText: false);
  }

  void _increment() {
    if (widget.maxValue != null && _value >= widget.maxValue!) return;
    widget.onIncrement?.call();
    _setValue(_value + 1, notify: true, syncText: true);
  }

  void _decrement() {
    if (_value <= widget.minValue) return;
    widget.onDecrement?.call();
    _setValue(_value - 1, notify: true, syncText: true);
  }

  void _setValue(int value, {required bool notify, required bool syncText}) {
    setState(() => _value = value);
    if (syncText) {
      _syncingText = true;
      _textController.text = value.toString();
      _syncingText = false;
    }
    if (notify) {
      widget.onChanged?.call(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final canDecrement = _value > widget.minValue;
    final canIncrement = widget.maxValue == null || _value < widget.maxValue!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ControllerButton(
            icon: Icons.remove,
            tooltip: 'Decrease quantity',
            onPressed: canDecrement ? _decrement : null,
          ),
          SizedBox(
            width: 44,
            child: TextField(
              controller: _textController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          _ControllerButton(
            icon: Icons.add,
            tooltip: 'Increase quantity',
            onPressed: canIncrement ? _increment : null,
          ),
        ],
      ),
    );
  }
}

class _ControllerButton extends StatelessWidget {
  const _ControllerButton({
    required this.icon,
    required this.tooltip,
    this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
      color: Theme.of(context).colorScheme.primary,
      constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
      padding: EdgeInsets.zero,
    );
  }
}