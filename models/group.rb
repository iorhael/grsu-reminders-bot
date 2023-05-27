# frozen_string_literal: true

require 'active_record'

class Group < ActiveRecord::Base
  belongs_to :faculty
  belongs_to :department
end
