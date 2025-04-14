# frozen_string_literal: true

##
# Module providing helpers for cleaning form input in Sinatra.
#
# This is especially useful for ignoring blank fields in update forms,
# so empty values don't overwrite existing user data unintentionally.
#
# == Usage
#   require_relative 'form_helper'
#   helpers FormHelper
#
#   post '/my_account/update' do
#     protected!
#     @current_user.update_attributes(cleaned_params)
#     redirect '/my_account'
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
end
