module SLCSP
  class Plan
    class << self
      # perf: table is indexed by (metal_level,state,rate_area)
      def index_columns
        [:metal_level, :state, :rate_area]
      end

      def index_key(attributes)
        "#{attributes.slice(*index_columns).values.join(',')}"
      end

      # perf: Avoid slurping entire file into memory
      def table
        return @table if defined?(@table)

        @table = {}
        CSV.foreach(
          File.join(File.dirname(__FILE__), "../../data/plans.csv"),
          headers: true,
          header_converters: :symbol
        ) { |row| create(**row.to_h) }
        @table
      end

      def create(**attributes)
        plan = new(
          id: attributes[:plan_id],
          metal_level: attributes[:metal_level],
          state: attributes[:state],
          rate_area: attributes[:rate_area],
          rate: attributes[:rate]
        )

        return nil unless plan.valid?

        key = index_key(plan.attributes)
        @table[key] ||= []
        @table[key].push(plan)
      end

      def where(**conditions)
        table[index_key(conditions)] || []
      end

      def clear!
        @table = {}
      end
    end


    attr_reader :id, :metal_level, :rate, :state, :rate_area

    def initialize(id:, metal_level:, state:, rate_area:, rate:)
      @id          = sanitize_attr(id)
      @metal_level = sanitize_attr(metal_level)
      @state       = sanitize_attr(state)
      @rate_area   = sanitize_attr(rate_area)

      # robustness: Handle erroneous rates
      @rate        =
        begin
          Float(rate)
        rescue ArgumentError, TypeError
          nil
        end
    end

    def valid?
      !id.empty?          &&
      !metal_level.empty? &&
      !state.empty?       &&
      !rate_area.empty?   &&
      !rate.nil?
    end

    def attributes
      {
        id: id,
        metal_level: metal_level,
        state: state,
        rate_area: rate_area,
        rate: rate
      }
    end

    private
      # robustness
      def sanitize_attr(attr)
        attr.to_s.strip
      end
  end
end