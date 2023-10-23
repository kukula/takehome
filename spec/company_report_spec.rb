# frozen_string_literal: true

require 'rspec'
require_relative '../lib/company_report'

RSpec.describe CompanyReport do
  let(:company) do
    {
      id: 1,
      name: 'Blue Cat Inc.',
      users_emailed: [],
      users_not_emailed: [
        { name: 'Carr, Genesis', email: 'genesis.carr@demo.com', previous_balance: 71, new_balance: 142 },
        { name: 'Lynch, Eileen', email: 'eileen.lynch@fake.com', previous_balance: 40, new_balance: 111 }
      ]
    }
  end

  subject { described_class.new(company) }

  describe '#generate' do
    it 'generates the expected report for the given company' do
      expected_report = <<~REPORT
        Company Id: 1
        Company Name: Blue Cat Inc.
        Users Emailed:
        Users Not Emailed:
        \tCarr, Genesis, genesis.carr@demo.com
        \t\tPrevious Token Balance: 71
        \t\tNew Token Balance: 142
        \tLynch, Eileen, eileen.lynch@fake.com
        \t\tPrevious Token Balance: 40
        \t\tNew Token Balance: 111
        Total amount of top ups for Blue Cat Inc.: 142
      REPORT

      expect(subject.generate).to match(expected_report)
    end
  end
end
