# frozen_string_literal: true

##
# Helper module for generating HTML links in a Sinatra application.
#
# This module defines a `link_to` method similar to the one in Rails,
# which can be used in ERB or other template views to create anchor tags
# with dynamic attributes.
#
# Example usage in an ERB template:
#   <%= link_to "Google", "https://google.com", target: "_blank", class: "external" %>
#
# This will generate:
#   <a href="https://google.com" target="_blank" class="external">Google</a>
#
module LinkHelper
  ##
  # Generates an HTML anchor (`<a>`) tag.
  #
  # @param name [String] The visible text or HTML inside the link.
  # @param url [String] The URL or path the link should point to.
  # @param options [Hash] Additional HTML attributes to add to the `<a>` tag.
  #   - Common keys: `:target`, `:class`, `:id`, `:rel`, etc.
  #
  # @return [String] An HTML-safe anchor tag string.
  #
  # @example Simple link
  #   link_to("Home", "/")
  #   # => <a href="/">Home</a>
  #
  # @example Link with extra attributes
  #   link_to("Profile", "/user", class: "nav-link", id: "user-link")
  #   # => <a href="/user" class="nav-link" id="user-link">Profile</a>
  #
  def link_to(name, url, options = {})
    attrs = options.map { |k, v| "#{k}=\"#{v}\"" }.join(" ")
    "<a href=\"#{url}\" #{attrs}>#{name}</a>"
  end
end
