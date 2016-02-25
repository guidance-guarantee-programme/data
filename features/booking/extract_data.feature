Feature: Extract booking data
  In order to know how many bookings Pension Wise have made
  The booking manager will need booking data extracted from the booking system

  @vcr
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
  
  @wip
  Scenario: New entry - booking bug data extract
  	Given the booking bug data has new entries since the last extract
  	When the booking bug data is extracted
  	Then only the new entries are extracted
  	And the pre existing entries are not effected

  @wip
  Scenario: Edited entry - booking bug data extract
  	Given the booking bug data has edited entries since the last extract
  	When the booking bug data is extracted
  	Then only the edited entries are extracted
  	And the pre existing entries are not effected

  @wip
  Scenario: No changes - booking bug data extract
  	Given the booking bug data has not changed since the last extract
  	Then no booking bug data is extracted
  	And the pre existing entires are not effected

  @wip
  Scenario: Capturing all changes made to booking data
    When booking data has changed since it was previously extracted
    Then the changed booking data is extracted

  @wip
  Scenario: Tag changed data to distinguish corrections from updates

  @wip
  Scenario: Support compliance tracking with additional metadata
