# frozen_string_literal: true

require 'active_record'

class Group < ActiveRecord::Base
  belongs_to :faculty
  belongs_to :department

  has_many :students, class_name: 'User'

  scope :sorted, -> { order(title: :asc) }
end
