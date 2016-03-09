Feature:
  In order to report on and analyse Pension Wise bookings
  An analyst will need to query the data warehouse

  Scenario: Count all bookings between two dates
    Given booking data exists in the data warehouse
    When I query for bookings between two dates
    Then I am given a count of the number of bookings
