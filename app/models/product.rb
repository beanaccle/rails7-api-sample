# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :user

  has_many :payment_histories, dependent: :nullify

  validates :name, presence: true
  validates :price, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
