import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/theme/layout/app_layout.dart';
import 'package:goms/core/theme/theme_context.dart';
import 'package:goms/core/theme/typography/app_text_styles.dart';
import 'package:goms/core/widgets/avatars/profile_avatar.dart';
import 'package:goms/core/widgets/dialogs/forced_return_dialog.dart';
import 'package:goms/features/outing/ui/providers/current_outing_students_provider.dart';

class SearchProfileList extends ConsumerWidget {
  final int memberId;
  final String name;
  final int grade;
  final String major;
  final String profileImageUrl;
  final RoleEnum role;
  final DateTime outingAt;

  const SearchProfileList({
    super.key,
    required this.memberId,
    required this.name,
    required this.grade,
    required this.major,
    required this.profileImageUrl,
    required this.role,
    required this.outingAt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: context.backgroundColor,
      width: double.infinity,
      height: 72,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: ProfileAvatar(
              radius: 24,
              imageUrl: profileImageUrl,
              backgroundColor: context.surfaceColor,
            ),
          ),
          AppGap.v4,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.text1.copyWith(
                  color: context.sub1Color,
                ),
              ),
              AppGap.h4,
              Row(
                children: [
                  Text(
                    '$grade학년 | $major',
                    style: AppTextStyles.text3.copyWith(
                      color: context.sub2Color,
                    ),
                  ),
                  AppGap.h4,
                  SizedBox(
                    height: 8,
                    child: VerticalDivider(
                      thickness: 1,
                      width: 1,
                      color: context.buttonColor,
                    ),
                  ),
                  AppGap.h4,
                  Text(
                    '${DateFormat('HH:mm').format(outingAt)}에 외출',
                    style: AppTextStyles.text3.copyWith(
                      color: context.sub2Color,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          if (role == RoleEnum.admin) ...[
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                onPressed: () {
                  forcedReturn(
                    context: context,
                    title: '외출 강제 복귀',
                    content: '\n외출자를 강제로 복귀시키겠습니까?',
                    onConfirm: () async {
                      try {
                        await ref
                            .read(currentOutingStudentsProvider.notifier)
                            .forceInStudent(memberId: memberId);
                        if (context.mounted) {
                          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                            const SnackBar(content: Text('강제 복귀 처리했습니다.')),
                          );
                        }
                      } catch (error) {
                        if (context.mounted) {
                          final message =
                              error is CurrentOutingStudentsException
                                  ? error.message
                                  : '강제 복귀 처리에 실패했습니다.';
                          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
                            SnackBar(content: Text(message)),
                          );
                        }
                      }
                    },
                  );
                },
                icon: AppIcons.forceReturn(
                  color: context.sub2Color,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
