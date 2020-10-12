# frozen_string_literal: true

module ActiveInteractor
  module Version
    MAJOR = 1
    MINOR = 1
    PATCH = 0
    PRE = nil
    META = nil

    def self.gem_version
      @gem_version ||= [MAJOR, MINOR, PATCH, PRE, META].compact.join('.').freeze
    end

    def self.semver
      @semver ||= begin
        primary = [MAJOR, MINOR, PATCH].join('.').freeze
        return primary if PRE.nil?
        return "#{primary}-#{PRE}" if META.nil?

        "#{primary}-#{PRE}+#{META}"
      end
    end
  end
end
