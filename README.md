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
