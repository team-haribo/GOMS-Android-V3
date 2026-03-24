import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:goms/core/router/route_path.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';

class ViewMoreUsers extends StatelessWidget {
  const ViewMoreUsers({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 51,
      height: 24,
      child: ElevatedButton(
        onPressed: () {
          context.push(RoutePath.outingState);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: context.surfaceColor,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          elevation: 0,
        ),
        child: Text(
          "더보기",
          style: AppTextStyles.caption2.copyWith(
            fontWeight: FontWeight.w300,
            color: context.isLightMode ? context.sub2Color : context.sub1Color,
          ),
        ),
      ),
    );
  }
}
