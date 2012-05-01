//
//  DNDTile.m
//  DragAndDrop
//
//  Created by Jack Tihon on 4/27/12.
//  Copyright (c) 2012 Jack Tihon. All rights reserved.
//

#import "DNDTile.h"

@implementation DNDTile

@synthesize color;
@synthesize contentView;
@synthesize indexPath;
@synthesize draggingDelegate;
@synthesize locationDelegate;
@synthesize tapDelegate = _tapDelegate;

@synthesize moveable = _moveable;
@synthesize snapToGrid = _snapToGrid;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        color = [UIColor greenColor];
        _moveable = NO;
        _snapToGrid = NO;
        draggingDelegate = nil;
        locationDelegate = nil;
        tapDelegate = nil;
        
    }
    return self;
}

- (void)setTapDelegate:(id<DNDTileTapDelegate>)newTapDelegate
{
    self.tapDelegate = newTapDelegate;
    UITapGestureRecognizer * tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:tapDelegate action:@selector(didTapTile:)];
    [tapRecog setNumberOfTapsRequired:1];
    [tapRecog setNumberOfTouchesRequired:1];
    [tapRecog setCancelsTouchesInView:NO];
    [self addGestureRecognizer:tapRecog];
}

- (void)setContentView:(UIView *)newContentView {
    [contentView removeFromSuperview];
    contentView = newContentView;
    contentView.frame = self.bounds;
    [self addSubview:contentView];
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [color setFill];
    [[UIBezierPath bezierPathWithRect:rect] fill];
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchStart = [[touches anyObject] locationInView:self];
    
    if (draggingDelegate) {
        [draggingDelegate didStartDragging:self];
    };
    
    NSLog(@"touchesBegan: %@ touches.count=%d", NSStringFromCGPoint(touchStart), touches.count);
    
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_moveable == NO)
        return;
    
    NSLog(@"touchesMoved: touches.count=%d", touches.count);
    CGPoint point = [[touches anyObject] locationInView:self];
    self.center = CGPointMake(self.center.x + point.x - touchStart.x, self.center.y + point.y - touchStart.y);
    
    if (locationDelegate)
    {
        NSIndexPath * ip = [locationDelegate tileIndexForPoint:[[touches anyObject] locationInView:locationDelegate.view] ];
        if (draggingDelegate)
        {
            [draggingDelegate isStillDragging:self atIndexPath:ip];
        }
    }

}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded touches.count=%d", touches.count);
    if (_moveable && _snapToGrid && locationDelegate) {
        NSIndexPath * ip = [locationDelegate tileIndexForPoint:[[touches anyObject] locationInView:locationDelegate.view] ];
        UILabel * label = [[UILabel alloc] init];
        
        if (ip)
        {
            NSLog(@"snap to iP:%d.%d", ip.section, ip.row);
            label.text = [NSString stringWithFormat:@"cell %d.%d", ip.section, ip.row];
            label.backgroundColor = [UIColor redColor];
            
            //snap to center of corresponding cell
            DNDTile * snapToMe = [locationDelegate tileForIndexPath:ip];
            
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.center = snapToMe.center;
            } completion:^(BOOL finished) {
                NSLog(@"done snapping");
                
                if (draggingDelegate) 
                {
                    if ((self.indexPath.section == ip.section)&&(self.indexPath.row == ip.row))
                    {
                        [draggingDelegate didEndDragging:self toPosition:DNDPositionSameCell];
                    } else {
                        [draggingDelegate didEndDragging:self toPosition:DNDPositionNewCell];
                    }
                }
                self.indexPath = ip;
                self.contentView = label;
            }];
            
        } else if (self.indexPath) {
            //snap to last cell...
            DNDTile * snapBack = [locationDelegate tileForIndexPath:self.indexPath];
            
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.center = snapBack.center;
            } completion:^(BOOL finished) {
                NSLog(@"done snapping BACK");
                if (draggingDelegate) 
                {
                    [draggingDelegate didEndDragging:self toPosition:DNDPositionSnappedBack];
                }; 
            }];

        }
    }
}

@end
