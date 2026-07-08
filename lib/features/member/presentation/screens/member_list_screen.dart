import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/member/domain/entities/member_entity.dart';
import 'package:goms/features/member/presentation/providers/member_list_provider.dart';

class MemberListScreen extends StatelessWidget {
  const MemberListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Members'),
      ),
      body: const MemberListBody(),
    );
  }
}

// ---------------------------------------------------------------------------
// MemberListBody (moved from widgets/member_list_body.dart)
// ---------------------------------------------------------------------------

class MemberListBody extends ConsumerWidget {
  const MemberListBody({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(memberListProvider);

    return state.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      data: (members) => MemberListSection(members: members),
      error: (error, _) => MemberErrorView(
        message: _toErrorMessage(error),
        onRetry: () {
          ref.read(memberListProvider.notifier).reload();
        },
      ),
    );
  }

  String _toErrorMessage(Object error) {
    if (error is MemberListException) {
      return error.message;
    }

    return '오류가 발생했습니다.';
  }
}

// ---------------------------------------------------------------------------
// MemberListSection (moved from widgets/member_list_section.dart)
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// MemberCard (moved from widgets/member_card.dart)
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// MemberErrorView (moved from widgets/member_error_view.dart)
// ---------------------------------------------------------------------------

class MemberErrorView extends StatelessWidget {
  const MemberErrorView({
    required this.message,
    required this.onRetry,
    super.key,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
          ],
        ),
      ),
    );
  }
}
