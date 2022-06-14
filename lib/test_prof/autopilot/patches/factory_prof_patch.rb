# frozen_string_literal: true

module TestProf
  using(Module.new do
    refine FactoryProf::Result do
      def to_json
        {
          stacks: stacks,
          raw_stats: raw_stats
        }.to_json
      end
    end
  end)

  module Autopilot
    module Patches
      # Monkey-patch for 'TestProf::FactoryProf::Printers::Simple'.
      # Redefined 'report' method provides writing artifact to the directory
      # instead of printing report
      module FactoryProfPatch
        ARTIFACT_FILE = "factory_prof_report.json"

        module PrinterExt
          def dump(result, **)
            dir_path = FileUtils.mkdir_p(Autopilot.config.tmp_dir)[0]
            file_path = File.join(dir_path, ARTIFACT_FILE)

            File.write(file_path, result.to_json)
          end
        end

        def patch
          TestProf::FactoryProf::Printers::Simple.singleton_class.prepend(PrinterExt)
          TestProf::FactoryProf::Printers::Flamegraph.singleton_class.prepend(PrinterExt)
        end

        module_function :patch
      end
    end
  end
end

TestProf::Autopilot::Patches::FactoryProfPatch.patch
