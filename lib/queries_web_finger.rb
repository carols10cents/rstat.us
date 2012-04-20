require_relative "finger_data"

class QueriesWebFinger
  def self.query(email)
    # XXX: ensure caching of finger lookup.
    puts "EMAIL = #{email}"
    begin
      xrd = Redfinger.finger(email)
    rescue Exception => e
      puts "e.inspect = #{e.inspect}"
      puts "e.backtrace = #{e.backtrace.join("\n")}"
    end
    FingerData.new(xrd)
  end
end
