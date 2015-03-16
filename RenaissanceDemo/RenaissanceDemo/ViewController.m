//
//  ViewController.m
//  RenaissanceDemo
//
//  Created by Tony on 12/5/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import "ViewController.h"
#import "RECameraController.h"

@interface ViewController () <RECameraDelegate>

@property (nonatomic, strong) UIImageView *outputImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 100, 30);
    button.center = CGPointMake(self.view.frame.size.width / 2, 50);
    button.backgroundColor = [UIColor grayColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setTitle:@"Camera" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(cameraIsUp) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    _outputImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width)];
    _outputImageView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cameraIsUp {
    RECameraController *rcc = [[RECameraController alloc] init];
    rcc.delegate = self;
    [self presentViewController:rcc animated:YES completion:nil];
}

#pragma mark - RE Delegate

- (void)camera:(RECameraController *)viewController didCapture:(UIImage *)image {
    
    _outputImageView.image = image;
    [self.view addSubview:_outputImageView];
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)cameraDidCancel:(RECameraController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


@end
