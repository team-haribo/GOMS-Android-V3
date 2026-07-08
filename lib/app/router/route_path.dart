class RoutePath {
  const RoutePath._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signUp = '/signup';
  static const String password = '/password';
  static const String verify = '/verify';
  static const String findPassword = '/find-password';
  static const String resetPassword = '/reset-password';
  static const String qr = '/qr';
  static const String qrIssue = '/qr/issue';
  static const String qrResult = '/qr/result/:resultType';
  static const String deleteAccount = '/delete-account';
  static const String privacyPolicy = '/privacy-policy';
  static const String map = '/map';
  static const String direction = '/map/direction';
  static const String mapDetail = '/map/detail';
  static const String writeReview = '/write-review';
  static const String home = '/home';
  static const String outingState = '/outing-state';
  static const String studentCouncilMembers = '/student-council/members';
  static const String studentCouncilLate = '/student-council/late';
  static const String studentCouncilReports = '/student-council/reports';
  static const String studentCouncilReportDetail =
      '/student-council/reports/detail';
  static const String myPage = '/mypage';
  static const String members = '/members';

  static String qrResultLocation(String resultType) => '/qr/result/$resultType';
}
