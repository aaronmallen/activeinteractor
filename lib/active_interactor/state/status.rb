# frozen_string_literal: true

module ActiveInteractor
  module State
    # State status methods. Because {Status} is a module classes should include {Status} rather than inherit from it.
    #
    # @author Aaron Allen <hello@aaronmallen.me>
    # @since unreleased
    module Status
      # Whether the {Manager state} instance has {Mutation#fail! failed}. By default, a new instance is successful and
      # only changes when explicitly {Mutation#fail! failed}.
      #
      # @note The {#failure?} method is the inverse of the {#success?} method
      #
      # @return [Boolean] `false` by default or `true` if {Mutation#fail! failed}.
      def failure?
        @_failed || false
      end
      alias fail? failure?

      # Whether the {Manager state} instance has {Mutation#rollback! rolled back}.
      #
      # @return [Boolean] `false` by default or `true` if {Mutation#rollback! rolled back}.
      def rolled_back?
        @_rolled_back || false
      end

      # Whether the {Manager state} instance is successful. By default, a new instance is successful and only changes
      # when explicitly {Mutation#fail! failed}.
      #
      # @note The {#success?} method is the inverse of the {#failure?} method
      #
      # @return [Boolean] `true` by default or `false` if {Mutation#fail! failed}
      def success?
        !failure?
      end
      alias successful? success?
    end
  end
end
