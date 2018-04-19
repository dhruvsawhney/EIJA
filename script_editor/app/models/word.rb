class Word < ApplicationRecord
  belongs_to :line
  has_many :edits, through: :cuts
  has_many :cuts
  has_many :uncuts
end
