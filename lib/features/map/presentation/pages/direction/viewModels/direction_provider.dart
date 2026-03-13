import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/map/presentation/pages/direction/models/direction_state.dart';

final directionProvider = NotifierProvider<DirectionNotifier, DirectionState>(
  DirectionNotifier.new,
);

class DirectionNotifier extends Notifier<DirectionState> {
  @override
  DirectionState build() => DirectionState.initial();

  void setDestination(String destination) {
    state = state.copyWith(
      destination: destination,
      status: DirectionStatus.loading,
    );
    Future.microtask(() => _fetchRoutes());
  }

  Future<void> _fetchRoutes() async {
    try {
      // TODO: 실제 경로 탐색 API 호출로 교체
      await Future.delayed(const Duration(milliseconds: 600));
      state = state.copyWith(
        status: DirectionStatus.success,
        routeOptions: const [
          RouteOption(label: '추천', minutes: 8, meters: 339, calories: 25),
          RouteOption(label: '큰길우선', minutes: 8, meters: 339, calories: 25),
        ],
      );
    } catch (e) {
      state = state.copyWith(
        status: DirectionStatus.failure,
        errorMessage: '경로를 불러오는데 실패했습니다.',
      );
    }
  }

  void selectRoute(int index) {
    state = state.copyWith(selectedRouteIndex: index);
  }

  void setDeparture(String departure) {
    state = state.copyWith(departure: departure);
  }

  void swapLocations() {
    final temp = state.departure;
    state = state.copyWith(
      departure: state.destination,
      destination: temp,
    );
  }

  void clearError() {
    state = state.copyWith(
      status: DirectionStatus.initial,
      errorMessage: null,
    );
  }
}


