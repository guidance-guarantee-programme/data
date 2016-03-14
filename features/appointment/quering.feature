Feature: Appointment status
  To enable reporting based on appointment outcome
  Appointment facts will require date and satte dimensions

  @vcr_booking_bug_all
  Scenario: Appointments are imported with status values
    Given we import booking bug appointment data between "5/2/2015" and "20/3/2015"
    When I query appointments by state between "5/2/2015" and "20/3/2015"

    Then I see appointments volumes by state of:
      | appointment_status | volume_of_appointments |
      | Awaiting Status    | 182                    |
      | Complete           | 2                      |
      | Incomplete         | 1                      |
      | Ineligible         | 1                      |
      | No show            | 2                      |
