Feature: Persist booking data
  In order to have a full audit trail of data imported from the booking system
  The booking manager will need to persist a copy of imported data to disk

  @wip
  Scenario: Data is written to disk before any restructuring takes place
    When booking data is extracted from the booking api
    Then the extracted booking data is persisted to disk
