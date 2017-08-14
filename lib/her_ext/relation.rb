module HerExt
  module Relation
    def limit(limit)
      where('page[size]' => limit)
    end

    def order(args = [:id])
      column, order = args.respond_to?(:first) ? args.first : [args]
      column = "-#{column}" if order && order.to_sym == :desc
      where(sort: column.to_s)
    end

    def preload(name, klass)
      parent = instance_variable_get(:@parent)

      objects = instance_variable_get(:@_fetch)
      objects = fetch unless objects

      relation = klass.where(entity_id: objects.map(&:id), entity_type: parent)
      relation = relation.map { |o| [o.entity_id, o] }.to_h

      objects.each do |object|
        object.instance_variable_set("@#{name}", relation[object.id.to_i])
      end

      self
    end
  end
end
