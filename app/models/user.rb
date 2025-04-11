# frozen_string_literal: true

##
# Represents a user of the Sanarei sample application.
#
# This model is backed by MongoDB using Mongoid. It stores personal
# identification information and timestamps for creation and updates.
#
# == Fields
# - +name+:: The full name of the user. Must be unique and present.
# - +national_id+:: The user's national identification number. Must be unique and present.
# - +pin+:: A personal identification number used for verification or login. Must be present.
#
# == Validations
# - Presence validation for +name+, +national_id+, and +pin+
# - Uniqueness validation for +name+ and +national_id+
#
# == Mongoid Modules
# - +Mongoid::Document+:: Adds persistence and document behavior
# - +Mongoid::Timestamps+:: Automatically manages +created_at+ and +updated_at+ timestamps
#
# == Example
#   user = User.new(
#     name: "Jane Doe",
#     national_id: "12345678",
#     pin: "4321"
#   )
#   user.save
#
# @!attribute [rw] name
#   @return [String] The full name of the user
#
# @!attribute [rw] national_id
#   @return [String] The user's national identification number
#
# @!attribute [rw] pin
#   @return [String] The personal identification number for the user
#
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :national_id, type: String
  field :pin, type: String

  validates :name, :national_id, :pin, presence: true
  validates :name, :national_id, uniqueness: true
end
