# frozen_string_literal: true

# !/usr/bin/env ruby

require 'date'
require 'optparse'

# Description of Calendar class
class Calendar
  def initialize(month: Date.today.month, year: Date.today.year)
    @month = month
    @year = year
    @first_day = Date.new(@year, @month, 1)
    @last_day = Date.new(@year, @month, -1)
  end

  def calendar_header
    puts @first_day.strftime('%m月 %Y').center(20)
    puts %w[日 月 火 水 木 金 土].join(' ')
  end

  def calendar_body
    start_date = @first_day.day
    end_date = @last_day.day
    start_wday = @first_day.wday
    array_days = [*start_date..end_date]

    days = array_days.map do |date|
      date.to_s.rjust(2)
    end

    start_row = (['  '] * start_wday).push(days).flatten
    row_week = start_row.each_slice(7).to_a
    row_week.each { |week| puts week.join(' ') }
  end

  def render_calendar_month
    calendar_header
    calendar_body
  end
end

params = ARGV.getopts('m:', 'y:')
month = params['m']&.to_i
year = params['y']&.to_i
calendar = Calendar.new(
  month: month || Date.today.month,
  year: year || Date.today.year
)
calendar.render_calendar_month
