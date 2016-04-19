Feature: Twilio calls query
  To enable reporting based on call data
  Calls facts are imported

  @vcr_booking_bug_all
  Scenario: Appointments are imported with status values
    Given we import offline twilio call data
    When I query calls by date

    Then I see call summary data of:
      | date       | call_volume | average_call_time |
      | 2016-03-29 | 602         | 180               |
      | 2016-03-30 | 462         | 187               |
      | 2016-03-31 | 331         | 205               |
      | 2016-04-01 | 314         | 204               |
      | 2016-04-02 | 17          | 27                |
      | 2016-04-03 | 3           | 14                |
      | 2016-04-04 | 504         | 172               |
      | 2016-04-05 | 303         | 184               |
      | 2016-04-06 | 303         | 205               |
      | 2016-04-07 | 293         | 170               |
      | 2016-04-08 | 250         | 198               |
      | 2016-04-09 | 11          | 28                |
