# frozen_string_literal: true

class ReplyMarkupFormatter
  attr_reader :array

  def initialize(array)
    @array = array
  end

  def call
    Telegram::Bot::Types::ReplyKeyboardMarkup
      .new(keyboard: array.each_slice(1).to_a, one_time_keyboard: true)
  end
end
