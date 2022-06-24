# environment_specific_config

A new Flutter project.

## Getting Started

This configuration strategy relies on the `--dart-define` command-line argument to define compile-time environment 
variables. The default values could be used for local development purposes, and CI/CD tools can override the values 
depending on the environment being deployed to.

Simply run:

```sh
flutter run  # to rely on the default 'multiplier' value, or
flutter run --dart-define=multiplier=2  # to specify the 'multiplier' value
```

More about `--dart-define` can be found [here](https://itnext.io/flutter-1-17-no-more-flavors-no-more-ios-schemas-command-argument-that-solves-everything-8b145ed4285d).

## How might we use this?

While some configuration will be dynamic during the lifetime of the app, in our case likely resolved from Firebase
Remote Config, other configuration is static and constant, and can be decided at the time of build / deployment. For
this kind of configuration, we can easily leverage `--dart-define` arguments and `String.fromEnvironment` calls to
define what the 'build-time' configuration is. This will be particularly powerful if, in our app's configuration 
library, we can just expose the latest config to client code, and hide the details of where exactly the config is
sourced from. For example, to borrow some concepts from `wooliesgo_flutter`:

```dart
class MyClass {
    final AlwaysCurrentConfig _config;

    MyClass({ required AlwaysCurrentConfig config }) : _config = config;

    void doSomething() {
        if (_config.latest.someFeatureIsEnabled) {
            _sendSomethingTo(_config.latest.someApiUrl)
        }
    }
}
```

The provider of the `someFeatureIsEnabled` property would be dynamic, and so calling `_myClass.doSomething()` would
have different results depending on whether the feature has been enabled for the current user, but anyone using the
app in the same environment would get the same value for `someApiUrl`.

Then it's a decision of how granular we want build- / deploy-time configuration to be. There's...

1. **Broad stroke:** We could just specify the intended environment, i.e. `dev`, `uat` or `prod` and our code could 
    know which urls / values that should map to. This has the advantage of not requiring changes to our CI/CD script 
    each time we have a new configurable property, but the downside of the code needing to know about configuration it 
    shouldn't use in a given environment - it also cannot handle the case where we may need to keep keys / secrets out 
    of our source control, so we'd still need to provide sensitive data like this as `--dart-define` arguments.

1. **Fine control:** We could specify each configurable property, while still allowing us to fall back to sensible 
    defaults. The notion of which environment we're targeting is then completely removed from our application code and 
    is decided on by our CI/CD scripts. The pros of this is that with everything granularly configurable, we're able to 
    support specific use cases, such as overriding a timer duration to a length more reasonable for testing without 
    needing scripts to manage Firebase Remote Config, or integration tests being configured to run against a local 
    development server for stubbing out API calls.
