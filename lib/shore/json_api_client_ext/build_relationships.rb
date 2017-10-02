# frozen_string_literal: true

module Shore
  module JsonApiClientExt
    module BuildRelationships # :nodoc:
      def build_relationships(relations)
        relationships.attributes = to_relationships(relations)
      end

      private

      def to_relationships(relations)
        relationships = relations.map do |relation|
          to_relationship(relation)
        end

        relationships.flatten.reduce(:merge)
      end

      def to_relationship(relation)
        {
          relation[:resource] => {
            'data': { 'id' => relation[:id], 'type' => relation[:table] }
          }
        }
      end
    end
  end
end
