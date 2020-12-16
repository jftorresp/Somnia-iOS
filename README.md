# Somnia 😴
> Somnia is an app that helps you in the process of sleeping and waking up and provides a complete and personalized sleep cycle.

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/EZSwiftExtensions.svg)](https://img.shields.io/cocoapods/v/LFAlertController.svg)  
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

![](header.png)

## Features

- [x] Personalized alarms
- [x] Suggested bedtime and wake up hour
- [x] Sleep cycle analysis
- [x] Dreamlog and different sleep activities
- [x] Wake up games
- [x] And more ...

## Requirements

- iOS 13.0+
- Xcode 12.1

## Installation

The first thing to do is cloning the project. You have to copy the HTTPS url of the repository in the Clone button. Then in your terminal type:

 ```
 git clone https://gitlab.com/isis3510_202020_team1/ios.git 
 ```

In the location on your device where you want to save the project. Then using the command `cd /yourPath` you acces the route where you cloned the repository. 

#### CocoaPods

You have to add Pods to your project by creating a Podfile with the command `pod init` in terminal. You can use [CocoaPods](http://cocoapods.org/) to install all the different dependencies of the app by adding it to your `Podfile`:

```
platform :ios, '9.0'
use_frameworks!
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'FBSDKLoginKit'
  pod 'IQKeyboardManagerSwift'
  pod 'Firebase/Storage'

```

Then run `pod install` to add all the libraries to your Xcode project. Then you have to open the app following the xcworkspace file.

#### Build & Run
1. After installing the pods, open Xcode and hit `command B` to Build the app.
2. Select a device in the emulator on the top-left corner of Xcode (preferably iPhone 11) or connect your iOS device to install the app on it.
3. Then hit `command R`or the 'play' button to run the app.
4. Congratulations your app is running!

## Contribute

We would love you for the contribution to **Somnia App**, check the ``LICENSE`` file for more info.

## Meta

Juan Felipe Torres – [github](https://github.com/jftorresp?) – jf.torresp@uniandes.edu.co

Nicolás Cobos - [github](https://github.com/ncobos?) – n.cobos@uniandes.edu.co

Distributed under the MIT license. See ``LICENSE`` for more information.


[swift-image]:https://img.shields.io/badge/swift-5.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
