//
//  UIImage+TintColor.h
//

#import <UIKit/UIKit.h>

/**
 *  UIImage TintColor category
 */
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