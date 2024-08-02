[![Gem Version](https://badge.fury.io/rb/test-prof-autopilot.svg)](https://rubygems.org/gems/test-prof-autopilot)
[![Build](https://github.com/test-prof/test-prof-autopilot/workflows/Build/badge.svg)](https://github.com/test-prof/test-prof-autopilot/actions)

# TestProf Autopilot

[TestProf][] has been used by many Ruby/Rails teams to optimize their test suites performance for a while.

Usually, it takes a decent amount of time to profile the test suite initially: we need run many profilers multiple times, tune configuration and sampling parameters. And we repeat this over and over again.

There are some common patterns in the way we use TestProf, for example: we run StackProf/RubyProf multiple times for different test samples, or we run EventProf for `factory.create` and then use FactoryProf for the slowest tests.

It seems that there is a room for optimization here: we can automate this common tasks, make robots do all the repetition. And here comes **TestProf Autopilot**!

## Usage

First, write a test profiling plan in a Ruby file. For example, here is how you can perform StackProf profiling multiple times against different random subsets and aggregate the results:

```ruby
# This plan runs multiple test samples and collects StackProf data.
# The data is aggregated and the top-5 popular methods are displayed in the end.
#
# With the help of this plan, you can detect such problems as unnecessary logging/instrumentation in tests,
# inproper encryption settings, etc.
#
# NOTE: `aggregate` takes a block, runs it the specified number of times and merge the reports (i.e., agg_result = prev_result.merge(curr_result))
aggregate(3) { run :stackprof, sample: 100 }

# `report` returns the latest generated report (both `run` and `aggregate` set this value automatically)
# `#methods` returns the list of collected reports sorted by their popularity
puts report.methods.take(5)
```

Now, you can use the `auto-test-prof` command to execute the plan:

```sh
auto-test-prof -i plan.rb -с "bundle exec rspec"
```

We specify the base command to run tests via the `-c` option. If you omit the command option, Autopilot would fall back to either `bundle exec rspec` or `bundle exec rake test` depending on the presense of the `spec/` and `test/` directories, respectively.

### Merging results

Autopilot also allows you to merge reports created with it (using the `#save` method). That's useful when you profile tests on CI and want to see the aggregated results. For example, when using TagProf:

```ruby
run :tag_prof, events: ["factory.create"]

save report, file_name: "tag_prof_#{ENV["CI_NODE_INDEX"]}"
```

Then, assuming all reports were downloaded:

```sh
$ auto-test-prof --merge tag_prof --reports tag_prof_*.json

Merging tag_prof reports at tag_prof_1.json, tag_prof_2.json, tag_prof_3.json

[TEST PROF] TagProf report for type

       type          time   factory.create    total  %total   %time           avg

      model     28:08.654        19:58.371     1730   56.44   46.23     00:00.976
    service     20:56.071        16:14.435      808   29.18   28.35     00:01.554
        api     04:48.179        03:54.178      214    7.32    4.78     00:01.346
        ...
```

### API

- `run(profiler_name, **options)`: launch the test command with the specified profiler activated; options depend on the profiler, but there are some commont: `sample: <number>` — enables sampling, `paths: <array of paths>` — adds the list of paths to the command.

- `info(report)`: shows the report in the console

- `save(report, path)`: store

- `aggregate(num_calls) { ... }`: aggregates reports obtained by calling the block `num_calls` times.

You can find more examples in the [examples/](examples/) folder.

### Supported profilers

Currently, Autopilot supports the following Test Prof profilers:

- [EventProf](https://test-prof.evilmartians.io/profilers/event_prof) (as `:event_prof`)
- [TagProf](https://test-prof.evilmartians.io/profilers/tag_prof) (as `:tag_prof`)
- [StackProf](https://test-prof.evilmartians.io/profilers/stack_prof) (as `:stack_prof`)
- [FactoryProf](https://test-prof.evilmartians.io/profilers/factory_prof) (as `:factory_prof`)
- [FactoryDefault profiler](https://test-prof.evilmartians.io/recipes/factory_default) (as `:factory_default_prof`)

## Installation

Add the gem to your project:

```ruby
# Gemfile
group :development, :test do
  gem "test-prof-autopilot"
end
```

Make sure `test-prof-autopilot` is required in your test environment.

That's it!

[TestProf]: https://test-prof.evilmartians.io/
