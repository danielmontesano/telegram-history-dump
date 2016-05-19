require 'json'

class DumpProgress

  attr_reader :newest_id
  attr_reader :newest_date
  attr_reader :dumper_state
  attr_writer :dumper_state

  def initialize(newest_id = nil, newest_date = nil, dumper_state = {})
    @newest_id = newest_id
    @newest_date = newest_date
    @dumper_state = dumper_state
  end

  def self.from_hash(hash)
    self.new(
      hash['newest_id'],
      hash['newest_date'] || hash['last_date'], # last_date is v2.0.x compat
      hash['dumper_state']
    )
  end

  def to_hash
    {
      :newest_id => @newest_id,
      :newest_date => @newest_date,
      :dumper_state => @dumper_state
    }
  end

  def to_json(*a)
    to_hash.to_json(*a)
  end

  def update(msg)
    if !@newest_date || (msg['date'] && msg['date'] >= @newest_date)
      @newest_date = msg['date'] || @newest_date
      @newest_id = (msg['id'] || @newest_id).to_s
    end
  end

end
