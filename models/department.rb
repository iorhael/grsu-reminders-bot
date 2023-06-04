# frozen_string_literal: true

# == Schema Information
#
# Table name: departments
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  fetched_at :datetime
#
require 'active_record'

class Department < ActiveRecord::Base
  scope :required, -> { where.not(title: 'соискательство') }
end
