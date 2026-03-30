import 'package:flutter_riverpod/legacy.dart';
import 'package:goms/core/enums/role_enum.dart';

final roleProvider = StateProvider<RoleEnum>((ref) => RoleEnum.user);
