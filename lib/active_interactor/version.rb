# frozen_string_literal: true

module ActiveInteractor
  # The ActiveInteractor version info
  #
  # @author Aaron Allen <hello@aaronmallen.me>
  # @since unreleased
  module Version
    # The ActiveInterctor major version number
    # @return [Integer] The ActiveInteractor major version number
    MAJOR = 1
    # The ActiveInterctor minor version number
    # @return [Integer] The ActiveInteractor minor version number
    MINOR = 1
    # The ActiveInterctor patch version number
    # @return [Integer] The ActiveInteractor patch version number
    PATCH = 2
    # The ActiveInterctor pre-release version
    # @return [String | nil] The ActiveInteractor pre-release version
    PRE = nil
    # The ActiveInterctor meta version
    # @return [String | nil] The ActiveInteractor meta version
    META = nil

    # The ActiveInterctor rubygems version
    # @return [String] The ActiveInteractor rubygems version
    def self.gem_version
      @gem_version ||= [MAJOR, MINOR, PATCH, PRE, META].compact.join('.').freeze
    end

    # The ActiveInterctor semver version
    # @return [String] The ActiveInteractor semver version
    def self.semver
      @semver ||= begin
        primary = [MAJOR, MINOR, PATCH].join('.').freeze
        if PRE.nil?
          primary
        else
          META.nil? ? "#{primary}-#{PRE}" : "#{primary}-#{PRE}+#{META}"
        end
      end
    end
  end

  # The ActiveInteractor version
  # @return [String] the ActiveInteractor version
  VERSION = Version.semver
end
