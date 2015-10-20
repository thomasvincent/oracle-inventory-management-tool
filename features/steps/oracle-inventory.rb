
Given(/^I have provisioned the following infrastructure:$/) do |specification|
  @infrastructure = Leibniz.build(specification)
end

Given(/^I have run Chef$/) do
  #  @infrastructure.destroy
  #  @infrastructure.converge
end

Given(/^\(initial state\)$/) do
  pending # express the regexp above with the code you wish you had
end

When(/^\(action taken\)$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^\(expected result\)$/) do
  pending # express the regexp above with the code you wish you had
end

Then(/^cleanup test env$/) do
  #  @infrastructure.destroy if @infrastructure
end
