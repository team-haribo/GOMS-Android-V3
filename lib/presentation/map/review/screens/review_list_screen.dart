import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/presentation/map/widget/arrival_departure_button.dart';
import 'package:goms/presentation/map/widget/drag_handle_header.dart';
import 'package:goms/presentation/map/widget/review_list_container.dart';
import 'package:goms/widgets/common/base_scaffold.dart';
import 'package:goms/widgets/common/text_fields/search_text_field.dart';

class ReviewListScreen extends StatefulWidget {
  final String placeName;
  final String category;
  final String address;
  final int distanceMeter;
  final int durationMinutes;
  final int review;
  final int recommended;

  const ReviewListScreen({
    super.key,
    required this.placeName,
    required this.category,
    required this.address,
    required this.distanceMeter,
    required this.durationMinutes,
    required this.review,
    required this.recommended,
  });

  @override
  State<ReviewListScreen> createState() => _ReviewListScreenState();
}

class _ReviewListScreenState extends State<ReviewListScreen> {
  final DraggableScrollableController sheetController =
      DraggableScrollableController();

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;
    return BaseScaffold(
      showAppBar: false,
      contentPadding: EdgeInsets.zero,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SearchTextField(),
          ),
          Expanded(
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  top: 0,
                  child: DraggableScrollableSheet(
                    initialChildSize: 0.32,
                    minChildSize: 0.32,
                    maxChildSize: 0.85,
                    snap: true,
                    snapSizes: const [0.32, 0.6, 0.85],
                    builder: (context, scrollController) {
                      return ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: isLight
                                ? AppColors.bgSurface
                                : AppColors.bgSurfaceDark,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: CustomScrollView(
                            controller: scrollController,
                            slivers: [
                              SliverPersistentHeader(
                                pinned: true,
                                delegate: DragHandleHeader(),
                              ),
                              SliverToBoxAdapter(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  child: SizedBox(
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  widget.placeName,
                                                  style: AppTextStyles.title3
                                                      .copyWith(
                                                    color: isLight ? AppColors.mainText : AppColors.mainTextDark,
                                                  ),
                                                ),
                                                AppGap.h4,
                                                Text(
                                                  widget.category,
                                                  style: AppTextStyles.text3
                                                      .copyWith(
                                                    color: isLight ? AppColors.sub1 : AppColors.sub1Dark,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                AppIcons.heart(),
                                                AppGap.h4,
                                                AppIcons.cancel(),
                                              ],
                                            ),
                                          ],
                                        ),
                                        AppGap.v8,
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            widget.address,
                                            style: AppTextStyles.text2.copyWith(
                                              color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                                            ),
                                          ),
                                        ),
                                        AppGap.v4,
                                        Row(
                                          children: [
                                            Text(
                                              '${widget.distanceMeter}m',
                                              style:
                                                  AppTextStyles.text2.copyWith(
                                                color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                                              ),
                                            ),
                                            AppGap.h4,
                                            Text(
                                              '|',
                                              style:
                                                  AppTextStyles.text2.copyWith(
                                                color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                                              ),
                                            ),
                                            AppGap.h4,
                                            Text(
                                              '${widget.durationMinutes}분',
                                              style:
                                                  AppTextStyles.text2.copyWith(
                                                color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                                              ),
                                            ),
                                          ],
                                        ),
                                        AppGap.v4,
                                        Row(
                                          children: [
                                            Text(
                                              '학생 후기',
                                              style:
                                                  AppTextStyles.text2.copyWith(
                                                color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                                              ),
                                            ),
                                            AppGap.h4,
                                            Text(
                                              '${widget.review}',
                                              style:
                                                  AppTextStyles.text2.copyWith(
                                                color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                                              ),
                                            ),
                                            AppGap.h4,
                                            Text(
                                              '|',
                                              style:
                                                  AppTextStyles.text2.copyWith(
                                                color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                                              ),
                                            ),
                                            AppGap.h4,
                                            Text(
                                              '추천',
                                              style:
                                                  AppTextStyles.text2.copyWith(
                                                color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                                              ),
                                            ),
                                            AppGap.h4,
                                            Text(
                                              '${widget.recommended}',
                                              style:
                                                  AppTextStyles.text2.copyWith(
                                                color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                                              ),
                                            ),
                                          ],
                                        ),
                                        AppGap.v16,
                                        Row(
                                          children: [
                                            ArrivalDepartureButton(
                                              buttonText: '도착',
                                              textColor: isLight ? AppColors.background : AppColors.mainTextDark,
                                              backgroundColor:
                                                  AppColors.mainColor,
                                            ),
                                            AppGap.h4,
                                            const ArrivalDepartureButton(
                                              buttonText: '출발',
                                              textColor: AppColors.sub2,
                                              backgroundColor:
                                                  AppColors.buttonDark,
                                            ),
                                          ],
                                        ),
                                        AppGap.v16,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '학생후기',
                                                  style: AppTextStyles.title3
                                                      .copyWith(
                                                    color: isLight ? AppColors.mainText : AppColors.mainTextDark,
                                                  ),
                                                ),
                                                AppGap.h4,
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: '${widget.review}',
                                                        style: AppTextStyles
                                                            .text3
                                                            .copyWith(
                                                          color: AppColors
                                                              .mainColor,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: '건',
                                                        style: AppTextStyles
                                                            .text3
                                                            .copyWith(
                                                          color: isLight ? AppColors.sub2 : AppColors.sub2Dark,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            TextButton.icon(
                                              onPressed: () {},
                                              label: Text(
                                                '후기 남기기',
                                                style: AppTextStyles.text2
                                                    .copyWith(
                                                  color: isLight ? AppColors.sub2 : AppColors.sub1Dark,
                                                ),
                                              ),
                                              icon: AppIcons.tablerEdit(
                                                width: 24,
                                                height: 24,
                                                color: isLight ? AppColors.sub2 : AppColors.sub1Dark,
                                              ),
                                              style: TextButton.styleFrom(
                                                padding: const EdgeInsets.only(
                                                  right: 4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (widget.review == 0) ...[
                                          AppGap.v12,
                                          AppIcons.coffee(),
                                          AppGap.v12,
                                          Text(
                                            '아직 후기가 없어요!\n첫 후기를 작성해봐요!',
                                            style:
                                                AppTextStyles.caption1.copyWith(
                                              color: AppColors.sub2,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          AppGap.v20,
                                        ] else ...[
                                          Column(
                                            children: [
                                              ReviewListContainer(
                                                name: '류수연',
                                                grade: 9,
                                                major: 'SW개발',
                                                reviewDetailContent: '굳굳',
                                                createdAt:
                                                    DateFormat('yy.MM.dd')
                                                        .format(DateTime.now()),
                                                isMine: true,
                                              ),
                                              ReviewListContainer(
                                                name: '류수연',
                                                grade: 9,
                                                major: 'SW개발',
                                                reviewDetailContent: '굳굳',
                                                createdAt:
                                                    DateFormat('yy.MM.dd')
                                                        .format(DateTime.now()),
                                                isMine: true,
                                              ),
                                              ReviewListContainer(
                                                name: '류수연',
                                                grade: 9,
                                                major: 'SW개발',
                                                reviewDetailContent: '굳굳',
                                                createdAt:
                                                    DateFormat('yy.MM.dd')
                                                        .format(DateTime.now()),
                                                isMine: false,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
