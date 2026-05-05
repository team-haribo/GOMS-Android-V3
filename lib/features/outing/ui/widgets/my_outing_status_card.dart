import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/enums/role_enum.dart';
import 'package:goms/core/providers/role_provider.dart';
import 'package:goms_design_system/goms_design_system.dart';
import 'package:goms/features/outing/ui/widgets/profile_container.dart';
import 'package:goms/features/outing/domain/enums/outing_status.dart';
import 'package:goms/features/outing/ui/providers/my_outing_status_provider.dart';

class MyOutingStatusCard extends ConsumerWidget {
  const MyOutingStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(roleProvider);
    final myOutingStatus = ref.watch(myOutingStatusProvider);

    return myOutingStatus.when(
      skipLoadingOnRefresh: true,
      data: (value) {
        return ProfileContainer(
          name: value.name,
          grade: value.grade,
          major: value.department,
          lateCount: value.lateCount,
          showLateCount: role != RoleEnum.admin,
          showInfoBelowName: role == RoleEnum.admin,
          profileImageUrl: value.profileImageUrl,
          showProfileImageErrorMessage: true,
          profileImageErrorMessage: '프로필 이미지를 불러오지 못했어요.',
          status: role == RoleEnum.admin
              ? OutingStatus.admin
              : OutingStatus.fromServer(value.status),
        );
      },
      loading: () => ProfileContainer(
        name: '불러오는 중',
        grade: 0,
        major: '',
        lateCount: 0,
        showLateCount: role != RoleEnum.admin,
        showInfoBelowName: role == RoleEnum.admin,
        profileImageUrl: '',
        status:
            role == RoleEnum.admin ? OutingStatus.admin : OutingStatus.waiting,
      ),
      error: (error, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileContainer(
            name: '정보 없음',
            grade: 0,
            major: '',
            lateCount: 0,
            showLateCount: role != RoleEnum.admin,
            showInfoBelowName: role == RoleEnum.admin,
            profileImageUrl: '',
            status: role == RoleEnum.admin
                ? OutingStatus.admin
                : OutingStatus.waiting,
          ),
          AppGap.v12,
          Text(
            error is MyOutingStatusException
                ? error.message
                : '내 외출 현황을 불러오지 못했어요.',
            style: AppTextStyles.text2.copyWith(
              color: context.sub2Color,
            ),
          ),
          AppGap.v8,
          TextButton(
            onPressed: () {
              ref.read(myOutingStatusProvider.notifier).reload();
            },
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}
