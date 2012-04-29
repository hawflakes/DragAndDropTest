//
//  DNDTile.h
//  DragAndDrop
//
//  Created by Jack Tihon on 4/27/12.
//  Copyright (c) 2012 Endorse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNDViewController.h"

@interface DNDTile : UIView
{
    CGPoint touchStart;
    UIColor * color;
    UIView * contentView;
    NSIndexPath * indexPath;
    DNDViewController * delegate;
}

@property (nonatomic, strong) UIColor * color;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, strong) DNDViewController * delegate;
@property (nonatomic) BOOL moveable;
@property (nonatomic) BOOL snapToGrid;
@end
