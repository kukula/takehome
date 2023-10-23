# frozen_string_literal: true

# The CompanyReport class that generates company report d'uh
class CompanyReport
  def initialize(company)
    @company = company
  end

  def generate
    report = company_details

    report << "Users Emailed:\n"

    company[:users_emailed].each do |user|
      report << user_details(user)
    end

    report << "Users Not Emailed:\n"

    company[:users_not_emailed].each do |user|
      report << user_details(user)
    end

    report << "Total amount of top ups for #{company[:name]}: #{total_top_up}\n\n"
  end

  private

  attr_reader :company

  def company_details
    "Company Id: #{company[:id]}\nCompany Name: #{company[:name]}\n"
  rescue RuntimeError => e
    warn e
  end

  def user_details(user)
    <<~DETAILS
      \t#{user[:name]}, #{user[:email]}
      \t\tPrevious Token Balance: #{user[:previous_balance]}
      \t\tNew Token Balance: #{user[:new_balance]}
    DETAILS
  rescue RuntimeError => e
    warn e
  end

  def total_top_up
    users_balance(company[:users_emailed]) + users_balance(company[:users_not_emailed])
  end

  def users_balance(users)
    users.sum { |user| user[:new_balance] - user[:previous_balance] }
  end
end
