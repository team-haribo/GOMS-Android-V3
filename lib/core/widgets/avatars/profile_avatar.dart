import 'package:flutter/material.dart';
import 'package:goms/core/theme/icons/app_icons.dart';
import 'package:goms/core/utils/logger.dart';
import 'package:image_fade/image_fade.dart';

class ProfileAvatar extends StatefulWidget {
  const ProfileAvatar({
    super.key,
    required this.radius,
    required this.imageUrl,
    required this.backgroundColor,
    this.showErrorMessage = false,
    this.errorMessage = '프로필 이미지를 불러오지 못했어요.',
  });

  final double radius;
  final String? imageUrl;
  final Color backgroundColor;
  final bool showErrorMessage;
  final String errorMessage;

  @override
  State<ProfileAvatar> createState() => _ProfileAvatarState();
}

class _ProfileAvatarState extends State<ProfileAvatar> {
  Widget _buildDefaultAvatar(double diameter) {
    return AppIcons.profileCircle(width: diameter, height: diameter);
  }

  Widget _buildLoadingAvatar(double diameter) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: 0.18,
            child: _buildDefaultAvatar(diameter),
          ),
          SizedBox(
            width: diameter * 0.34,
            height: diameter * 0.34,
            child: const CircularProgressIndicator(strokeWidth: 2),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = (widget.imageUrl ?? '').trim();
    final diameter = widget.radius * 2;

    if (imageUrl.isEmpty) {
      return CircleAvatar(
        radius: widget.radius,
        backgroundColor: widget.backgroundColor,
        child: _buildDefaultAvatar(diameter),
      );
    }

    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: widget.backgroundColor,
      child: ClipOval(
        child: ImageFade(
          image: NetworkImage(imageUrl),
          width: diameter,
          height: diameter,
          fit: BoxFit.cover,
          placeholder: _buildLoadingAvatar(diameter),
          errorBuilder: (_, error) {
            Logger.e(
              'ProfileAvatar image load failed. hasImageUrl=${imageUrl.isNotEmpty} error=$error',
              tag: 'PROFILE',
            );
            return _buildDefaultAvatar(diameter);
          },
        ),
      ),
    );
  }
}
