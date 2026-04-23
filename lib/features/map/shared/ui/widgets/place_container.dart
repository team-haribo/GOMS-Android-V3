import 'package:flutter/material.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:intl/intl.dart';

abstract class PlaceContainer extends StatelessWidget {
  const PlaceContainer({super.key});

  const factory PlaceContainer.popular({
    Key? key,
    required String placeName,
    required String category,
    required String address,
    required int review,
    required int recommended,
    required bool isLiked,
    int? distanceMeters,
    VoidCallback? onTap,
    VoidCallback? onLikePressed,
  }) = _PopularPlaceContainer;

  const factory PlaceContainer.review({
    Key? key,
    required String placeName,
    required String category,
    required String address,
    required String reviewContent,
    required DateTime reviewCreatedAt,
    VoidCallback? onTap,
    VoidCallback? onActionPressed,
  }) = _ReviewPlaceContainer;
}

class _PopularPlaceContainer extends PlaceContainer {
  final String placeName;
  final String category;
  final String address;
  final int review;
  final int recommended;
  final bool isLiked;
  final int? distanceMeters;
  final VoidCallback? onTap;
  final VoidCallback? onLikePressed;

  const _PopularPlaceContainer({
    super.key,
    required this.placeName,
    required this.category,
    required this.address,
    required this.review,
    required this.recommended,
    required this.isLiked,
    this.distanceMeters,
    this.onTap,
    this.onLikePressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _PlaceContainerColors.fromTheme(context);

    return _BasePlaceContainer(
      colors: colors,
      onTap: onTap,
      content: _PlaceContent(
        placeName: placeName,
        category: category,
        address: address,
        review: review,
        recommended: recommended,
        distanceMeters: distanceMeters,
        colors: colors,
      ),
      trailing: _PlaceActionButton.popular(
        isLiked: isLiked,
        onPressed: onLikePressed,
      ),
    );
  }
}

class _ReviewPlaceContainer extends PlaceContainer {
  final String placeName;
  final String category;
  final String address;
  final String reviewContent;
  final DateTime reviewCreatedAt;
  final VoidCallback? onTap;
  final VoidCallback? onActionPressed;

  const _ReviewPlaceContainer({
    super.key,
    required this.placeName,
    required this.category,
    required this.address,
    required this.reviewContent,
    required this.reviewCreatedAt,
    this.onTap,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _PlaceContainerColors.fromTheme(context);

    return _BasePlaceContainer(
      colors: colors,
      onTap: onTap,
      content: _ReviewContent(
        placeName: placeName,
        category: category,
        address: address,
        reviewContent: reviewContent,
        reviewCreatedAt: reviewCreatedAt,
        colors: colors,
      ),
      trailing: _PlaceActionButton.review(onPressed: onActionPressed),
    );
  }
}

class _BasePlaceContainer extends StatelessWidget {
  final _PlaceContainerColors colors;
  final VoidCallback? onTap;
  final Widget content;
  final Widget? trailing;

  const _BasePlaceContainer({
    required this.colors,
    required this.onTap,
    required this.content,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: content),
              if (trailing != null) ...[
                AppGap.h8,
                trailing!,
              ],
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

class _ReviewContent extends StatelessWidget {
  final String placeName;
  final String category;
  final String address;
  final String reviewContent;
  final DateTime? reviewCreatedAt;
  final _PlaceContainerColors colors;

  const _ReviewContent({
    required this.placeName,
    required this.category,
    required this.address,
    required this.reviewContent,
    required this.reviewCreatedAt,
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
          category: _formatReviewCategory(category),
          colors: colors,
        ),
        AppGap.v4,
        Text(
          address,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption1.copyWith(color: colors.subColor),
        ),
        AppGap.v4,
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                reviewContent,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption1.copyWith(color: colors.subColor),
              ),
            ),
            AppGap.h4,
            Text(
              '작성일: ${_formatDate(reviewCreatedAt)}',
              style: AppTextStyles.caption1.copyWith(color: colors.subColor),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) {
      return '-';
    }
    return DateFormat('yy.MM.dd').format(value);
  }

  String _formatReviewCategory(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return '';
    }

    final segments = trimmed
        .split(RegExp(r'\s*(?:->|→|>)\s*'))
        .where((segment) => segment.trim().isNotEmpty)
        .toList(growable: false);

    if (segments.isEmpty) {
      return trimmed;
    }

    return segments.last.trim();
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
        Text(
          placeName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.text2.copyWith(color: colors.mainTextColor),
        ),
        if (category.trim().isNotEmpty) ...[
          AppGap.h4,
          Text(
            category,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.caption1.copyWith(color: colors.categoryColor),
          ),
        ],
      ],
    );
  }
}

enum _PlaceActionButtonType {
  popular,
  review,
}

class _PlaceActionButton extends StatelessWidget {
  final _PlaceActionButtonType _type;
  final bool isLiked;
  final VoidCallback? onPressed;

  const _PlaceActionButton.popular({
    required this.isLiked,
    required this.onPressed,
  }) : _type = _PlaceActionButtonType.popular;

  const _PlaceActionButton.review({
    required this.onPressed,
  })  : _type = _PlaceActionButtonType.review,
        isLiked = false;

  @override
  Widget build(BuildContext context) {
    if (_type == _PlaceActionButtonType.popular) {
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

    return SizedBox(
      width: 40,
      height: 40,
      child: Center(
        child: GestureDetector(
          onTap: onPressed,
          behavior: HitTestBehavior.opaque,
          child: AppIcons.bin(
            width: 24,
            height: 24,
            color: AppColors.negative,
          ),
        ),
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
