# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id            :bigint           not null, primary key
#  title         :string
#  department_id :bigint
#  faculty_id    :bigint
#  course        :integer
#  fetched_at    :datetime
#
require 'active_record'

class Group < ActiveRecord::Base
  belongs_to :faculty
  belongs_to :department

  has_many :students, class_name: 'User'

  scope :sorted, -> { order(title: :asc) }
end
