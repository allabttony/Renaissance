//
//  RECameraController.h
//
//  Created by Tony on 12/5/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RECameraDelegate;

@interface RECameraController : UIViewController

@property (nonatomic, strong) id<RECameraDelegate> delegate;

@end

@protocol RECameraDelegate <NSObject>
@optional
- (void)camera:(RECameraController *)viewController didCapture:(UIImage *)image;
- (void)cameraDidCancel:(RECameraController *)viewController;

- (void)camera:(RECameraController *)viewController didRecord:(NSURL *)path;

@end
