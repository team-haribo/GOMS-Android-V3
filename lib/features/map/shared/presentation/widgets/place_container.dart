import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/map/shared/presentation/viewmodels/place_like_provider.dart';

class PlaceContainer extends ConsumerWidget {
  final String placeName;
  final String category;
  final String address;
  final int review;
  final int recommended;
  final int? distanceMeters;
  final VoidCallback? onTap;

  const PlaceContainer({
    super.key,
    required this.placeName,
    required this.category,
    required this.address,
    required this.review,
    required this.recommended,
    this.distanceMeters,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = _PlaceContainerColors.fromTheme(context);
    final placeId = '$placeName|$address';
    final isLiked = ref.watch(placeLikeProvider(placeId));

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 104),
        decoration: BoxDecoration(
          color: colors.cardColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _PlaceContent(
                  placeName: placeName,
                  category: category,
                  address: address,
                  review: review,
                  recommended: recommended,
                  distanceMeters: distanceMeters,
                  colors: colors,
                ),
              ),
              AppGap.h8,
              _LikeButton(
                isLiked: isLiked,
                onPressed: () {
                  ref.read(placeLikeProvider(placeId).notifier).state =
                      !isLiked;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PlaceContent extends StatelessWidget {
  final String placeName;
  final String category;
  final String address;
  final int review;
  final int recommended;
  final int? distanceMeters;
  final _PlaceContainerColors colors;

  const _PlaceContent({
    required this.placeName,
    required this.category,
    required this.address,
    required this.review,
    required this.recommended,
    required this.distanceMeters,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _PlaceTitleRow(
          placeName: placeName,
          category: category,
          colors: colors,
        ),
        AppGap.v4,
        Text(
          address,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption1.copyWith(color: colors.subColor),
        ),
        if (distanceMeters != null) ...[
          AppGap.v4,
          Text(
            '학교 기준 ${distanceMeters}m',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption2.copyWith(color: colors.subColor),
          ),
        ],
        AppGap.v8,
        Wrap(
          spacing: AppSpacing.s4,
          runSpacing: AppSpacing.s2,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(
              '학생 후기',
              style: AppTextStyles.caption1.copyWith(color: colors.subColor),
            ),
            Text(
              _formatCount(review),
              style: AppTextStyles.caption1.copyWith(color: colors.subColor),
            ),
            Text(
              '|',
              style: AppTextStyles.caption1.copyWith(color: colors.subColor),
            ),
            Text(
              '추천',
              style: AppTextStyles.caption1.copyWith(color: colors.subColor),
            ),
            Text(
              _formatCount(recommended),
              style: AppTextStyles.caption1.copyWith(color: colors.subColor),
            ),
          ],
        ),
      ],
    );
  }

  String _formatCount(int value) {
    return value >= 10 ? '$value+' : value.toString();
  }
}

class _PlaceTitleRow extends StatelessWidget {
  final String placeName;
  final String category;
  final _PlaceContainerColors colors;

  const _PlaceTitleRow({
    required this.placeName,
    required this.category,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            placeName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.text2.copyWith(color: colors.mainTextColor),
          ),
        ),
        if (category.trim().isNotEmpty) ...[
          AppGap.h4,
          Flexible(
            flex: 2,
            child: Text(
              category,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style:
                  AppTextStyles.caption1.copyWith(color: colors.categoryColor),
            ),
          ),
        ],
      ],
    );
  }
}

class _LikeButton extends StatelessWidget {
  final bool isLiked;
  final VoidCallback onPressed;

  const _LikeButton({
    required this.isLiked,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 40,
      height: 40,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 40, height: 40),
        splashRadius: 20,
        onPressed: onPressed,
        icon: isLiked
            ? AppIcons.heartFilled(width: 24, height: 24)
            : AppIcons.heart(width: 24, height: 24),
      ),
    );
  }
}

class _PlaceContainerColors {
  final Color cardColor;
  final Color mainTextColor;
  final Color subColor;
  final Color categoryColor;

  const _PlaceContainerColors({
    required this.cardColor,
    required this.mainTextColor,
    required this.subColor,
    required this.categoryColor,
  });

  factory _PlaceContainerColors.fromTheme(BuildContext context) {
    return _PlaceContainerColors(
      cardColor: context.mapContainerColor,
      mainTextColor: context.mainTextColor,
      subColor: context.sub2Color,
      categoryColor: context.isLightMode ? AppColors.sub2 : AppColors.gray3,
    );
  }
}
