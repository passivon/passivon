require "rspec"
load File.expand_path("../broadcast-daily", __dir__)

RSpec.describe "broadcast-daily" do
  describe "in_the_right_moment?" do
    it "returns correctly" do
      player = MasterPlayer.new
      allow(Time).to receive(:now).and_return(double(hour: 6, min: 15))
      expect(player.in_the_right_moment?).to be_falsey
      allow(Time).to receive(:now).and_return(double(hour: 6, min: 45))
      expect(player.in_the_right_moment?).to be_truthy
      allow(Time).to receive(:now).and_return(double(hour: 7, min: 15))
      expect(player.in_the_right_moment?).to be_truthy
      allow(Time).to receive(:now).and_return(double(hour: 7, min: 45))
      expect(player.in_the_right_moment?).to be_falsey
    end
  end

  describe "reload management" do
    it "works correctly" do
      now = Time.now
      player1 = MasterPlayer.new
      allow(Time).to receive(:now).and_return(now + 100)
      killer = MasterPlayer.new
      allow(Time).to receive(:now).and_return(now + 200)
      player2 = MasterPlayer.new

      killer.kill_all
      expect(player1.should_I_die?).to be_truthy
      expect(player2.should_I_die?).to be_falsey

      FileUtils.rm_rf(killer.should_die_at_signal_filename)
    end
  end

  describe "AutoUpdater" do
    it "runs" do
      begin
        Timeout.timeout(3) do
          AutoUpdater.new.perform_in_loop
        end
      rescue Timeout::Error
        # it's ok to got timeout error
      end
    end
  end
end
