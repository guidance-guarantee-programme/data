Feature: Extract booking data
  In order to know how many bookings Pension Wise have made
  The booking manager will need booking data extracted from the booking system

  @wip
  Scenario: Data is extracted from the booking system api
    Given the booking system contains booking data
    When a list of bookings is requested from the booking api
    Then a list of bookings is extracted from the booking api

  @wip
  Scenario: Data is written to disk before any restructuring takes place
    When booking data is extracted from the booking api
    Then the extracted booking data is persisted to disk

  @wip
  Scenario: Isolating the changed data to allow selective processing
    When the booking data is a mix of new and already extracted data
    Then only the changed booking data is extracted
