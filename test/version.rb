require 'minitest/autorun'
require_relative '../lib/nanocurrency/version'

class ReleaseVersionTest < Minitest::Test
  def test_version
    release = ENV["GEM_RELEASE_VERSION"]
    puts Nanocurrency::VERSION
    puts release
    assert release == Nanocurrency::VERSION
  end
end
