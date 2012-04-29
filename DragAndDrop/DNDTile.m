//
//  DNDTile.m
//  DragAndDrop
//
//  Created by Jack Tihon on 4/27/12.
//  Copyright (c) 2012 Endorse. All rights reserved.
//

#import "DNDTile.h"

@implementation DNDTile

@synthesize color;
@synthesize contentView;
@synthesize indexPath;
@synthesize delegate;
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
    }
    return self;
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
    NSLog(@"touchesBegan: %@ touches.count=%d", NSStringFromCGPoint(touchStart), touches.count);
    
}


-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_moveable == NO)
        return;
    
    NSLog(@"touchesMoved: touches.count=%d", touches.count);
    CGPoint point = [[touches anyObject] locationInView:self];
    self.center = CGPointMake(self.center.x + point.x - touchStart.x, self.center.y + point.y - touchStart.y);
    
    if (delegate)
    {
        NSIndexPath * ip = [delegate tileIndexForPoint:[[touches anyObject] locationInView:delegate.view] ];
        UILabel * label = [[UILabel alloc] init];
        
        if (ip)
        {
            NSLog(@"tile moved to iP:%d.%d", ip.section, ip.row);
            label.text = [NSString stringWithFormat:@"cell %d.%d", ip.section, ip.row];
            label.backgroundColor = [UIColor redColor];
        } else {
            label.text = [NSString stringWithFormat:@"no cell"];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor blackColor];
        }
        self.contentView = label;
    }

}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touchesEnded touches.count=%d", touches.count);
    if (_moveable && _snapToGrid && delegate) {
        NSIndexPath * ip = [delegate tileIndexForPoint:[[touches anyObject] locationInView:delegate.view] ];
        UILabel * label = [[UILabel alloc] init];
        
        if (ip)
        {
            NSLog(@"snap to iP:%d.%d", ip.section, ip.row);
            label.text = [NSString stringWithFormat:@"cell %d.%d", ip.section, ip.row];
            label.backgroundColor = [UIColor redColor];
            
            //snap to center of corresponding cell
            DNDTile * snapToMe = [delegate tileForIndexPath:ip];
            
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.center = snapToMe.center;
            } completion:^(BOOL finished) {
                NSLog(@"done snapping");
                self.indexPath = ip;
                self.contentView = label;
            }];
            
        } else if (self.indexPath) {
            //snap to last cell...
            DNDTile * snapBack = [delegate tileForIndexPath:self.indexPath];
            
            [UIView animateWithDuration:0.1 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.center = snapBack.center;
            } completion:^(BOOL finished) {
                NSLog(@"done snapping BACK");
                label.text = [NSString stringWithFormat:@"oh SNAPPED back!"];
                label.textColor = [UIColor whiteColor];
                label.backgroundColor = [UIColor orangeColor];
                self.contentView = label;
            }];

        }
    }
}

@end
