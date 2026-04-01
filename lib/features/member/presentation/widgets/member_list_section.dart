import 'package:flutter/material.dart';
import 'package:goms/features/member/domain/entities/member_entity.dart';
import 'package:goms/features/member/presentation/widgets/member_card.dart';

class MemberListSection extends StatelessWidget {
  const MemberListSection({
    required this.members,
    super.key,
  });

  final List<MemberEntity> members;

  @override
  Widget build(BuildContext context) {
    if (members.isEmpty) {
      return const Center(
        child: Text('표시할 멤버가 없습니다.'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: members.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        return MemberCard(member: members[index]);
      },
    );
  }
}
