
iOS不能做到禁止截屏和录屏，只能使用通知监听到截屏或录屏事件，来做一些处理，比如停止播放视频，视频加盖蒙板等。

截图通知名：
```
UIApplication.userDidTakeScreenshotNotification
```
录屏通知名：
-  录屏功能iOS11之后才有
```
UIApplication.capturedDidChangeNotification
```

图片展示：
![WechatIMG184.jpeg](https://upload-images.jianshu.io/upload_images/1846524-a493310565f94f5d.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/620)

![录屏，gif有点模糊](https://upload-images.jianshu.io/upload_images/1846524-281db11c2a87d993.gif?imageMogr2/auto-orient/strip)


[官方文档](https://developer.apple.com/documentation/uikit/uiscreen/2921652-captureddidchangenotification)
