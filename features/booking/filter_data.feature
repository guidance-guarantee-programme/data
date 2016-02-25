Feature: Filter booking data
  In order to know how many bookings Pension Wise have made
  The booking manager will need booking data extracted from the booking system

  @vcr_booking_bug_all
  Scenario: Filtering new booking bug data
    Given the booking bug data has new entries since the last extract
    When the booking bug data is filtered
    Then only new entries are returned

  @wip
  Scenario: Filtering edited booking bug data entry
    Given the booking bug data has edited entries since the last extract
    When the booking bug data is filtered
    Then only the edited entries are returned

  @wip
  Scenario: No changes - booking bug data extract
    Given the booking bug data has not changed since the last extract
    Then no booking bug data is extracted
    And the pre existing entires are not effected

  @wip
  Scenario: Tag changed data to distinguish corrections from updates

  @wip
  Scenario: Support compliance tracking with additional metadata
