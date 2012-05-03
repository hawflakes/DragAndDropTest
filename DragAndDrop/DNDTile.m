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
@synthesize draggingDelegate = _draggingDelegate;
@synthesize locationDelegate = _locationDelegate;
@synthesize tapDelegate = _tapDelegate;

@synthesize moveable = _moveable;
@synthesize snapToGrid = _snapToGrid;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //color = [UIColor greenColor];
        _moveable = NO;
        _snapToGrid = NO;
        _draggingDelegate = nil;
        _locationDelegate = nil;
        _tapDelegate = nil;
        
    }
    return self;
}

-(void) setDraggingDelegate:(id<DNDTileDraggingDelegate>) newDraggingDelegate
{
    _draggingDelegate = newDraggingDelegate;
}

-(void) setLocationDelegate:(id<DNDTileLocationDelegate>) newLocationDelegate
{
    _locationDelegate = newLocationDelegate;
}

- (void)setTapDelegate:(id<DNDTileTapDelegate>)newTapDelegate
{
    _tapDelegate = newTapDelegate;
    UITapGestureRecognizer * tapRecog = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRouter:)];
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


-(void) tapRouter:(UIGestureRecognizer*) gestureRecognizer
{
    NSIndexPath * ip = [_locationDelegate tileIndexForPoint:[gestureRecognizer locationInView:_locationDelegate.view]];
    
    if (ip) {
        DNDTile * tile = [_locationDelegate tileForIndexPath:ip];
        [self.tapDelegate didTapTile:tile];
    } else {
        NSLog(@"error tap but don't know where to route to");
    }
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    touchStart = [[touches anyObject] locationInView:self];
    
    if (_draggingDelegate) {
        [_draggingDelegate didStartDragging:self];
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
    
    if (_locationDelegate)
    {
        NSIndexPath * ip = [_locationDelegate backgroundTileIndexForPoint:[[touches anyObject] locationInView:_locationDelegate.view] ];
        if (_draggingDelegate)
        {
            [_draggingDelegate isStillDragging:self atIndexPath:ip];
        }
    }

}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded touches.count=%d", touches.count);
    if (_moveable && _snapToGrid && _locationDelegate) {
        NSIndexPath * ip = [_locationDelegate backgroundTileIndexForPoint:[[touches anyObject] locationInView:_locationDelegate.view] ];
        
        if (ip)
        {
            NSLog(@"snap to iP:%d.%d", ip.section, ip.row);
            //snap to center of corresponding cell
            DNDTile * snapToMe = [_locationDelegate backgroundTileForIndexPath:ip];
            
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.center = snapToMe.center;
            } completion:^(BOOL finished) {
                NSLog(@"done snapping");
                self.indexPath = ip;
                
                if (_draggingDelegate) 
                {
                    if ((self.indexPath.section == ip.section)&&(self.indexPath.row == ip.row))
                    {
                        [_draggingDelegate didEndDragging:self toPosition:DNDPositionSameCell];
                    } else {
                        [_draggingDelegate didEndDragging:self toPosition:DNDPositionNewCell];
                    }
                }
            }];
            
        } else if (self.indexPath) {
            //snap to last cell...
            DNDTile * snapBack = [_locationDelegate tileForIndexPath:self.indexPath];
            
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.center = snapBack.center;
            } completion:^(BOOL finished) {
                NSLog(@"done snapping BACK");
                if (_draggingDelegate) 
                {
                    [_draggingDelegate didEndDragging:self toPosition:DNDPositionSnappedBack];
                }; 
            }];

        }
    }
}

@end
