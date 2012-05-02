class Timespan
	class DurationParseError < StandardError; end

	module Span
		attr_reader :duration

		def seconds= seconds
			raise ArgumentError, "Must be a Numeric, was: #{seconds.inspect}" unless seconds.kind_of? Numeric
			@seconds = seconds
			refresh!	
		end

		def duration= duration
			@duration = case duration
			when Duration
				duration
			when Integer, Hash
				Duration.new duration
			when String
				Duration.new parse_duration(duration)
			end		 
			refresh! unless is_new?			
		end

		def parse_duration text
			spanner_parse text
		rescue Spanner::ParseError => e
			chronic_parse text
		rescue ChronicDuration::DurationParseError => e
			raise Timespan::DurationParseError, "Internal error: neither Spanner or ChronicDuration could parse '#{duration}'"
		end

		def spanner_parse text
			Spanner.parse(text.gsub /and/, '')
		end

		def chronic_parse text
			ChronicDuration.parse text
		end
	end
end