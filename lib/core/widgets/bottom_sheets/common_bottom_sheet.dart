import 'package:flutter/material.dart';
import 'package:goms_design_system/goms_design_system.dart';

class CommonBottomSheet extends StatelessWidget {
  const CommonBottomSheet({
    super.key,
    this.title = '',
    required this.child,
    this.onClose,
    this.padding = const EdgeInsets.all(24),
    this.header,
    this.showDefaultHeader = true,
    this.headerBottomSpacing = 24,
    this.maxHeightRatio = 0.8,
    this.backgroundColor,
    this.borderRadius,
    this.clipBehavior = Clip.none,
  });

  final String title;
  final Widget child;
  final VoidCallback? onClose;
  final EdgeInsets padding;
  final Widget? header;
  final bool showDefaultHeader;
  final double headerBottomSpacing;
  final double maxHeightRatio;
  final Color? backgroundColor;
  final BorderRadiusGeometry? borderRadius;
  final Clip clipBehavior;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * maxHeightRatio;
    final resolvedHeader = _buildHeader(context);

    return SafeArea(
      top: false,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: maxHeight,
        ),
        child: ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.zero,
          clipBehavior: clipBehavior,
          child: Container(
            color: backgroundColor ?? context.surfaceColor,
            width: double.infinity,
            child: Padding(
              padding: padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (resolvedHeader != null) ...[
                    resolvedHeader,
                    SizedBox(height: headerBottomSpacing),
                  ],
                  Flexible(
                    fit: FlexFit.loose,
                    child: child,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget? _buildHeader(BuildContext context) {
    if (header != null) return header;
    if (!showDefaultHeader) return null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.title3.copyWith(
            color: context.isLightMode ? Colors.black : Colors.white,
          ),
        ),
        IconButton(
          onPressed: onClose ?? () => Navigator.pop(context),
          icon: AppIcons.cancel(),
        ),
      ],
    );
  }
}
