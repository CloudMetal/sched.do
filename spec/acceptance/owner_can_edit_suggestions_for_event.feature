Feature: Owner can edit suggestions for event

  Scenario: Owner edits event suggestion
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    And I view the "Clown party" event
    When I click "Edit"
    When I suggest "dinner"
    And I press "Update event"
    Then I should see a suggestion of "dinner"

  Scenario: Owner tries to edit event suggestion with invalid data
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    And I view the "Clown party" event
    When I click "Edit"
    And I suggest an empty string
    And I press "Update event"
    Then I should see "This field is required" under the first suggestion

  Scenario: Owner tries to edit an event that they did not create
    Given I am signed in
    And I created an event named "Clown party" with a suggestion of "lunch"
    When I sign in as a different user
    And I view the "Clown party" event
    Then I should not see an edit link
