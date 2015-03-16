//
//  UIButton+Block.h
//  RenaissanceDemo
//
//  Created by Tony on 3/3/15.
//  Copyright (c) 2015 tony. All rights reserved.
//

#define kUIButtonBlockTouchUpInside @"TouchInside"

#import <UIKit/UIKit.h>

@interface UIButton (Block)

@property (nonatomic, strong) NSMutableDictionary *actions;

- (void) setAction:(NSString*)action withBlock:(void(^)())block;

@end
