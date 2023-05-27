# frozen_string_literal: true

require 'active_record'

class Lesson < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  belongs_to :teacher
  belongs_to :group
end
