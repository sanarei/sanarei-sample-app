# frozen_string_literal: true

# Makes successful anonymous page responses safe for a shared HTTP cache.
# Session-bearing and authenticated requests remain private and retain cookies.
class PublicPageCache
  CACHE_SECONDS = 120 * 60
  CACHE_CONTROL = "public, max-age=#{CACHE_SECONDS}, s-maxage=#{CACHE_SECONDS}".freeze

  def initialize(app)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    return [status, headers, body] unless cacheable?(env, status)

    cache_headers = headers.dup
    cache_headers['cache-control'] = CACHE_CONTROL
    cache_headers['vary'] = vary_header(cache_headers['vary'])
    cache_headers.delete('set-cookie')
    cache_headers.delete('Set-Cookie')
    [status, cache_headers, body]
  end

  private

  def cacheable?(env, status)
    %w[GET HEAD].include?(env['REQUEST_METHOD']) &&
      status.between?(200, 299) &&
      env['HTTP_COOKIE'].to_s.empty? &&
      env['HTTP_AUTHORIZATION'].to_s.empty?
  end

  def vary_header(existing_header)
    (existing_header.to_s.split(',').map(&:strip) + %w[Cookie Authorization])
      .reject(&:empty?).uniq.join(', ')
  end
end
