# frozen_string_literal: true

Company = Struct.new(:id, :name, :top_up, :email_status)
User = Struct.new(:id, :first_name, :last_name, :email, :company_id, :email_status, :active_status, :tokens)
