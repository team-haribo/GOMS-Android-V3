import 'package:flutter/material.dart';
import 'package:goms/features/member/ui/models/member_model.dart';
import 'package:goms/features/member/ui/widgets/member_card.dart';

class MemberListSection extends StatelessWidget {
  const MemberListSection({
    required this.members,
    super.key,
  });

  final List<MemberModel> members;

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
