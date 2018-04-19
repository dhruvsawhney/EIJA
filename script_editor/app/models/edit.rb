class Edit < ApplicationRecord
  has_many :words, through: :cuts
  has_many :lines, through: :line_cuts
  belongs_to :play
end
