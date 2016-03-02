Feature: Save booking data
  In order to report on data from external sources
  The booking manager will need to save the data to the database

  @vcr_booking_bug_all
  Scenario: Booking Bug data is stored in the Booking Fact table
    Given the booking system contains booking data
    When booking data is extracted from the booking api
    Then the extracted booking data is stored as facts
