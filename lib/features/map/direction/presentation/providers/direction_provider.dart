import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goms/features/map/data/map_constants.dart';
import 'package:goms/features/map/data/services/current_location_service.dart';
import 'package:goms/features/map/data/services/kakao_local_service.dart';
import 'package:goms/features/map/data/services/kakao_mobility_service.dart';
import 'package:goms/features/map/data/models/map_coordinate.dart';
import 'package:goms/features/map/data/services/map_service_providers.dart';
import 'package:goms/features/map/direction/presentation/models/direction_state.dart';
import 'package:goms/features/map/discovery/presentation/models/popular_place.dart';

final directionProvider = NotifierProvider<DirectionNotifier, DirectionState>(
  DirectionNotifier.new,
);

class DirectionNotifier extends Notifier<DirectionState> {
  late final KakaoMobilityService _mobilityService;
  late final KakaoLocalService _localService;
  late final CurrentLocationService _currentLocationService;

  MapCoordinate _schoolCoordinate = gomsFallbackSchoolCoordinate;
  MapCoordinate _departureCoordinate = gomsFallbackSchoolCoordinate;
  MapCoordinate? _destinationCoordinate;

  @override
  DirectionState build() {
    _mobilityService = ref.read(kakaoMobilityServiceProvider);
    _localService = ref.read(kakaoLocalServiceProvider);
    _currentLocationService = ref.read(currentLocationServiceProvider);
    Future.microtask(_initializeSchoolCoordinate);
    return DirectionState.initial().copyWith(departure: gomsSchoolName);
  }

  Future<void> setDestination(PopularPlace place) async {
    _destinationCoordinate = place.coordinate;
    state = state.copyWith(
      destination: place.name,
      selectedRouteIndex: 0,
      status: DirectionStatus.loading,
      errorMessage: null,
    );
    await _fetchRoutes();
  }

  Future<void> selectDeparture(String departure) async {
    try {
      state = state.copyWith(
        departure: departure,
        status: DirectionStatus.loading,
        errorMessage: null,
        selectedRouteIndex: 0,
      );

      if (departure == '내 위치') {
        _departureCoordinate = await _resolveCurrentLocation();
      } else {
        await _initializeSchoolCoordinate();
        _departureCoordinate = _schoolCoordinate;
      }

      await _fetchRoutes();
    } catch (e) {
      state = state.copyWith(
        status: DirectionStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> swapLocations() async {
    if (_destinationCoordinate == null) {
      return;
    }

    final nextDepartureCoordinate = _destinationCoordinate!;
    final nextDestinationCoordinate = _departureCoordinate;
    final nextDeparture = state.destination;
    final nextDestination = state.departure;

    _departureCoordinate = nextDepartureCoordinate;
    _destinationCoordinate = nextDestinationCoordinate;

    state = state.copyWith(
      departure: nextDeparture,
      destination: nextDestination,
      status: DirectionStatus.loading,
      selectedRouteIndex: 0,
      errorMessage: null,
    );

    await _fetchRoutes();
  }

  void selectRoute(int index) {
    if (index < 0 || index >= state.routeOptions.length) {
      return;
    }
    state = state.copyWith(selectedRouteIndex: index);
  }

  void clearError() {
    state = state.copyWith(
      status: DirectionStatus.initial,
      errorMessage: null,
    );
  }

  Future<void> _fetchRoutes() async {
    final destinationCoordinate = _destinationCoordinate;
    if (destinationCoordinate == null || state.destination.trim().isEmpty) {
      state = state.copyWith(status: DirectionStatus.initial);
      return;
    }

    try {
      final routes = await _mobilityService.fetchRoutes(
        origin: _departureCoordinate,
        destination: destinationCoordinate,
        originName:
            state.departure.trim().isEmpty ? gomsSchoolName : state.departure,
        destinationName: state.destination,
      );

      state = state.copyWith(
        status: DirectionStatus.success,
        routeOptions: routes,
        selectedRouteIndex: 0,
      );
    } catch (e) {
      state = state.copyWith(
        status: DirectionStatus.failure,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> _initializeSchoolCoordinate() async {
    try {
      _schoolCoordinate = await _localService.resolveAddress(gomsSchoolAddress);
      if (state.departure == gomsSchoolName || state.departure.isEmpty) {
        _departureCoordinate = _schoolCoordinate;
      }
    } on KakaoApiException {
      _schoolCoordinate = gomsFallbackSchoolCoordinate;
      if (state.departure == gomsSchoolName || state.departure.isEmpty) {
        _departureCoordinate = _schoolCoordinate;
      }
    }
  }

  Future<MapCoordinate> _resolveCurrentLocation() {
    return _currentLocationService.getCurrentLocation();
  }
}
