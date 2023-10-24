# frozen_string_literal: true

require 'rspec'
require_relative '../lib/company_report'
require_relative '../lib/models'

RSpec.describe CompanyReport do
  let(:company) { Company.new(id: 1, name: 'Brooklyn99', top_up: 71) }
  let(:users) do
    [
      User.new(
        last_name: 'Carr',
        first_name: 'Genesis',
        email: 'genesis.carr@demo.com',
        tokens: 71,
        active_status: true
      ),
      User.new(
        last_name: 'Lynch',
        first_name: 'Eileen',
        email: 'eileen.lynch@fake.com',
        tokens: 40,
        active_status: true
      )
    ]
  end

  subject { described_class.new(company:, users_emailed: [], users_not_emailed: users) }

  describe '#generate' do
    it 'generates the expected report for the given company' do
      expected_report = <<~REPORT
        Company Id: 1
        Company Name: Brooklyn99
        Users Emailed:
        Users Not Emailed:
        \tCarr, Genesis, genesis.carr@demo.com
        \t\tPrevious Token Balance: 71
        \t\tNew Token Balance: 142
        \tLynch, Eileen, eileen.lynch@fake.com
        \t\tPrevious Token Balance: 40
        \t\tNew Token Balance: 111
        Total amount of top ups for Brooklyn99: 142
      REPORT

      expect(subject.generate).to match(expected_report)
    end
  end
end
