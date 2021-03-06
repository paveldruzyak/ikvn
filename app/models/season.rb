class Season < ActiveRecord::Base	
	
  has_many :rounds, :order => "id DESC", :dependent => :destroy
  
  validates_presence_of :name, :rounds_count, :questions_count
  validates_length_of :name,  :maximum => 100, :unless => Proc.new { |name| name.nil? }
  validates_numericality_of :rounds_count, :questions_count, :only_integer => true, 
                            :greater_than => 0, :less_than_or_equal_to => 30, 
                            :unless => Proc.new { |count| count.nil? }

  def published?
    !rounds.published.empty?                              	
  end 
  
  def self.current
    Season.last :order => "id", :joins => :rounds, :conditions => { 'rounds.published' => true }    
  end                           
                                  
protected

def before_create
  self.rounds_count.times do |round_index|
    @round = rounds.build({:name => round_index + 1,
                          :published => false,
                          :start_responses_at => Time.now + (21 * round_index).day,
                          :end_responses_at => Time.now + (14 + (round_index * 21)).day,
                          :start_assess_at => Time.now + (14 + (round_index * 21)).day, 
                          :end_assess_at => Time.now + (21 + (round_index * 21)).day})
    self.questions_count.times do |question_index|
      @round.questions.build({:name => question_index + 1})
    end
  end
  end
  
end
