module Qleex
  class InvalidHTTPMethod < Exception
    def initialize(method)
      super "#{method} is not a valid HTTP method."
    end
  end
end
