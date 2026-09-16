import 'package:flutter/material.dart';
import 'package:goms/features/member/domain/entities/member_entity.dart';

class MemberCard extends StatelessWidget {
  const MemberCard({
    required this.member,
    super.key,
  });

  final MemberEntity member;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueGrey.shade100,
          backgroundImage: member.profileImageUrl.isEmpty
              ? null
              : NetworkImage(member.profileImageUrl),
          child: member.profileImageUrl.isEmpty
              ? Text(member.name.isEmpty ? '?' : member.name[0])
              : null,
        ),
        title: Text(member.name),
        subtitle: Text('${member.studentNumber} · ${member.role}'),
      ),
    );
  }
}
