Feature: Transforming booking data
  Have the data in a format that can be saved successfully


  @vcr_booking_bug_all
  Scenario: Data is extracted from the booking system api
    Given the booking system contains booking data
    When the booking bug data is transformed
    Then the booking bug data in in the desired format
