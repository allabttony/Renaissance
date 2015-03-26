//
//  RECameraController.m
//
//  Created by Tony on 12/5/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import "RECameraController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <GLKit/GLKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import "UIButton+Block.h"

// PBJVision
#import <PBJVision/PBJVision.h>

#import "UIImage+Resize.h"

#import "RECameraView.h"

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

#define VideoTriggerImage [UIImage imageNamed:@"video_trigger"]
#define VideoTriggerStopImage [UIImage imageNamed:@"video_stop"]
#define PhotoTriggerImage [UIImage imageNamed:@"photo_trigger"]

@interface RECameraController () <PBJVisionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) PBJVision *vision;

@property (nonatomic, strong) RECameraView *cameraView;

@end

@implementation RECameraController

- (instancetype)init {
    self = [super init];
    if (self) {
        
        self.assetLibrary = [[ALAssetsLibrary alloc] init];
        
        self.cameraView = [[RECameraView alloc] initWithFrame:self.view.frame];
        [self.cameraView _setupElements];
        [self _handleActions];
        [self.view addSubview:self.cameraView];
    }
    return self;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self settingPhotoMode];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[PBJVision sharedInstance] startPreview];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIView animateWithDuration:0.2 animations:^{
        [_cameraView _switching:0];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [UIView animateWithDuration:0.2 animations:^{
        [_cameraView _switching:SCREEN_WIDTH];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[PBJVision sharedInstance] stopPreview];
    [self resetPhotoMode];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    NSLog(@"Renaissance dealloc");
}

- (void)_handleActions {
    __weak typeof(self) weakSelf = self;
    [_cameraView.photoTrigger setAction:kUIButtonBlockTouchUpInside withBlock:^{
        [weakSelf.vision capturePhoto];
        [UIView animateWithDuration:0.2 animations:^{
            [weakSelf.cameraView _switching:SCREEN_WIDTH];
        } completion:nil];
    }];
    
    [_cameraView.closeButton setAction:kUIButtonBlockTouchUpInside withBlock:^(){
        [weakSelf.delegate cameraDidCancel:weakSelf];
    }];
    
    [_cameraView.libraryButton setAction:kUIButtonBlockTouchUpInside withBlock:^{
        UIImagePickerController *pc = [[UIImagePickerController alloc] init];
        pc.delegate = weakSelf;
        pc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        NSString *requiredMediaType = ( NSString *)kUTTypeImage;
        pc.mediaTypes = [NSArray arrayWithObjects:requiredMediaType, nil];
        pc.allowsEditing = YES;
        [weakSelf presentViewController:pc animated:YES completion:^{
            [weakSelf.vision stopPreview];
        }];
    }];
    
    [_cameraView.gridButton setAction:kUIButtonBlockTouchUpInside withBlock:^{
        [weakSelf.cameraView _changeGridState];
    }];
    
    [_cameraView.cameraSwitcherButton setAction:kUIButtonBlockTouchUpInside withBlock:^{
        [weakSelf.cameraView _changeCameraSwitchButtonState];
        
        switch (weakSelf.vision.cameraDevice) {
            case UIImagePickerControllerCameraDeviceRear:
                weakSelf.vision.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                break;
            case UIImagePickerControllerCameraDeviceFront:
                weakSelf.vision.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                break;
            default:
                break;
        }
    }];
    
    [_cameraView.flashButton setAction:kUIButtonBlockTouchUpInside withBlock:^{
        switch (weakSelf.vision.flashMode) {
            case AVCaptureFlashModeOff: {
                weakSelf.vision.flashMode = AVCaptureFlashModeOn;
                break;
            }
            case AVCaptureFlashModeOn:
                weakSelf.vision.flashMode = AVCaptureFlashModeAuto;
                break;
            case AVCaptureFlashModeAuto: {
                weakSelf.vision.flashMode = AVCaptureFlashModeOff;
                break;
            }
            default:
                break;
        }
        [weakSelf.cameraView _changeFlashButtonState:weakSelf.vision.flashMode];
    }];
    
}

#pragma mark - init

- (void)settingPhotoMode {
    _vision = [PBJVision sharedInstance];
    _vision.delegate = self;
    _vision.cameraMode = PBJCameraModePhoto;
    _vision.cameraOrientation = PBJCameraOrientationPortrait;
    _vision.focusMode = PBJFocusModeContinuousAutoFocus;
    _vision.outputFormat = PBJOutputFormatSquare;
    _vision.videoRenderingEnabled = YES;
    _vision.flashMode = AVCaptureFlashModeOff;
    _vision.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    _vision.additionalCompressionProperties = @{AVVideoProfileLevelKey : AVVideoProfileLevelH264Baseline30};
}

- (void)resetPhotoMode {
    _vision.flashMode = AVCaptureFlashModeOff;
    _vision.cameraDevice = UIImagePickerControllerCameraDeviceRear;
}

#pragma mark - Picker Controller Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];

    [picker dismissViewControllerAnimated:NO completion:nil];
    [_delegate camera:self didCapture:[self convertOriginalImage2CustomImage:pickedImage]];
}

#pragma mark - Vision photo Delegate

- (void)vision:(PBJVision *)vision capturedPhoto:(NSDictionary *)photoDict error:(NSError *)error {
    
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    UIImage *originalImage = [photoDict objectForKey:PBJVisionPhotoImageKey];
    [_delegate camera:self didCapture:[self convertOriginalImage2CustomImage:originalImage]];
}

#pragma mark - Private - photo

- (UIImage *)convertOriginalImage2CustomImage:(UIImage *)theOriginalImage {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CGSize sizeOriginal = CGSizeMake(2448, 2448);
        UIImage *scaledImageOriginal = [theOriginalImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:sizeOriginal interpolationQuality:kCGInterpolationHigh];
        CGRect cropFrameOriginal = CGRectMake((scaledImageOriginal.size.width - sizeOriginal.width) / 2, (scaledImageOriginal.size.height - sizeOriginal.height) / 2, sizeOriginal.width, sizeOriginal.height);
        UIImage *croppedImageOriginal = [scaledImageOriginal croppedImage:cropFrameOriginal];
        UIImageWriteToSavedPhotosAlbum(croppedImageOriginal , nil, nil, nil);
    });
    
    CGSize size = CGSizeMake(1080, 1080);
    UIImage *scaledImage = [theOriginalImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationHigh];
    CGRect cropFrame = CGRectMake((scaledImage.size.width - size.width) / 2, (scaledImage.size.height - size.height) / 2, size.width, size.height);
    UIImage *croppedImage = [scaledImage croppedImage:cropFrame];
    
    return croppedImage;
}


@end
