RSpec.describe Codebreaker::Statistics do
  let(:storage) { Codebreaker::StorageInterceptor.new('./spec/codebreaker/data/stat.yml') }

  stats_array = [{ name: 'Player2',
                   level: 'easy',
                   attempts: 28,
                   attempts_used: 2,
                   hints: 2,
                   hints_used: 1,
                   game_date: '2019/01/27 20:29:39' },
                 { name: 'Player1',
                   level: 'easy',
                   attempts: 28,
                   attempts_used: 2,
                   hints: 3,
                   hints_used: 0,
                   game_date: '2019/01/27 12:55:55' },
                 { name: 'Player3',
                   level: 'hard',
                   attempts: 8,
                   attempts_used: 2,
                   hints: 0,
                   hints_used: 1,
                   game_date: '2019/01/27 20:30:07' }]

  context 'stats' do
    it 'stats' do
      subject.instance_variable_set(:@storage, storage)
      expect(subject.stats).to eql(stats_array)
    end
  end
end
