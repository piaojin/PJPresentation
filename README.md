# PJPresentation
> ### How to use

```
let contentView = UIView()
contentView.backgroundColor = .orange
PJPresentationManager.presentView(contentView: contentView, presentationViewControllerHeight: 200.0)
```

![image](https://github.com/piaojin/PJPresentation/blob/master/ExampleVideos/0.gif)

Use the `PJPresentationOptions` struct to configure the desired effect, such as popup or dismiss direction, size, custom animation effects, etc. 

```
var options = PJPresentationOptions()
options.dismissDirection = .topToBottom
options.presentationPosition = .center
options.presentationDirection = .topToBottom
PJPresentationManager.presentView(contentView: contentView, presentationViewControllerHeight: 200, presentationOptions: options)
```

![image](https://github.com/piaojin/PJPresentation/blob/master/ExampleVideos/1.gif)

![image](https://github.com/piaojin/PJPresentation/blob/master/ExampleVideos/2.gif)

![image](https://github.com/piaojin/PJPresentation/blob/master/ExampleVideos/3.gif)

> ### How to find
```
pod search PJPresentation
```


