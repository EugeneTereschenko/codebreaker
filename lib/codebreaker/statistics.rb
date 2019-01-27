module Codebreaker
  class Statistics
    def initialize
      @storage = StorageInterceptor.new
    end

    def stats
      return unless codebreaker_data = @storage.read_database

      codebreaker_data.sort_by! { |stat| [stat[:level_num], stat[:hints], stat[:attempts]] }
      codebreaker_data.each { |stat| stat.delete_if { |key, _value| key == :level_num } }
    end
  end
end
