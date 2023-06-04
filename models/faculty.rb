# frozen_string_literal: true

# == Schema Information
#
# Table name: faculties
#
#  id         :bigint           not null, primary key
#  title      :string           not null
#  fetched_at :datetime
#
require 'active_record'

class Faculty < ActiveRecord::Base
end
