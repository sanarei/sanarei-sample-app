# frozen_string_literal: true

require 'bcrypt'

##
# Represents a user of the Sanarei sample application.
#
# This model is backed by MongoDB using Mongoid. It stores personal identification
# information and timestamps for creation and updates. The user's PIN is securely stored using a
# one-way bcrypt hash and cannot be decrypted.
#
# == Fields
# - +name+:: The full name of the user. Must be unique and present.
# - +national_id+:: The user's national ID. Must be unique and present.
# - +pin_digest+:: A bcrypt hash of the user's PIN. Never decrypted.
#
# == Virtual Attributes
# - +pin+:: Virtual attribute used to set the PIN. Not stored directly.
#
# == Validations
# - Presence validation for +name+, +national_id+
# - Presence validation for +pin+ on create only
# - Uniqueness validation for +name+ and +national_id+
#
# == Mongoid Modules
# - +Mongoid::Document+:: Adds MongoDB persistence
# - +Mongoid::Timestamps+:: Adds +created_at+ and +updated_at+ timestamps
#
# == Example
#   user = User.new(
#     name: "Jane Doe",
#     national_id: "12345678",
#     pin: "4321"
#   )
#   user.save
#
#   user.authenticate_pin("4321") # => true
#   user.authenticate_pin("9999") # => false
#
# @!attribute [rw] name
#   @return [String] The full name of the user
#
# @!attribute [rw] national_id
#   @return [String] The user's national identification number
#
# @!attribute [r] pin
#   @return [String, nil] The plain PIN value used only during assignment
#
# @!attribute [rw] pin_digest
#   @return [String] The hashed (BCrypt) version of the PIN
#
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, type: String
  field :national_id, type: String
  field :pin_digest, type: String

  validates :name, :national_id, presence: true
  validates :name, :national_id, uniqueness: true
  validates :pin, presence: true, on: :create

  attr_reader :pin

  ##
  # Sets the user's PIN and stores it as a bcrypt hash in +pin_digest+.
  #
  # @param [String] new_pin the plain-text PIN to be hashed
  def pin=(new_pin)
    @pin = new_pin
    self.pin_digest = BCrypt::Password.create(new_pin)
  end

  ##
  # Verifies a plain-text PIN against the stored bcrypt hash.
  #
  # @param [String] test_pin the PIN to compare against the stored hash
  # @return [Boolean] true if the PIN is correct, false otherwise
  def authenticate_pin(test_pin)
    BCrypt::Password.new(pin_digest) == test_pin
  end
end
