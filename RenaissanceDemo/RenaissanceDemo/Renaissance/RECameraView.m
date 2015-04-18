//
//  RECameraView.m
//  RenaissanceDemo
//
//  Created by Tony on 3/16/15.
//  Copyright (c) 2015 tony. All rights reserved.
//

#import "RECameraView.h"

#import "REGridView.h"
#import "RECameraController.h"

#import "RECategories.h"
#import <AssetsLibrary/AssetsLibrary.h>

#import "RELibraryManager.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)

#define VideoTriggerImage [UIImage imageNamed:@"re_camera_shot"]
#define VideoTriggerStopImage [UIImage imageNamed:@"video_stop"]
#define PhotoTriggerImage [UIImage imageNamed:@"re_camera_shot"]

#define FlashModeOffImage [UIImage imageNamed:@"re_camera_flash_stop"]
#define FlashModeOnImage [UIImage imageNamed:@"re_camera_flash_force"]
#define FlashModeAutoImage [UIImage imageNamed:@"re_camera_flash_auto"]

#define ThemeColor [UIColor colorWithRed:223/255.0f green:76/255.0f  blue:60/255.0f alpha:1.0f]

@interface RECameraView ()

@property (nonatomic, strong) UIView *previewView;

@property (nonatomic, strong) UIView *topContainerBar;
@property (nonatomic, strong) UIView *middleContainerBar;
@property (nonatomic, strong) UIView *bottomContainerBar;
@property (nonatomic, strong) UIView *switchingView;
@property (nonatomic, strong) REGridView *gridView;

@end

@implementation RECameraView

- (void)_setupElements {
    [self _initLayouts];
    [self _initPreview];
    [self _initSwitchingView];
    [self addSubview:self.gridView];
}

- (void)_initLayouts {
    if (!_topContainerBar) {
        //
        _topContainerBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 52)];
        [_topContainerBar setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_topContainerBar];
        
        [_topContainerBar addSubview:self.closeButton];
        
        if (IS_IPHONE_4_OR_LESS) {
            [_topContainerBar addSubview:self.gridButton];
            [_topContainerBar addSubview:self.cameraSwitcherButton];
            [_topContainerBar addSubview:self.flashButton];
        }
    }
    
    if (!_middleContainerBar && !IS_IPHONE_4_OR_LESS) {
        //
        CGFloat middleContainerBarY = _topContainerBar.frame.size.height + SCREEN_WIDTH;
        _middleContainerBar = [[UIView alloc] initWithFrame:CGRectMake(0, middleContainerBarY, SCREEN_WIDTH, 80)];
        [_middleContainerBar setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_middleContainerBar];
        
        [_middleContainerBar addSubview:self.gridButton];
        [_middleContainerBar addSubview:self.cameraSwitcherButton];
        [_middleContainerBar addSubview:self.flashButton];
    }
    
    if (!_bottomContainerBar) {
        
        CGFloat bottomContainerBarY;
        if (_middleContainerBar) {
            bottomContainerBarY = _topContainerBar.frame.size.height + _middleContainerBar.frame.size.height + SCREEN_WIDTH;
        } else {
            bottomContainerBarY = _topContainerBar.frame.size.height + SCREEN_WIDTH;
        }
        
        _bottomContainerBar = [[UIView alloc] initWithFrame:CGRectMake(0, bottomContainerBarY, SCREEN_WIDTH, self.frame.size.height - bottomContainerBarY)];
        [_bottomContainerBar setBackgroundColor:[UIColor blackColor]];
        [self addSubview:_bottomContainerBar];
        
        _photoTrigger = [UIButton buttonWithType:UIButtonTypeCustom];
        _photoTrigger.frame = CGRectMake(0, 0, 171 / 2.0f, 171 / 2.0f);
        _photoTrigger.center = CGPointMake(_bottomContainerBar.frame.size.width / 2.0f, _bottomContainerBar.frame.size.height / 2.0f);
        [_photoTrigger setImage:PhotoTriggerImage forState:UIControlStateNormal];
        [_photoTrigger setBackgroundColor:[UIColor blackColor]];
        [_bottomContainerBar addSubview:_photoTrigger];
        
        [_bottomContainerBar addSubview:self.libraryButton];
    }
}

- (void)_initPreview {
    if (!_previewView) {
        _previewView = [[UIView alloc] initWithFrame:CGRectMake(0, _topContainerBar.frame.size.height, SCREEN_WIDTH, SCREEN_WIDTH)];
        _previewView.backgroundColor = [UIColor blackColor];
        CGRect previewFrame = CGRectMake(0, _topContainerBar.frame.size.height, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame));
        _previewView.frame = previewFrame;
        
        AVCaptureVideoPreviewLayer *previewLayer = [[PBJVision sharedInstance] previewLayer];
        previewLayer.frame = _previewView.bounds;
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        [_previewView.layer addSublayer:previewLayer];
        
        [self addSubview:_previewView];
    }
}

- (void)_initSwitchingView {
    if (!_switchingView) {
        _switchingView = [[UIView alloc] initWithFrame:CGRectMake(0, _topContainerBar.frame.size.height, SCREEN_WIDTH, SCREEN_WIDTH)];
        _switchingView.backgroundColor = [UIColor blackColor];
        [self addSubview:_switchingView];
        [self bringSubviewToFront:_switchingView];
    }
}

- (REGridView *)gridView {
    if (!_gridView) {
        _gridView = [[REGridView alloc] initWithFrame:_previewView.frame];
        _gridView.hidden = YES;
    }
    return _gridView;
}

- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.frame = CGRectMake(0, 0, _topContainerBar.frame.size.height, _topContainerBar.frame.size.height);
        [_closeButton setImage:[UIImage imageNamed:@"re_topbar_no"] forState:UIControlStateNormal];
        _closeButton.center = CGPointMake(32, _topContainerBar.frame.size.height / 2);
    }
    return _closeButton;
}

- (UIButton *)libraryButton {
    if (!_libraryButton) {
        _libraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _libraryButton.backgroundColor = [UIColor whiteColor];
        _libraryButton.frame = CGRectMake(0, 0, 32.0f, 32.0f);
        _libraryButton.center = CGPointMake(_bottomContainerBar.frame.size.width / 2.0f - 170 / 2.0f - 20.0f, _bottomContainerBar.frame.size.height / 2.0f);
        [_libraryButton.layer setCornerRadius:4];
        
        if ([ALAssetsLibrary authorizationStatus] !=  ALAuthorizationStatusDenied) {
            __weak typeof(self) weakSelf = self;
            [[RELibraryManager sharedInstance] loadLastItemWithBlock:^(BOOL success, UIImage *image) {
                [weakSelf.libraryButton setBackgroundImage:image forState:UIControlStateNormal];
            }];
        }
    }
    return _libraryButton;
}

- (UIButton *)gridButton {
    if (!_gridButton) {
        _gridButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _gridButton.frame = CGRectMake(0, 0, 65 / 2.0f, 65 / 2.0f);
        
        if (_middleContainerBar) {
            _gridButton.center = CGPointMake(SCREEN_WIDTH / 2.0f, _middleContainerBar.frame.size.height / 2);
        } else {
            _gridButton.center = CGPointMake(SCREEN_WIDTH / 2.0f, _topContainerBar.frame.size.height / 2);
        }
        
        [_gridButton setImage:[[UIImage imageNamed:@"re_camera_grid"] tintImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_gridButton setImage:[[UIImage imageNamed:@"re_camera_grid"] tintImageWithColor:ThemeColor] forState:UIControlStateSelected];
    }
    return _gridButton;
}

- (UIButton *)cameraSwitcherButton {
    if (!_cameraSwitcherButton) {
        _cameraSwitcherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cameraSwitcherButton setBackgroundColor:[UIColor clearColor]];
        [_cameraSwitcherButton setImage:[[UIImage imageNamed:@"re_camera_switch"] tintImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_cameraSwitcherButton setImage:[[UIImage imageNamed:@"re_camera_switch"] tintImageWithColor:ThemeColor] forState:UIControlStateSelected];
        [_cameraSwitcherButton setFrame:CGRectMake(0, 0, 65 / 2.0f, 65 / 2.0f)];
        
        if (_middleContainerBar) {
            [_cameraSwitcherButton setCenter:CGPointMake(SCREEN_WIDTH / 2.0f - 116 / 2.0f - 65 / 2.0f, _middleContainerBar.frame.size.height / 2)];
        } else {
            [_cameraSwitcherButton setCenter:CGPointMake(SCREEN_WIDTH / 2.0f - 116 / 2.0f - 65 / 2.0f, _topContainerBar.frame.size.height / 2)];
        }
    }
    return _cameraSwitcherButton;
}

- (UIButton *)flashButton {
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_flashButton setBackgroundColor:[UIColor clearColor]];
        [_flashButton setImage:[FlashModeOffImage tintImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_flashButton setFrame:CGRectMake(0, 0, 32, 32)];
        
        if (_middleContainerBar) {
            [_flashButton setCenter:CGPointMake(SCREEN_WIDTH / 2 + 116 / 2.0f + 65 / 2.0f, _middleContainerBar.frame.size.height / 2)];
        } else {
            [_flashButton setCenter:CGPointMake(SCREEN_WIDTH / 2 + 116 / 2.0f + 65 / 2.0f, _topContainerBar.frame.size.height / 2)];
        }
    }
    return _flashButton;
}

//-----------------------

- (void)_switching:(CGFloat)height {
    CGRect switchingViewFrame = CGRectMake(0, _switchingView.frame.origin.y, SCREEN_WIDTH, height);
    _switchingView.frame = switchingViewFrame;
}

- (void)_changeCameraSwitchButtonState {
    _cameraSwitcherButton.selected = !_cameraSwitcherButton.selected;
}

- (void)_changeFlashButtonState:(PBJFlashMode)mode {
    switch (mode) {
        case PBJFlashModeOff: {
            [_flashButton setImage:[FlashModeOnImage tintImageWithColor:ThemeColor] forState:UIControlStateNormal];
            break;
        }
        case PBJFlashModeOn:
            [_flashButton setImage:[FlashModeAutoImage tintImageWithColor:ThemeColor] forState:UIControlStateNormal];
            break;
        case PBJFlashModeAuto: {
            [_flashButton setImage:[FlashModeOffImage tintImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}

- (void)_changeGridState {
    _gridButton.selected = !_gridButton.selected;
    _gridView.hidden = !_gridView.hidden;
    
}

@end
