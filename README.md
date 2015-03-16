# Renaissance

## Installation

The recommended method for installating Renaissance is via the [CocoaPods](http://cocoapods.org/)

## Podfile (Can't search on CocoaPods now)
```ruby
platform :ios, '7.0'
pod 'Renaissance'
```

## How to use

### Import Renaissance

```objc
#import "RECameraController.h"
```

```
@interface ViewController () <RECameraDelegate>
```

### Delegate implentation

```objc
// Photo
- (void)camera:(RECameraController *)viewController didCapture:(UIImage *)image {
	...
}
```
```objc
// Cancel
- (void)cameraDidCancel:(RECameraController *)viewController {
	...
}
```
