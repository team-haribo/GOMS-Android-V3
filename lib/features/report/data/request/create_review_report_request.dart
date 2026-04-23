class CreateReviewReportRequest {
  const CreateReviewReportRequest({
    required this.reason,
  });

  final String reason;

  Map<String, dynamic> toJson() {
    return {
      'content': reason,
    };
  }
}
