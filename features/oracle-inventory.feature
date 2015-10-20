Feature: cookbook oracle-inventory (feature description)

  In order to (pick one)
    Protect revenue
    Increase revenue
    Manage cost
    Increase brand value
    Make the product remarkable
    Provide more value to your customers
  As a (role)
  I want (desired outcome)

  Background:
    Given I have provisioned the following infrastructure:
    | Server Name | Operating System | Version | Chef Version | Run List              |
    | localhost   | centos           | 6.5     | 12.0.0       | acx-oracle-inventory::default |

    And I have run Chef

  Scenario: (scenario description)
    Given (initial state)
    When (action taken)
    Then (expected result)
    And cleanup test env
