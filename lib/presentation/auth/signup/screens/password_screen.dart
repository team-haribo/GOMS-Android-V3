import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project_setting/core/theme/colors/app_colors.dart';
import 'package:project_setting/core/theme/layout/app_layout.dart';
import 'package:project_setting/core/theme/typography/app_text_styles.dart';
import 'package:project_setting/widgets/common/base_scaffold.dart';
import 'package:project_setting/widgets/common/buttons/confirm_button.dart';
import 'package:project_setting/widgets/common/goms_dialog.dart';
import 'package:project_setting/widgets/common/textField/password_textField.dart';

class PasswordScreen extends ConsumerStatefulWidget {
  const PasswordScreen({super.key});

  @override
  ConsumerState<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ConsumerState<PasswordScreen> {
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  /// 비밀번호: 6자 이상, 대/소문자, 숫자, 특수문자 포함
  static final _passwordRegex = RegExp(
    r'^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&?~])[a-zA-Z\d!@#$%^&?~]{6,}$',
  );

  String? _passwordError;
  String? _passwordConfirmError;
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  bool get _isFormValid =>
      _passwordController.text.isNotEmpty &&
      _passwordError == null &&
      _passwordConfirmController.text.isNotEmpty &&
      _passwordConfirmError == null;

  void _validatePassword(String password) {
    setState(() {
      if (password.isNotEmpty && !_passwordRegex.hasMatch(password)) {
        _passwordError = '잘못된 형식의 비밀번호입니다';
      } else {
        _passwordError = null;
      }
      // 비밀번호 확인도 재검증
      if (_passwordConfirmController.text.isNotEmpty) {
        _revalidatePasswordConfirm();
      }
    });
  }

  void _validatePasswordConfirm(String passwordConfirm) {
    setState(() {
      if (passwordConfirm.isNotEmpty &&
          passwordConfirm != _passwordController.text) {
        _passwordConfirmError = '비밀번호가 일치하지 않습니다';
      } else {
        _passwordConfirmError = null;
      }
    });
  }

  void _revalidatePasswordConfirm() {
    if (_passwordConfirmController.text.isNotEmpty &&
        _passwordConfirmController.text != _passwordController.text) {
      _passwordConfirmError = '비밀번호가 일치하지 않습니다';
    } else {
      _passwordConfirmError = null;
    }
  }

  Future<void> _handleSubmit() async {
    if (!_isFormValid) return;

    setState(() => _isLoading = true);

    try {
      // TODO: 실제 비밀번호 설정 API 호출
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // 회원가입 완료 다이얼로그
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('비밀번호 설정에 실패했습니다. 다시 시도해주세요.'),
          backgroundColor: AppColors.negative,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    GomsDialog.show(
      context: context,
      title: '회원가입 완료',
      content: '회원가입이 성공적으로 완료되었습니다.\n곰스에 오신걸 환영합니다!',
      onConfirm: () {
        // TODO: 로그인 화면으로 이동
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BaseScaffold(
      showAppBar: true,
      showAppBarLogo: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 타이틀
                    Text(
                      '비밀번호 설정',
                      style: AppTextStyles.title1.withColor(
                        isDark ? AppColors.mainTextDark : AppColors.mainText,
                      ),
                    ),
                    AppGap.v24,

                    /// 비밀번호 입력
                    PasswordTextField(
                      controller: _passwordController,
                      hintText: '비밀번호를 입력해주세요',
                      errorText: _passwordError,
                      enabled: !_isLoading,
                      onChanged: _validatePassword,
                    ),
                    AppGap.h16,

                    /// 비밀번호 확인
                    PasswordTextField(
                      controller: _passwordConfirmController,
                      hintText: '비밀번호를 다시 입력해주세요',
                      errorText: _passwordConfirmError,
                      enabled: !_isLoading,
                      onChanged: _validatePasswordConfirm,
                    ),
                    AppGap.v12,

                    /// 안내 텍스트
                    Text(
                      '비밀번호는 6자 이상, 대/소문자, 숫자, 특수문자를 포함해 주세요',
                      style: AppTextStyles.text3.withColor(
                        isDark ? AppColors.sub2Dark : AppColors.sub2,
                      ),
                    ),

                    const Spacer(),

                    /// 인증번호 받기 버튼
                    ConfirmButton(
                      text: '로그인',
                      isLoading: _isLoading,
                      onPressed: _isLoading
                          ? null
                          : (_isFormValid ? _handleSubmit : null),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
