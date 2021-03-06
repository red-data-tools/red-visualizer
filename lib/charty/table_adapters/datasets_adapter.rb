module Charty
  module TableAdapters
    class DatasetsAdapter < BaseAdapter
      TableAdapters.register(:datasets, self)

      include Enumerable

      def self.supported?(data)
        defined?(Datasets::Dataset) &&
          data.is_a?(Datasets::Dataset)
      end

      def initialize(dataset)
        @table = dataset.to_table
        @records = []

        self.columns = self.column_names
        self.index = 0 ... length
      end

      def data
        @table
      end

      def column_length
        column_names.length
      end

      def column_names
        @table.column_names
      end

      def length
        data.n_rows
      end

      def each(&block)
        return to_enum(__method__) unless block_given?

        @table.each_record(&block)
      end

      # @param [Integer] row  Row index
      # @param [Symbol,String,Integer] column Column index
      def [](row, column)
        if row
          record = @table.find_record(row)
          return nil if record.nil?
          record[column]
        else
          Vector.new(@table[column], index: index, name: column)
        end
      end
    end
  end
end
