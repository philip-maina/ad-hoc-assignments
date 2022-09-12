module SLCSP
  class Zip
    class << self
      # perf: Avoid slurping entire file into memory
      def table
        return @table if defined?(@table)

        @table = {}
        CSV.foreach(
          File.join(File.dirname(__FILE__), "../../data/zips.csv"), 
          headers: true, 
          header_converters: :symbol
        ) { |row| upsert(**row.to_h) }
        @table
      end

      # update or insert/create
      def upsert(**attributes)
        find_by_zipcode(attributes[:zipcode])&.add_rate_area(attributes[:rate_area]) || 
        create(**attributes)
      end

      def find_by_zipcode(zipcode)
        table[zipcode]
      end
  
      def create(**attributes)
        zip = new(
          zipcode: attributes[:zipcode], 
          state: attributes[:state], 
          rate_areas: [attributes[:rate_area]]
        )

        return nil unless zip.valid?

        # perf: table is indexed by zipcode
        @table[zip.zipcode] = zip
      end

      def clear!
        @table = {}
      end
    end


    attr_reader :zipcode, :state, :rate_areas

    def initialize(zipcode:, state:, rate_areas:)
      @zipcode    = sanitize_attr(zipcode)
      @state      = sanitize_attr(state)
      @rate_areas = rate_areas.map { |rate_area| sanitize_attr(rate_area) }.reject(&:empty?)
    end

    def valid?
      !zipcode.empty? &&
      !state.empty?   &&
      rate_areas.any?
    end

    def add_rate_area(rate_area)
      rate_area = sanitize_attr(rate_area)
      @rate_areas.push(rate_area) unless rate_area.empty? || rate_areas.include?(rate_area)
      self
    end

    def canonical_rate_area
      ambiguous? ? nil : rate_areas.first
    end

    def unambiguous?
      !ambiguous?
    end

    def ambiguous?
      rate_areas.size > 1
    end

    private
      # robustness
      def sanitize_attr(attr)
        attr.to_s.strip
      end
  end
end