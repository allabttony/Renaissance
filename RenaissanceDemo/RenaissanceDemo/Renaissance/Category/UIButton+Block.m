//
//  UIButton+Block.m
//  RenaissanceDemo
//
//  Created by Tony on 3/3/15.
//  Copyright (c) 2015 tony. All rights reserved.
//

#import "UIButton+Block.h"

#import <objc/runtime.h>

@implementation UIButton (Block)

static char overviewKey;

@dynamic actions;

- (void) setAction:(NSString*)action withBlock:(void(^)())block {
    
    if ([self actions] == nil) {
        [self setActions:[[NSMutableDictionary alloc] init]];
    }
    
    [[self actions] setObject:block forKey:action];
    
    if ([kUIButtonBlockTouchUpInside isEqualToString:action]) {
        [self addTarget:self action:@selector(doTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setActions:(NSMutableDictionary*)actions {
    objc_setAssociatedObject (self, &overviewKey,actions,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary*)actions {
    return objc_getAssociatedObject(self, &overviewKey);
}

- (void)doTouchUpInside:(id)sender {
    void(^block)();
    block = [[self actions] objectForKey:kUIButtonBlockTouchUpInside];
    block();
}

@end
