Feature: Extract booking data
  In order to know how many bookings Pension Wise have made
  The booking manager will need booking data extracted from the booking system

  @wip
  Scenario: Data is written to disk before any restructuring takes place
    When booking data is extracted from the booking api
    Then the extracted booking data is persisted to disk
