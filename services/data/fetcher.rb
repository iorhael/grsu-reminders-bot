# frozen_string_literal: true

require 'faraday'
require 'faraday/retry'
require 'active_support'

class Data::Fetcher
  API_URL = 'https://api.grsu.by/1.x/app1'
  DEFAULT_LANG = 'ru_RU'

  def departments(lang: DEFAULT_LANG)
    with_response_format do
      connection.get('getDepartments', { lang: }).body['items']
    end
  end

  def faculties(lang: DEFAULT_LANG)
    with_response_format do
      connection.get('getFaculties', { lang: }).body['items']
    end
  end

  def teachers(lang: DEFAULT_LANG)
    with_response_format do
      connection.get('getTeachers', { lang: }).body['items']
    end
  end

  def groups(department_id, faculty_id, course, lang: DEFAULT_LANG)
    with_response_format do
      connection.get('getGroups', { departmentId: department_id, facultyId: faculty_id, course:, lang: }).body['items']
    end
  end

  def group_schedule(group_id, date_start, date_end, lang: DEFAULT_LANG)
    with_response_format do
      connection.get('getGroupSchedule', { groupId: group_id, dateStart: date_start, dateEnd: date_end, lang: }).body['days']
    end
  end

  private

  def with_response_format
    response = yield

    case response
    when Hash
      response.deep_symbolize_keys
    when Array
      response.map(&:deep_symbolize_keys)
    end
  end

  def connection
    @connection ||= Faraday.new(url: 'https://api.grsu.by/1.x/app1', request: { timeout: 5 }) do |conn|
      conn.request :retry
      conn.response :json
    end
  end
end
