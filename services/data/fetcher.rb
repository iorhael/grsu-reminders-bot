# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'

class Data::Fetcher
  API_URL = 'https://api.grsu.by/1.x/app1'
  DEFAULT_LANG = 'ru_RU'

  def departments(lang: DEFAULT_LANG)
    connection.get('getDepartments', { lang: }).body['items']
  end

  def faculties(lang: DEFAULT_LANG)
    connection.get('getFaculties', { lang: }).body['items']
  end

  def teachers(lang: DEFAULT_LANG)
    connection.get('getTeachers', { lang: }).body['items']
  end

  def groups(department_id, faculty_id, course, lang: DEFAULT_LANG)
    connection.get('getGroups', { departmentId: department_id, facultyId: faculty_id, course:, lang: }).body['items']
  end

  def group_schedule(group_id, date_start, date_end, lang: DEFAULT_LANG)
    connection.get('getGroupSchedule', { groupId: group_id, dateStart: date_start, dateEnd: date_end, lang: }).body['days']
  end

  private

  def connection
    @connection ||= Faraday.new(url: 'https://api.grsu.by/1.x/app1', request: { timeout: 5 }) do |conn|
      conn.request :retry
      conn.response :json
    end
  end
end
