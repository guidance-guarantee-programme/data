Feature: Transforming booking data
  Have the data in a format that can be saved successfully

  @vcr_booking_bug_all
  Scenario: Data from the booking system is transformed ready for saving
    Given the booking system contains booking data
    And our stored dataset has date dimensions for the period "1/1/2015" to "31/12/2015"
    When the booking bug data is transformed
    Then the booking bug data is ready to be saved

  @vcr_booking_bug_all
  Scenario: Errors during the booking bug data transformation are logged
    Given the booking system contains booking data
    And our stored dataset has date dimensions for the period "1/1/2015" to "31/1/2015"
    When the booking bug data is transformed
    Then errors during the transformation process are logged
