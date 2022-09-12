module SLCSP
  class Calculator
    attr_reader   :calculations
    attr_accessor :file_path

    def initialize(file_path: File.join(File.dirname(__FILE__), "../../data/slcsp.csv"))
      @file_path    = file_path
      @calculations = []
    end

    def calculate
      @calculations = []

      # perf: Avoid slurping entire file into memory
      CSV.foreach(file_path, headers: true, header_converters: :symbol) do |row|        
        zip = Zip.find_by_zipcode(row[:zipcode])
        if zip&.unambiguous?
          plans      = Plan.where(metal_level: "Silver", state: zip.state, rate_area: zip.canonical_rate_area)
          row[:rate] = plans.map(&:rate).uniq.sort[1]
        end

        @calculations.push(Calculation.new(zipcode: row[:zipcode], rate: row[:rate]))
      end

      @calculations
    end

    # Print to file and screen simultaneously
    def print_calculations
      CSV.open(file_path, "wb") do |csv|
        puts Calculation.column_names.join(",")
        csv << Calculation.column_names

        calculations.each do |calculation|
          puts calculation.to_s
          csv << calculation.to_csv
        end
      end
    end

    private
      class Calculation
        class << self
          def column_names
            ["zipcode", "rate"]
          end
        end


        attr_reader :zipcode, :rate

        def initialize(zipcode:, rate:)
          @zipcode = zipcode
          @rate    = rate && sprintf("%.2f", rate)
        end

        def to_s
          "#{zipcode},#{rate}"
        end

        def to_csv
          [zipcode, rate]
        end
      end
  end
end