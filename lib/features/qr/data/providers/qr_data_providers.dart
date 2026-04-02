import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/core/network/dio_providers.dart';
import 'package:goms/features/qr/data/datasources/qr_remote_datasource.dart';
import 'package:goms/features/qr/data/repositories/qr_repository_impl.dart';
import 'package:goms/features/qr/domain/repositories/qr_repository.dart';
import 'package:goms/features/qr/domain/usecases/issue_qr_usecase.dart';

final qrRemoteDataSourceProvider = Provider<QrRemoteDataSource>((ref) {
  return QrRemoteDataSource(ref.watch(dioProvider));
});

final qrRepositoryProvider = Provider<QrRepository>((ref) {
  return QrRepositoryImpl(
    remoteDataSource: ref.watch(qrRemoteDataSourceProvider),
  );
});

final issueQrUseCaseProvider = Provider<IssueQrUseCase>((ref) {
  return IssueQrUseCase(ref.watch(qrRepositoryProvider));
});
