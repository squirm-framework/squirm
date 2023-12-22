require "crest"
require "lexbor"
require "robots"
require "log"

require "./squirm/fetchers/**"
require "./squirm/ext/**"
require "./squirm/request_filters/**"
require "./squirm/response_filters/**"
require "./squirm/*"

module Squirm
  {% unless flag?(:preview_mt) %}
    raise "Please enable multi-threaded support by passing the 'preview_mt' flag when using this library"
  {% end %}
end
