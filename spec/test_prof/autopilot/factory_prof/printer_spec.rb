# frozen_string_literal: true

describe TestProf::Autopilot::FactoryProf::Printer do
  subject { described_class }

  let(:logging) { TestProf::Autopilot::Logging }
  let(:report) { double("report", raw_report: raw_report) }
  let(:raw_report) do
    {
      "total_count" => 40,
      "total_top_level_count" => 28,
      "total_time" => 2,
      "total_uniq_factories" => 2,
      "stats" => [
        {
          "name" => "user",
          "total_count" => 30,
          "top_level_count" => 18,
          "total_time" => 1,
          "top_level_time" => 1
        },
        {
          "name" => "application",
          "total_count" => 10,
          "top_level_count" => 10,
          "total_time" => 1,
          "top_level_time" => 1
        }
      ]
    }
  end

  let(:main_msg) do
    <<~MSG
      Factories usage
  
       Total: 40
       Total top-level: 28
       Total time: 2.0000s
       Total uniq factories: 2
  
         total   top-level     total time      time per call      top-level time               name
    MSG
  end

  let(:msgs) do
    [
      main_msg,
      "      30          18        1.0000s            0.0000s             1.0000s               user",
      "      10          10        1.0000s            0.0000s             1.0000s        application"
    ].join("\n")
  end

  describe "print_report" do
    it "logs report" do
      expect(logging).to receive(:log).with(msgs)

      subject.print_report(report)
    end

    context "when raw data includes error" do
      let(:raw_report) { {"error" => "No factories detected"} }

      it "raises error" do
        expect { subject.print_report(report) }.to raise_error(described_class::PrinterError)
      end
    end
  end
end
