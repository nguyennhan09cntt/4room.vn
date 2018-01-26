module Utils
  SAMPLE_NUM_BEGIN = DateTime.current.beginning_of_year.to_i
  SAMPLE_NUM_END = DateTime.current.end_of_year.to_i

  def self.sample_uids(number = 1)      
      #range = [(SAMPLE_NO_BEGIN .. SAMPLE_NO_END)].map{ |i| i.to_a }.flatten
      #range.sample(number)
      return SAMPLE_NUM_BEGIN + Random.rand(SAMPLE_NUM_END - SAMPLE_NUM_BEGIN ) if number == 1
      number.times.map{ SAMPLE_NUM_BEGIN + Random.rand(SAMPLE_NUM_END - SAMPLE_NUM_BEGIN) } 
  end  

 
end
