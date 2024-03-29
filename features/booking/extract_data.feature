Feature: Extract booking data
  In order to know how many bookings Pension Wise have made
  The booking manager will need booking data extracted from the booking system

  @vcr_booking_bug_all
  Scenario: Data is extracted from the booking system api
    Given the booking system contains booking data
    When a list of bookings is requested from the booking api
    Then a list of bookings is extracted from the booking api
