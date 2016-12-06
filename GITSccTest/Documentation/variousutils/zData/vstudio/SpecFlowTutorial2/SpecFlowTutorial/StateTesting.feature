Feature: StateTesting
	In order to avoid silly mistakes
	As a math idiot
	I want to be told the sum of two numbers

@mytag
Scenario: compare sprocs two resultsets
	Given I have the table
	| Name      | Birthdate | HeightInInches | BankAccountBalance |
	| John Galt | 2010-10-02  | 72             | 1234.56            |
	And I have the table
	| Name      | Birthdate | HeightInInches | BankAccountBalance |
	| Phil P | 2010-10-03  | 72             | 1234.56            |
	And I have entered 70 into the calculator
	When I press add
	Then the result should be 120 on the screen
