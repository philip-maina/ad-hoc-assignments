# SLCSP

## Summary

This assignment solves the second lowest cost silver plan (SLCSP) for
a group of ZIP codes. Check [challenge description](CHALLENGE.md) for details.


## Requirements

Development/Runtime Environment:
```
ruby >= 2.5
```


## Setup

```
$ git clone https://github.com/philip-maina/ad-hoc-assignments.git
$ cd ad-hoc-assignments/slcsp
$ bundle install
```

## Usage (How to run?)

```
$ chmod 755 ./exe/slcsp
$ ./exe/slcsp
```

## Implementation Overview

The solution was achieved by introducing three domain entities:
  1. `SLCSP::Zip`: Loads all zipcode records from file storing only relevant fields (`zipcode`, `state`, `rate_areas`).
  2. `SLCSP::Plan`: Loads all plan records from file storing only relevant fields (`id`, `metal_level`, `rate`, `state`, `rate_area`).
  3. `SLCSP::Calculator`: Calculates second level silver plan rates for zipcodes by leaning on both `SLCSP::Zip` and `SLCSP::Plan`.  


## Testing

1. Added `test/calculator_test.rb` unit test.
2. Manual exploratory testing (viewing file & STDOUT outputs).


To run tests:
```
$ bundle exec rake test
```

## Trade-offs (Given more time I would have ...)

1. Added `test/plan_test.rb`, `test/zip_test.rb` unit tests.
2. Filtered `zips.csv` and `plans.csv` to have fewer relevant rows using `awk` scripting. This would help in performance when dealing with large files.
3. Added better, informative logging/reporting e.g report no of zip/plan records loaded, report no of ambiguous zipcodes.
4. Published this solution as a gem.
5. Added RDoc documentation.
6. Added linting.
7. Considered using DB and solved the challenge by writing a neat SQL query?

