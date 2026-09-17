import 'package:flutter/material.dart';
import 'package:goms/features/member/presentation/widgets/member_list_body.dart';

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
