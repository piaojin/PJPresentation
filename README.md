> # PJPresentation
`Swift`,  `AutoLayout`, `iOS`

## Installation

[CocoaPods](http://cocoapods.org) is a dependency manager for Objective-C / Swift, which automates and simplifies the process of using 3rd-party libraries like AFNetworking, PJPresentation in your projects. You can install it with the following command:

```bash
$ gem install cocoapods
```

> CocoaPods 0.39.0+ is required to build PJPresentation.

#### Podfile

To integrate PJPresentation into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'

target 'TargetName' do
pod 'PJPresentation'
end
```

Then, run the following command:

```bash
$ pod install
```

## How to use

```swift
let contentView = UIView()
contentView.backgroundColor = .orange
PJPresentationControllerManager.presentView(contentView: contentView, presentationViewControllerHeight: 200.0)
```

![image](https://github.com/piaojin/PJPresentation/blob/master/ExampleVideos/0.gif)

Use the `PJPresentationOptions` struct to configure the desired effect, such as popup or dismiss direction, size, custom animation effects, etc. 

```swift
var options = PJPresentationOptions()
options.dismissDirection = .topToBottom
options.presentationPosition = .center
options.presentationDirection = .topToBottom
PJPresentationControllerManager.presentView(contentView: contentView, presentationViewControllerHeight: 200, presentationOptions: options)
```

![image](https://github.com/piaojin/PJPresentation/blob/master/ExampleVideos/1.gif)

![image](https://github.com/piaojin/PJPresentation/blob/master/ExampleVideos/2.gif)

![image](https://github.com/piaojin/PJPresentation/blob/master/ExampleVideos/3.gif)

## How to find
```
pod search PJPresentation
```

## Q&A
Contact me (804488815@qq.com) if you have any questions or suggestions.

## License

PJPresentation is released under the MIT license. See [LICENSE](https://github.com/piaojin/PJPresentation/blob/master/LICENSE) for details.


