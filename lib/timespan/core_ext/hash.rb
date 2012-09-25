class Hash
  def __evolve_to_timespan__
    serializer = Mongoid::Fields::Timespan
    object = self
    ::Timespan.new :from => serializer.from(object), :to => serializer.to(object), asap: serializer.asap(object)
  end

  def __evolve_to_duration_range__
    ::DurationRange.new Range.new(self[:from], self[:to]), :seconds
  end
end
