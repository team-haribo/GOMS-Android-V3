import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

class SelectField<T> extends StatelessWidget {
  const SelectField({
    super.key,
    required this.hintText,
    required this.items,
    required this.itemLabel,
    this.value,
    this.onChanged,
    this.enabled = true,
  });

  final String hintText;
  final List<T> items;
  final String Function(T) itemLabel;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? () => _showCupertinoPicker(context) : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: context.surfaceColor,
        ),
        child: Text(
          value != null ? itemLabel(value as T) : hintText,
          style: value != null
              ? AppTextStyles.text2.withColor(
                  enabled ? context.mainTextColor : context.sub2Color,
                )
              : AppTextStyles.text2.withColor(context.sub2Color),
        ),
      ),
    );
  }

  void _showCupertinoPicker(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: items.map((item) {
            return CupertinoActionSheetAction(
              onPressed: () {
                onChanged?.call(item);
                context.pop(context);
              },
              child: Text(
                itemLabel(item),
                style: AppTextStyles.text2.withColor(
                  CupertinoColors.systemBlue,
                ),
              ),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => context.pop(context),
            child: Text(
              '취소',
              style: AppTextStyles.text1.withColor(CupertinoColors.systemBlue),
            ),
          ),
        );
      },
    );
  }
}
