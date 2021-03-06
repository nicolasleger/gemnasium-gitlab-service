require 'gemnasium/gitlab_service/version'
require 'net/https'

module Gemnasium
  module GitlabService
    class Connection
      DEFAULT_ENDPOINT = 'api.gemnasium.com'
      DEFAULT_API_VERSION = 'v1'
      DEFAULT_SSL = true
      DEFAULT_AGENT = "Gemnasium Gitlab Service - v#{Gemnasium::GitlabService::VERSION}"

      def initialize(options = {})
        use_ssl = options.fetch(:use_ssl){ DEFAULT_SSL }
        host = options.fetch(:host){ DEFAULT_ENDPOINT }
        port = options.fetch(:port){ use_ssl ? 443 : 80 }
        api_version = options.fetch(:api_version){ DEFAULT_API_VERSION }.to_s

        @connection = Net::HTTP.new(host, port)
        @connection.use_ssl = use_ssl
        @api_key = options.fetch(:api_key)
        @base_url = "/#{ api_version }/"
      end

      def post(path, body, headers = {})
        request = Net::HTTP::Post.new(@base_url + path, headers.merge('Accept' => 'application/json', 'Content-Type' => 'application/json', 'User-Agent' => DEFAULT_AGENT))
        request.basic_auth('X', @api_key)
        request.body = body
        @connection.request(request)
      end

      def get(path, headers = {})
        request = Net::HTTP::Get.new(@base_url + path, headers.merge('Accept' => 'application/json', 'Content-Type' => 'application/json', 'User-Agent' => DEFAULT_AGENT))
        request.basic_auth('X', @api_key)
        @connection.request(request)
      end

    end
  end
end
