# frozen_string_literal: true

##
# Module providing strong parameter filtering and cleaning for Sinatra forms.
#
# Includes methods to:
# - Remove blank values from form inputs
# - Permit only specified keys (like Rails strong params)
#
# == Usage
#   require_relative 'form_helper'
#   helpers FormHelper
#
#   patch '/users/update' do
#     protected!
#     allowed_fields = %w[name phone_number national_id]
#     @current_user.update_attributes(permit_params(*allowed_fields))
#     redirect '/users/my_account'
#   end
#
module FormHelper
  ##
  # Returns a cleaned version of Sinatra's +params+ hash with blank values removed.
  #
  # This method strips whitespace and removes any parameter whose value is:
  # - An empty string (e.g., "")
  # - Only spaces or tabs (e.g., "   ")
  #
  # == Example
  #   # Given: params = { "name" => "Alice", "email" => " ", "age" => "" }
  #   cleaned_params
  #   # => { "name" => "Alice" }
  #
  # @return [Hash{String => String}] sanitized parameters with blank values removed
  def cleaned_params
    params.reject { |_, value| value.to_s.strip.empty? }
  end

  ##
  # Filters incoming +params+ to only allow specified keys.
  #
  # This mimics Rails' strong parameters, allowing you to safely whitelist fields.
  # Blank values are also automatically removed.
  #
  # == Example
  #   # Given params: { "name" => "Alice", "_method" => "patch", "pin" => "" }
  #   permit_params("name", "pin")
  #   # => { "name" => "Alice" }
  #
  # @param [Array<String>] allowed_keys keys to allow through
  # @return [Hash{String => String}] filtered params
  def permit_params(*allowed_keys)
    cleaned_params.select { |key, _| allowed_keys.include?(key) }
  end
end
