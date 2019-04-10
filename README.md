# ZKPageViewController
A PageViewController with a custom title view

## Requirements
* Xcode 10.2+
* Swift 5.0+
* iOS Deployment Target 9.0+

## Installation

### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects. You can install it with the following command:

```bash
$ gem install cocoapods
```
To integrate ZKPageViewController into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
platform :ios, '9.0'
use_frameworks!
target 'YourApp' do
    pod 'ZKPageViewController'
end
```

Then, run the following command:

```ç
$ pod install
```

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate ZKPageViewController into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "superk589/ZKPageViewController"
```

Run `carthage update` to build the framework and drag the built `ZKPageViewController.framework` into your Xcode project.

### Manually

If you prefer not to use either of the aforementioned dependency managers, you can integrate ZKPageViewController into your project manually.
