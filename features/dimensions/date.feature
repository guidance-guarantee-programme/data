Feature: Date dimension
  In order to facilitate partitioning of fact data
  We will need to maintain a date dimension

  Scenario Outline: Characteristics of date are captured
    Given the date is 26/2/2016
    When we build a date dimension for that date
    Then we can constrain or group on <characteristic>, eg <example>

    Examples:
      | characteristic         | example          |
      | date                   | 26/2/2016        |
      | date_name              | 26 February 2016 |
      | date_name_abbreviated  | 26 Feb 2016      |
      | year                   | 2016             |
      | quarter                | 1                |
      | month                  | 2                |
      | month_name             | February         |
      | month_name_abbreviated | Feb              |
      | week                   | 8                |
      | day_of_year            | 57               |
      | day_of_quarter         | 57               |
      | day_of_month           | 26               |
      | day_of_week            | 5                |
      | day_name               | Friday           |
      | day_name_abbreviated   | Fri              |
      | weekday_weekend        | Weekday          |
