# frozen_string_literal: true

require 'active_record'

class Lesson < ActiveRecord::Base
  belongs_to :teacher
  belongs_to :group
end
