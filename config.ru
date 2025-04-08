require './config/environment'

if ActiveRecord::Migrator.needs_migration?
  raise 'Migrations are pending. Run `rake db:migrate` to resolve the issue.'
end

run ApplicationController
use Api::BaseController
use Api::V1::Customer::AccountDetailsController
use Api::V1::Customer::LoanStatementsController
