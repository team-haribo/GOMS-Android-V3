import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/widgets/scaffolds/base_scaffold.dart';
import 'package:goms/core/widgets/buttons/qr_button.dart';
import 'package:goms/core/widgets/text_fields/search_student.dart';
import 'package:goms/features/home/shared/presentation/widgets/search_profile_list.dart';
import 'package:goms/features/home/shared/presentation/widgets/user_manage_button.dart';
import 'package:goms/core/theme/colors/app_colors.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/features/outing/domain/entities/outing_student_entity.dart';
import 'package:goms/features/outing/presentation/providers/current_outing_students_provider.dart';

final searchTextProvider = StateProvider<String>((ref) => '');

class OutingStateScreen extends ConsumerStatefulWidget {
  const OutingStateScreen({
    super.key,
  });

  @override
  ConsumerState<OutingStateScreen> createState() => _OutingStateScreenState();
}

class _OutingStateScreenState extends ConsumerState<OutingStateScreen> {
  bool isOutingDay = true;

  @override
  Widget build(BuildContext context) {
    final searchText = ref.watch(searchTextProvider);
    final role = ref.watch(roleProvider);
    final outingStudents = ref.watch(currentOutingStudentsProvider);

    return BaseScaffold(
      showAppBar: true,
      role: role,
      body: Column(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Text(
              '외출 현황',
              style: AppTextStyles.title1.copyWith(
                color: context.mainTextColor,
              ),
            ),
          ),
          AppGap.v24,
          Align(
            alignment: Alignment.center,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: context.surfaceColor,
              ),
              child: SearchStudentField(
                onChanged: (value) {
                  ref.read(searchTextProvider.notifier).state = value;
                },
              ),
            ),
          ),
          if (!isOutingDay)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcons.coffee(),
                    AppGap.v8,
                    Text(
                      '오늘은 외출하는 날이 아니에요!',
                      style: AppTextStyles.title1
                          .copyWith(fontSize: 14, color: AppColors.sub2),
                    ),
                  ],
                ),
              ),
            )
          else ...[
            AppGap.v12,
            Row(
              children: [
                Text(
                  '검색결과',
                  style: AppTextStyles.title3.copyWith(
                    color: context.mainTextColor,
                  ),
                ),
              ],
            ),
            AppGap.v12,
            Expanded(
              child: RefreshIndicator(
                onRefresh: () {
                  return ref
                      .read(currentOutingStudentsProvider.notifier)
                      .reload();
                },
                child: outingStudents.when(
                  data: (students) {
                    final filteredList = _filterStudents(students, searchText);

                    if (filteredList.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: 280,
                            child: Center(
                              child: Text(
                                searchText.isEmpty
                                    ? '현재 외출 중인 학생이 없어요.'
                                    : '검색 결과가 없어요.',
                                style: AppTextStyles.text2.copyWith(
                                  color: context.sub2Color,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final member = filteredList[index];
                        return SearchProfileList(
                          memberId: member.memberId,
                          name: member.name,
                          grade: member.grade,
                          major: member.department,
                          profileImageUrl: member.profileImageUrl,
                          role: role,
                          outingAt: member.outingAt,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider(
                          thickness: 1,
                          color: context.buttonColor,
                        );
                      },
                    );
                  },
                  loading: () => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: const [
                      SizedBox(
                        height: 280,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ],
                  ),
                  error: (error, _) => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: 280,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                error is CurrentOutingStudentsException
                                    ? error.message
                                    : '외출 목록을 불러오지 못했어요.',
                                style: AppTextStyles.text2.copyWith(
                                  color: context.sub2Color,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              AppGap.v12,
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(
                                        currentOutingStudentsProvider.notifier,
                                      )
                                      .reload();
                                },
                                child: const Text('다시 시도'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (role == RoleEnum.admin) ...[
            const UserManageButton(),
            AppGap.v12,
          ],
          QRButton(
            type: role == RoleEnum.admin ? RoleEnum.admin : RoleEnum.user,
          ),
        ],
      ),
    );
  }

  List<OutingStudentEntity> _filterStudents(
    List<OutingStudentEntity> students,
    String searchText,
  ) {
    if (searchText.isEmpty) return students;

    final keyword = searchText.toLowerCase();
    return students
        .where((student) => student.name.toLowerCase().contains(keyword))
        .toList();
  }
}
