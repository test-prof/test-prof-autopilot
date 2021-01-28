# TestProf Autopilot (PoC)

[TestProf][] has been used by many Ruby/Rails teams to optimize their test suites performance for a while.

Usually, it takes a decent amount of time to profile the test suite initially: we need run many profilers multiple times, tune configuration and sampling parameters. And we repeat this over and over again.

There are some common patterns in the way we use TestProf, for example: we run StackProf/RubyProf multiple times for different test samples, or we run EventProf for `factory.create` and then use FactoryProf for the slowest tests.

It seems that there is a room for optimization here: we can automate this common tasks, make robots do all the repetition.

This project (codename _TestProf Autopilot_) aims to solve this problem.

## Usage (proposal)

Use a CLI to run a specific tests profiling plan:

```sh
auto-test-prof -i plan.rb -с "bundle exec rspec"
```

We specify the base command to run tests via the `-c` option.

Profiling plan is a Ruby file using a custom DSL to run profilers and access their reports:

Here is an example #2:

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
# `info` prints the information (ideally, it should be human-readable)
info report.methods.take(5)
```

And example #2:

```ruby
# This plan first launch the test suite and collect the information about the time spent in factories.
# Then it runs FactoryProf for the slowest tests and display the information.

run :event_prof, event: "factory.create"
run :factory_prof, paths: report.paths

info report
```

### Notes on implementation

We use `#run` method to launch tests with profiling. Each profiler has a uniq name (which is the first argument) and some options.
Some options are common for all profilers (e.g., `sample:` and `paths:`).

## Installation

Adding to a gem:

```ruby
# my-cool-gem.gemspec
Gem::Specification.new do |spec|
  # ...
  spec.add_dependency "test-prof-autopilot"
  # ...
end
```

Or adding to your project:

```ruby
# Gemfile
group :development, :test do
  gem "test-prof-autopilot"
end
```

[TestProf]: https://test-prof.evilmartians.io/
