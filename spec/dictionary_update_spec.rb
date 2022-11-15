require "rspec"
$TESTING = true
load File.expand_path("../generators/dictionary-update", __dir__)

RSpec.describe "dictionary-update" do
  describe "remove_explanation" do
    it "returns correctly" do
      generator = ExampleGenerator.new("word")
      expect(generator.remove_explanation(" I'll be coming back (= I plan to come back) on Tuesday."))
        .to eq("I'll be coming back  on Tuesday.")
      expect(generator.remove_explanation(" [ L ] Please be patient."))
        .to eq("Please be patient.")
    end
  end
end
