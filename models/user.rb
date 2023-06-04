# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id            :bigint           not null, primary key
#  uid           :bigint
#  notificate    :boolean
#  department_id :integer
#  faculty_id    :integer
#  group_id      :integer
#
require 'active_record'

class User < ActiveRecord::Base
  belongs_to :department
  belongs_to :faculty
  belongs_to :group
end
