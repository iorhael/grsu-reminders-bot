# frozen_string_literal: true

# == Schema Information
#
# Table name: teachers
#
#  id         :bigint           not null, primary key
#  name       :string
#  surname    :string
#  patronym   :string
#  post       :string
#  phone      :string
#  descr      :string
#  email      :string
#  skype      :string
#  fetched_at :datetime
#
require 'active_record'

class Teacher < ActiveRecord::Base
end
