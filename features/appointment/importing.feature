Feature: Appointment status
  To enable reporting based on appointment outcome

  @vcr_booking_bug_all
  Scenario: Appointmonets are imported with status values
    Given the booking system contains booking data
    And our stored dataset has date dimensions for the period "5/2/2015" to "20/3/2015"
    When appointment data is extracted from the booking api
    And I query appointments by status between "5/2/2015" and "20/3/2015"
    Then I see appointments volumes by status of:
      | appointment_status | volume_of_appointments |
      | Awaiting Status    | 182                    |
      | Complete           | 2                      |
      | Incomplete         | 1                      |
      | Ineligible         | 1                      |
      | No show            | 2                      |

  @wip
  Scenario: Count all appointments by status
    Given appointment data exists in the data warehouse
    When I query for <booking_status> appointments between <start_date> and <end_date>
    Then I see the number of <booking_status> appointments between <start_date> and <end_date>

      | booking_status     |
      | Awaiting Status    |
      | Completed          |
      | Incomplete         |
      | Ineligible         |
      | No Show            |

