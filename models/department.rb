# frozen_string_literal: true

require 'active_record'

class Department < ActiveRecord::Base
  scope :required, -> { where.not(title: 'соискательство') }
end
