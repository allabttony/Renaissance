//
//  REGridView.m
//
//  Created by Tony on 12/9/14.
//  Copyright (c) 2014 tony. All rights reserved.
//

#import "REGridView.h"

@interface REGridView ()
{
    CGFloat _lineWidth;
    NSUInteger _numberOfColumns;
    NSUInteger _numberOfRows;
}

@end

@implementation REGridView

- (void) _setup
{
    self.backgroundColor = [UIColor clearColor];
    _lineWidth = 1.0;
    _numberOfColumns = 2;
    _numberOfRows = 2;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self _setup];
    }
    return self;
}

// -------------------------------------------------------------------------------
// Used for drawing the grids ontop of the view port
// -------------------------------------------------------------------------------
- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    // ---------------------------
    // Drawing column lines
    // ---------------------------
    
    // calculate column width
    CGFloat columnWidth = self.frame.size.width / (_numberOfColumns + 1.0);
    
    for ( NSUInteger i = 1; i <= _numberOfColumns; i++ )
    {
        CGPoint startPoint;
        CGPoint endPoint;
        
        startPoint.x = columnWidth * i;
        startPoint.y = 0.0f;
        
        endPoint.x = startPoint.x;
        endPoint.y = self.frame.size.height;
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }
    
    // ---------------------------
    // Drawing row lines
    // ---------------------------
    
    // calclulate row height
    CGFloat rowHeight = self.frame.size.height / (_numberOfRows + 1.0);
    
    for(NSUInteger j = 1; j <= _numberOfRows; j++)
    {
        CGPoint startPoint;
        CGPoint endPoint;
        
        startPoint.x = 0.0f;
        startPoint.y = rowHeight * j;
        
        endPoint.x = self.frame.size.width;
        endPoint.y = startPoint.y;
        
        CGContextMoveToPoint(context, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(context, endPoint.x, endPoint.y);
        CGContextStrokePath(context);
    }
}

@end
