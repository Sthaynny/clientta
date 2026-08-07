import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:clientta/core/network/network_status_port.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clientta/features/home/screen/home_view_model.dart';

import '../../mock/model_mock.dart';

class _MockAppointmentRepository extends Mock implements AppointmentRepository {}

class _MockNetworkStatus extends Mock implements NetworkStatusPort {}

void main() {
  setUpAll(() {
    registerFallbackValue(tInstanceServiceAppointment);
  });

  late _MockAppointmentRepository repository;  late _MockNetworkStatus networkStatus;
  late HomeViewModel viewModel;

  final today = DateTime(2026, 8, 7);
  final yesterday = DateTime(2026, 8, 6);
  final tomorrow = DateTime(2026, 8, 8);

  ServiceAppointment appointment({
    required String id,
    required DateTime date,
    required String startTime,
    String status = 'agendado',
    String? notes,
  }) {
    return ServiceAppointment(
      id: id,
      clientName: 'Cliente $id',
      clientPhone: '(11) 90000-0000',
      serviceType: 'Empréstimo',
      appointmentDate: date,
      startTime: startTime,
      endTime: '10:00',
      status: status,
      notes: notes,
    );
  }

  setUpAll(() {
    registerFallbackValue(
      ServiceAppointment(
        id: 'fallback',
        clientName: 'Fallback',
        clientPhone: '(11) 00000-0000',
        serviceType: 'Outros',
        appointmentDate: DateTime(2026, 1, 1),
        startTime: '09:00',
        endTime: '10:00',
        status: AppointmentStatus.agendado.value,
      ),
    );
  });

  setUp(() {
    repository = _MockAppointmentRepository();
    networkStatus = _MockNetworkStatus();
    viewModel = HomeViewModel(
      appointmentRepository: repository,
      networkStatus: networkStatus,
      hasProSync: () async => false,
    );
    when(() => networkStatus.isOnline()).thenAnswer((_) async => true);
  });

  group('filterTodayAppointments', () {
    test('filtra apenas atendimentos do dia de referência', () {
      final result = HomeViewModel.filterTodayAppointments(
        [
          appointment(id: '1', date: today, startTime: '09:00'),
          appointment(id: '2', date: yesterday, startTime: '10:00'),
          appointment(id: '3', date: tomorrow, startTime: '11:00'),
        ],
        reference: today,
      );

      expect(result.map((e) => e.id), ['1']);
    });

    test('ordena por startTime (C-107)', () {
      final result = HomeViewModel.filterTodayAppointments(
        [
          appointment(id: 'late', date: today, startTime: '14:00'),
          appointment(id: 'early', date: today, startTime: '08:30'),
          appointment(id: 'mid', date: today, startTime: '10:00'),
        ],
        reference: today,
      );

      expect(result.map((e) => e.id), ['early', 'mid', 'late']);
    });

    test('exclui atendimentos cancelados', () {
      final result = HomeViewModel.filterTodayAppointments(
        [
          appointment(id: 'ok', date: today, startTime: '09:00'),
          appointment(
            id: 'cancelled',
            date: today,
            startTime: '10:00',
            status: AppointmentStatus.cancelado.value,
          ),
        ],
        reference: today,
      );

      expect(result.map((e) => e.id), ['ok']);
    });
  });

  group('HomeViewModel load', () {
    test('carrega atendimentos de hoje ordenados', () async {
      final now = DateTime.now();
      when(() => repository.getAll()).thenAnswer(
        (_) async => [
          appointment(id: 'b', date: now, startTime: '15:00'),
          appointment(id: 'a', date: now, startTime: '08:00'),
          appointment(id: 'other', date: yesterday, startTime: '09:00'),
        ],
      );

      await viewModel.load.execute();

      expect(viewModel.load.completed, isTrue);
      expect(viewModel.todayAppointments.map((e) => e.id), ['a', 'b']);
    });

    test('define banner offline quando sem rede', () async {
      when(() => repository.getAll()).thenAnswer((_) async => []);
      when(() => networkStatus.isOnline()).thenAnswer((_) async => false);

      await viewModel.load.execute();

      expect(viewModel.syncBannerState, HomeSyncBannerState.offline);
    });

    test('define banner sync pendente para Pro offline', () async {
      viewModel = HomeViewModel(
        appointmentRepository: repository,
        networkStatus: networkStatus,
        hasProSync: () async => true,
      );
      when(() => repository.getAll()).thenAnswer((_) async => []);
      when(() => networkStatus.isOnline()).thenAnswer((_) async => false);

      await viewModel.load.execute();

      expect(viewModel.syncBannerState, HomeSyncBannerState.syncPending);
    });
  });

  group('HomeViewModel status transitions', () {
    test('markComplete atualiza status para concluído', () async {
      final now = DateTime.now();
      final entry = appointment(id: '1', date: now, startTime: '09:00');
      when(() => repository.getAll()).thenAnswer((_) async => [entry]);
      when(() => repository.save(any())).thenAnswer((_) async {});

      await viewModel.load.execute();
      await viewModel.markComplete.execute(entry);

      final captured =
          verify(() => repository.save(captureAny())).captured.single
              as ServiceAppointment;
      expect(captured.status, AppointmentStatus.concluido.value);
      expect(viewModel.markComplete.completed, isTrue);
    });

    test('cancelAppointment atualiza status para cancelado', () async {
      final now = DateTime.now();
      final entry = appointment(id: '1', date: now, startTime: '09:00');
      when(() => repository.getAll()).thenAnswer((_) async => [entry]);
      when(() => repository.save(any())).thenAnswer((_) async {});

      await viewModel.load.execute();
      await viewModel.cancelAppointment.execute(entry);

      final captured =
          verify(() => repository.save(captureAny())).captured.single
              as ServiceAppointment;
      expect(captured.status, AppointmentStatus.cancelado.value);
      expect(viewModel.cancelAppointment.completed, isTrue);
    });
  });
}
