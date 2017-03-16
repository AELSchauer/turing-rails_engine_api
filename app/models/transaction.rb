class Transaction < ApplicationRecord
  belongs_to :invoice

  def self.random
    order("RANDOM()").first
  end
end
