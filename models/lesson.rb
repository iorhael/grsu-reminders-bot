# frozen_string_literal: true

# == Schema Information
#
# Table name: lessons
#
#  id         :bigint           not null, primary key
#  start      :datetime
#  end        :datetime
#  type       :string
#  title      :string
#  address    :string
#  room       :string
#  subgroup   :json
#  teacher_id :bigint
#  group_id   :bigint
#  fetched_at :datetime
#
require 'active_record'

class Lesson < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  belongs_to :teacher
  belongs_to :group
end
