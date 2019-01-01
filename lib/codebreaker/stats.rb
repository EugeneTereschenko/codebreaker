module Codebreaker
  class Stats
    def stats
      di = StorageInterceptor.new
      codebreaker_data = di.read_database

      return unless codebreaker_data

      codebreaker_data.sort_by! { |stat| [stat[:level_num], stat[:hints], stat[:attempts]] }
      codebreaker_data.each { |stat| stat.delete_if { |key, _value| key == :level_num } }
    end
  end
end
