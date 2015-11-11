# Libs.
require 'rest-client'
require 'hashie'

# Version.
require 'square/version'

# Data types.
require 'square/data_type'
require 'square/data_types/money'
require 'square/data_types/device'
require 'square/data_types/payment_discount'
require 'square/data_types/payment_tax'
require 'square/data_types/payment_modifier'
require 'square/data_types/payment_item_detail'
require 'square/data_types/payment_itemization'
require 'square/data_types/refund'
require 'square/data_types/tender'
require 'square/data_types/payment'
require 'square/data_types/fee'
require 'square/data_types/item_image'
require 'square/data_types/category'
require 'square/data_types/item_variation'
require 'square/data_types/modifier_list'
require 'square/data_types/modifier_option'
require 'square/data_types/item'


# API Resources.
require 'square/api_resource'
require 'square/item'
require 'square/payment'
require 'square/variation'
require 'square/webhook'



# RestClient.log = Logger.new(STDOUT)

module Square
  @api_host = 'https://connect.squareup.com'
  @next_link = nil

  # RegExp used for parsing Link headers when the API paginates data. I don't
  # care about rel attributes right now because this is the only thing this is
  # used for.
  LINK_REGEXP = /^<([ -~]+)>;/i

  class << self
    attr_accessor :api_host, :access_token, :next_link
  end

  # Make an API call to Square.
  #
  # @param options [Hash] Hash of options. Expects something like this:
  #
  # {
  #   method: 'POST',
  #   endpoint: 'items',
  #   request: {...}
  # }
  #
  # @return [RestClient::Response]
  def self.make_request(options = {}, &block)
    custom_headers = options[:headers] || {}
    headers = request_headers(access_token).merge(custom_headers)

    method = (options[:method] || 'get').downcase.to_sym
    merchant = options[:merchant] || 'me'
    payload = options[:payload] || nil
    params = options[:params]

    # Allow passing in a fully formed URL.
    url = options[:url] || File.join(api_host, 'v1', merchant, options[:endpoint])

    request_params = {
      method: method,
      url: url,
      headers: headers
    }

    # Create a payload.
    if payload.present? && payload.respond_to?(:to_json)
      payload = payload.to_json
      request_params.merge!(payload: payload)
    end

    # Merge in params.
    if params.present? && !params.empty?
      request_params[:headers].merge!(params: params)
    end

    response = RestClient::Request.execute(request_params, &block)

    # Detect a Link header.
    if response.headers[:link].present?
      match = LINK_REGEXP.match(response.headers[:link])
      self.next_link = match.captures[0]
    else
      self.next_link = nil
    end

    response
  end

  # Get the next page, if available.
  def self.next
    if next_link.nil?
      return nil
    end

    self.make_request(url: next_link)
  end

  protected

  # Get the request headers.
  #
  # @param [String] Square access token.
  #
  # @return [Hash] Hash of headers.
  def self.request_headers(access_token)
    {
      authorization: "Bearer #{access_token}",
      accept: 'application/json',
      content_type: 'application/json'
    }
  end
end
