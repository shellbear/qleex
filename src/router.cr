require "http/server"
require "radix"

require "./errors"

module Qleex
  class Router
    include HTTP::Handler

    def initialize(@basePath : String = "")
      @staticRoutes = Hash(String, RouterMethod).new
      @dynamicRoutes = Radix::Tree(RouterMethod).new
      if !@basePath.empty?
        if !@basePath.starts_with?('/')
          @basePath = '/' + @basePath
        end
        if @basePath.ends_with?('/')
          @basePath = @basePath.rchop
        end
      end
    end

    def call(context : Context)
      request_path = context.request.method + context.request.path

      if @staticRoutes.has_key?(request_path)
        @staticRoutes[request_path].call(context, Parameters.new)
      else
        result = @dynamicRoutes.find(request_path)
        if result.found?
          result.payload.call(context, result.params)
        else
          call_next(context)
        end
      end
    end

    def addRoute(method : String, path : String, func : RouterMethod)
      method = method.upcase

      if !HTTP_METHODS.includes?(method)
        raise InvalidHTTPMethod.new(method)
      end
      if path.includes?(':') || path.includes?('*')
        @dynamicRoutes.add(method + @basePath + path, func)
      else
        @staticRoutes[method + @basePath + path] = func
      end
    end

    def route(methods : String | Array(String), paths : String | Array(String), func : RouterMethod)
      if methods.is_a?(String)
        methods = [methods]
      end
      if paths.is_a?(String)
        paths = [paths]
      end

      methods.each do |method|
        paths.each do |path|
          addRoute(method, path, func)
        end
      end
    end

    {% for method in HTTP_METHODS %}
      def {{method.id.downcase}}(path : String | Array(String), func : RouterMethod)
        route("{{method.id}}", path, func)
      end
    {% end %}
  end
end
