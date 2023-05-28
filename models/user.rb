# frozen_string_literal: true

require 'active_record'

class User < ActiveRecord::Base
  belongs_to :department
  belongs_to :faculty
  belongs_to :group
end
