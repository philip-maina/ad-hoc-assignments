# stdlib
require "csv"

# modules
require_relative "slcsp/plan"
require_relative "slcsp/zip"
require_relative "slcsp/calculator"

module SLCSP
  class Error < StandardError; end
end