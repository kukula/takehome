# frozen_string_literal: true

require 'json'
require_relative './models'
require_relative './company_report'

# The Main application class that glues all the things together
class Main
  def initialize(companies_file:, users_file:, report_klass: CompanyReport)
    @companies_file = companies_file
    @users_file = users_file
    @report_klass = report_klass
  end

  def run
    companies
      .sort { _1[:id] <=> _2[:id] }
      .map { report_for(_1) }
      .join("\n")
  end

  private

  attr_reader :companies_file, :users_file, :report_klass

  def report_for(company)
    report_klass
      .new(**data_for_report(company))
      .generate
  end

  def data_for_report(company)
    company_users = get_company_users(company.id)
    if company_users.empty?
      return {
        company:,
        users_emailed: [],
        users_not_emailed: []
      }
    end

    company_users = company_users.group_by(&:email_status)
    users_emailed = company_users[true].sort { _1.last_name <=> _2.last_name }
    users_not_emailed = company_users[false].sort { _1.last_name <=> _2.last_name }

    {
      company:,
      users_emailed:,
      users_not_emailed:
    }
  end

  def get_company_users(company_id)
    users.select { _1.company_id == company_id }
  end

  def companies
    @companies ||= JSON.parse(File.read(companies_file), object_class: Company)
  rescue NameError => _e
    raise "Unexpected format of the file `#{companies_file}`"
  end

  def users
    @users ||= JSON.parse(File.read(users_file), object_class: User)
  rescue NameError => _e
    raise "Unexpected format of the file `#{users_file}`"
  end
end
