//
//  RECategories.h
//  RenaissanceDemo
//
//  Created by Tony on 4/19/15.
//  Copyright (c) 2015 tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIImage (RECrop)
/**
 *  Create an UIImage from a UIView
 *
 *  @param view The view you want to use
 *
 *  @return an UIImage from the used UIView
 */
+ (UIImage *) screenshotFromView:(UIView *)view;

/**
 *  Crop the UIImage inside a CGRect
 *
 *  @param cropRect the CGRect that define the crop bounds
 *
 *  @return the new UIImage
 */
- (UIImage *) croppedImage:(CGRect)cropRect;

/**
 *  Rotate the UIImgae to the right position
 *
 *  @return the rotated UIImage
 */
- (UIImage *) rotateUIImage;

/**
 *  Create an UIImage with round bounds
 *
 *  @param image  the UIImage you want to use
 *  @param size   the crop CGRect
 *  @param radius the radius value
 *
 *  @return the new UIImage
 */
+ (UIImage *) createRoundedRectImage:(UIImage *)image size:(CGSize)size roundRadius:(CGFloat)radius;

/**
 *  Resize an UIImage with a precise CGSize
 *
 *  @param img       the UIImage you want to use
 *  @param finalSize the new CGSize
 *
 *  @return the new UIImage
 */
+ (UIImage *) returnImage:(UIImage *)img withSize:(CGSize)finalSize;
@end

@interface UIImage (REResize)

- (UIImage *)croppedImage:(CGRect)bounds;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;

- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

- (UIImage *)fixOrientation;

- (UIImage *)rotatedByDegrees:(CGFloat)degrees;

@end

@interface UIImage (TintColor)
/**
 *  Tint the image using this method/
 *
 *  @param tintColor the color you selected
 *
 *  @return the image tinted with the color you selected
 */
- (UIImage *) tintImageWithColor:(UIColor *)tintColor;
@end

@interface UIButton (REBlock)

typedef void (^ActionBlock)(id sender);

@property (readonly) NSMutableDictionary *event;

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;

@end
