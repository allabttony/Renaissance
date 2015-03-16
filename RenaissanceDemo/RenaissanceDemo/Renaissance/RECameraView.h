//
//  RECameraView.h
//  RenaissanceDemo
//
//  Created by Tony on 3/16/15.
//  Copyright (c) 2015 tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PBJVision.h>

@interface RECameraView : UIView

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UIButton *libraryButton;
@property (nonatomic, strong) UIButton *gridButton;
@property (nonatomic, strong) UIButton *cameraSwitcherButton;
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UIButton *photoTrigger;

- (void)_switching:(CGFloat)height;
- (void)_changeCameraSwitchButtonState;
- (void)_changeFlashButtonState:(PBJFlashMode)mode;
- (void)_changeGridState;

- (void)_setupElements;

@end
