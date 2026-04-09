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
  bool _didShowImageError = false;

  @override
  void didUpdateWidget(covariant ProfileAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _didShowImageError = false;
    }
  }

  void _showImageErrorMessage() {
    if (!widget.showErrorMessage || _didShowImageError) {
      return;
    }

    _didShowImageError = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger == null) {
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text(widget.errorMessage)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = (widget.imageUrl ?? '').trim();
    final diameter = widget.radius * 2;

    if (imageUrl.isEmpty) {
      _showImageErrorMessage();
      return CircleAvatar(
        radius: widget.radius,
        backgroundColor: widget.backgroundColor,
        child: AppIcons.profileCircle(width: diameter, height: diameter),
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
          placeholder:
              AppIcons.profileCircle(width: diameter, height: diameter),
          errorBuilder: (_, error) {
            Logger.e(
              'ProfileAvatar image load failed. hasImageUrl=${imageUrl.isNotEmpty} error=$error',
              tag: 'PROFILE',
            );
            _showImageErrorMessage();
            return AppIcons.profileCircle(width: diameter, height: diameter);
          },
        ),
      ),
    );
  }
}
