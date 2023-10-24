# frozen_string_literal: true

require_relative './models'

# The CompanyReport class that generates company report d'uh
class CompanyReport
  def initialize(company:, users_emailed:, users_not_emailed:)
    @company = company
    @users_emailed = users_emailed
    @users_not_emailed = users_not_emailed
    @total_top_up = 0
  end

  def generate
    report = company_details

    report << "Users Emailed:\n"

    users_emailed.each do |user|
      report << user_details(user)
    end

    report << "Users Not Emailed:\n"

    users_not_emailed.each do |user|
      report << user_details(user)
    end

    report << "Total amount of top ups for #{company.name}: #{total_top_up}\n\n"
  end

  private

  attr_reader :company, :users_emailed, :users_not_emailed, :total_top_up

  def company_details
    "Company Id: #{company.id}\nCompany Name: #{company.name}\n"
  rescue RuntimeError => e
    warn e
  end

  def user_details(user)
    new_tokens = new_balance(user)
    top_up = new_tokens - user.tokens
    @total_top_up += top_up

    <<~DETAILS
      \t#{user.last_name}, #{user.first_name}, #{user.email}
      \t\tPrevious Token Balance: #{user.tokens}
      \t\tNew Token Balance: #{new_tokens}
    DETAILS
  rescue RuntimeError => e
    warn e
  end

  def new_balance(user)
    return user.tokens unless user.active_status

    user.tokens + company.top_up
  end
end
