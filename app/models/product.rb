# encoding: utf-8

class Product < ActiveRecord::Base
  attr_accessible :description, :image_url, :price, :title
  validates :title, :description, :image_url, presence: true
  validates :price, numericality: {greater_than_or_equal_to: 0.01}
  validates :title, uniqueness: true
  validates :image_url, allow_blank: true, format: {
    with: %r{\.(gif|jpg|png)$}i,
    message: 'only URL of GIF, JPG or PNG'
  }
  
  has_many :line_items
  has_many :orders, through: :line_items
  before_destroy :ensure_not_referenced_by_any_line_item
  
  private
    
    # ensure not referenced by any line itme
    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        return true
      else
        errors.add(:base, 'exist line item')
        return false
      end
    end
end
