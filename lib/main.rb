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
      .compact
      .join
  end

  private

  attr_reader :companies_file, :users_file, :report_klass

  def report_for(company)
    data = data_for_report(company)

    return unless data

    report_klass
      .new(**data)
      .generate
  end

  def data_for_report(company)
    company_users = get_company_users(company.id)
    return if company_users.empty?

    if company.email_status
      company_users = company_users.group_by(&:email_status)
      users_emailed = company_users[true]
      users_not_emailed = company_users[false]
    else
      users_emailed = []
      users_not_emailed = company_users
    end

    {
      company:,
      users_emailed:,
      users_not_emailed:
    }
  end

  def get_company_users(company_id)
    users.select { _1.active_status && _1.company_id == company_id }
      .sort { _1.last_name <=> _2.last_name }
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
