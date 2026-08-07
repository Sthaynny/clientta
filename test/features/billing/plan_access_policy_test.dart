import 'package:clientta/core/plan/plan_access_policy.dart';
import 'package:clientta/features/appointments/domain/models/appointment_status.dart';
import 'package:clientta/features/appointments/domain/models/service_appointment.dart';
import 'package:clientta/features/billing/domain/entities/user_subscription.dart';
import 'package:flutter_test/flutter_test.dart';

ServiceAppointment _appointment({
  required String id,
  String status = 'agendado',
  String? seriesId,
}) {
  return ServiceAppointment(
    id: id,
    clientName: 'Cliente',
    clientPhone: '11999999999',
    serviceType: 'Empréstimo consignado',
    appointmentDate: DateTime(2026, 8, 7),
    startTime: '09:00',
    endTime: '10:00',
    status: status,
    seriesId: seriesId,
  );
}

void main() {
  group('PlanAccessPolicy', () {
    test('allows cloud sync only with pro access', () {
      expect(
        PlanAccessPolicy.canAccessCloudSync(
          const UserSubscription(
            status: SubscriptionStatus.active,
            plan: SubscriptionPlan.pro,
          ),
        ),
        isTrue,
      );
      expect(
        PlanAccessPolicy.canAccessCloudSync(UserSubscription.inactive),
        isFalse,
      );
    });

    test('blocks new appointments after free limit', () {
      final existing = List.generate(
        PlanAccessPolicy.freeMaxActiveAppointments,
        (index) => _appointment(id: '$index'),
      );

      expect(
        PlanAccessPolicy.canAddAppointment(
          subscription: UserSubscription.inactive,
          existingAppointments: existing,
        ),
        isFalse,
      );
      expect(
        PlanAccessPolicy.canAddAppointment(
          subscription: UserSubscription.inactive,
          existingAppointments: existing,
          isEdit: true,
        ),
        isTrue,
      );
    });

    test('ignores canceled appointments in active count', () {
      final existing = List.generate(
        PlanAccessPolicy.freeMaxActiveAppointments,
        (index) => _appointment(
          id: '$index',
          status: AppointmentStatus.cancelado.value,
        ),
      );

      expect(
        PlanAccessPolicy.canAddAppointment(
          subscription: UserSubscription.inactive,
          existingAppointments: existing,
        ),
        isTrue,
      );
    });

    test('blocks new recurring series after free limit', () {
      final existing = List.generate(
        PlanAccessPolicy.freeMaxActiveSeries,
        (index) => _appointment(id: '$index', seriesId: 'series_$index'),
      );

      expect(
        PlanAccessPolicy.canCreateSeries(
          subscription: UserSubscription.inactive,
          existingAppointments: existing,
        ),
        isFalse,
      );
    });
  });
}
