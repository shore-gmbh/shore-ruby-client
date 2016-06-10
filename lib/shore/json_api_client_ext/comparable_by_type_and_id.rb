module Shore
  module JsonApiClientExt
    # Two objects are equal if their {#type} and {#id} are the same.
    # Two objects are ordered relatively to each other first by {#type} and
    # then by {#id}.
    module ComparableByTypeAndId
      extend ActiveSupport::Concern
      include Comparable

      def <=>(other)
        return nil unless other.respond_to?(:type) && other.respond_to?(:id)
        if (result = (type <=> other.type)) == 0
          return id <=> other.id
        end

        result
      end

      alias_method :eql?, :==

      def hash
        [type, id].hash
      end
    end
  end
end
