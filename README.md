# environment_specific_config

A new Flutter project.

## Getting Started

This variation relies on the `--dart-define` command-line argument to define compile-time environment variables. The
default values could be used for local development purposes, and CI/CD tools can override the values depending on the
environment being deployed to.

Simply run:

```sh
flutter run  # to rely on the default 'multiplier' value, or
flutter run --dart-define=multiplier=2  # to specify the 'multiplier' value
```

More about `--dart-define` can be found [here](https://itnext.io/flutter-1-17-no-more-flavors-no-more-ios-schemas-command-argument-that-solves-everything-8b145ed4285d).
