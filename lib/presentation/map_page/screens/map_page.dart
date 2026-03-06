import 'package:flutter/material.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/icons/app_icons.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/presentation/map_page/widget/map_page_data.dart';
import 'package:project_setting/presentation/map_page/widget/drag_handle_header.dart';
import 'package:project_setting/presentation/map_page/widget/place_container.dart';
import 'package:project_setting/presentation/map_page/widget/place_review_container.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/text_fields/search_text_field.dart';
import 'package:project_setting/widgets/goms_bottom_navigation.dart';

class MapPage extends StatefulWidget {
  final int placeRecommendCount;
  final int placeReviewCount;

  const MapPage({
    super.key,
    this.placeRecommendCount = 0,
    this.placeReviewCount = 0,
  });


  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final DraggableScrollableController sheetController =
  DraggableScrollableController();



  @override
  Widget build(BuildContext context) {
    final isLight = Theme
        .of(context)
        .brightness == Brightness.light;
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
                    initialChildSize: 0.37,
                    // 기본적으로 보이는 사이즈
                    minChildSize: 0.37,
                    // 아래로 내렸을 때 최대 몇퍼까지 차지
                    maxChildSize: 0.85,
                    // 최대로 올렸을 때 몇퍼까지
                    snap: true,
                    snapSizes: const [0.37, 0.6, 0.85],
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
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '최근 인기 장소',
                                              style:
                                              AppTextStyles.title3.copyWith(
                                                color: isLight
                                                    ? AppColors.mainText
                                                    : AppColors.mainTextDark,
                                              ),
                                            ),
                                            AppGap.v2,
                                            AppIcons.fire(
                                              color: AppColors.negative,
                                            ),
                                          ],
                                        ),
                                        AppGap.v16,
                                        ...popularPlaces.map((place) {
                                          return Column(
                                            children: [
                                              PlaceContainer(
                                                placeName: place.name,
                                                category: place.category,
                                                address: place.address,
                                                review: place.review,
                                                recommended: place.recommended,
                                              ),
                                              AppGap.v12,
                                            ],
                                          );
                                        }),
                                        AppGap.v16,
                                        Text(
                                          '내 활동',
                                          style: AppTextStyles.title3.copyWith(
                                            color: isLight
                                                ? AppColors.mainText
                                                : AppColors.mainTextDark,
                                          ),
                                        ),
                                        AppGap.v16,
                                        Row(
                                          children: [
                                            Text(
                                              '추천한 가게',
                                              style:
                                              AppTextStyles.text1.copyWith(
                                                color: isLight
                                                    ? AppColors.mainText
                                                    : AppColors.mainTextDark,
                                              ),
                                            ),
                                            AppGap.h4,
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                    '${widget
                                                        .placeRecommendCount}',
                                                    style: AppTextStyles.text3
                                                        .copyWith(
                                                      color: isLight
                                                          ? AppColors.mainColor
                                                          : AppColors.mainColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '곳',
                                                    style: AppTextStyles.text3
                                                        .copyWith(
                                                      color: isLight
                                                          ? AppColors.sub2
                                                          : AppColors.sub2Dark,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        ...popularPlaces.map((place) {
                                          return Column(
                                            children: [
                                              AppGap.v12,
                                              PlaceContainer(
                                                placeName: place.name,
                                                category: place.category,
                                                address: place.address,
                                                review: place.review,
                                                recommended: place.recommended,
                                              ),
                                            ],
                                          );
                                        }),
                                        AppGap.v16,
                                        Row(
                                          children: [
                                            Text(
                                              '작성한 후기',
                                              style:
                                              AppTextStyles.text3.copyWith(
                                                color: isLight
                                                    ? AppColors.mainText
                                                    : AppColors.mainTextDark,
                                              ),
                                            ),
                                            AppGap.h4,
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                    '${widget
                                                        .placeReviewCount}',
                                                    style: AppTextStyles.text1
                                                        .copyWith(
                                                      color:
                                                      AppColors.mainColor,
                                                    ),
                                                  ),
                                                  TextSpan(
                                                    text: '건',
                                                    style: AppTextStyles.text1
                                                        .copyWith(
                                                      color: isLight
                                                          ? AppColors.sub2
                                                          : AppColors.sub2Dark,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        ...reviewModels.map((place) {
                                          return Column(
                                            children: [
                                              AppGap.v12,
                                              PlaceReviewContainer(
                                                placeName: place.placeName,
                                                category: place.category,
                                                address: place.address,
                                                reviewDetailContent: place
                                                    .reviewDetailContent,
                                                createdAt: place.createdAt,),
                                            ],
                                          );
                                        }),
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
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 57,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          isLight
                              ? AppColors.bgSurface.withAlpha(0)
                              : AppColors.bgSurfaceDark.withAlpha(0),
                          isLight
                              ? AppColors.bgSurface.withAlpha(255)
                              : AppColors.bgSurfaceDark.withAlpha(255),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar:
      GomsBottomNavigation(currentIndex: 2, onTap: (index) {}),
    );
  }
}
