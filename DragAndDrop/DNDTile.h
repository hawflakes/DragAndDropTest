//
//  DNDTile.h
//  DragAndDrop
//
//  Created by Jack Tihon on 4/27/12.
//  Copyright (c) 2012 Jack Tihon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNDViewController.h"




typedef enum 
{
    DNDPositionSameCell,
    DNDPositionNewCell,
    DNDPositionSnappedBack,
} DNDPosition;

@protocol DNDTileDraggingProtocol <NSObject>

@optional
-(void) didStartDragging:(DNDTile*) tile;
-(void) isStillDragging:(DNDTile*) tile atIndexPath: (NSIndexPath *) indexPath;
-(void) didEndDragging:(DNDTile*) tile toPosition:(DNDPosition) position;

@end


@interface DNDTile : UIView<DNDTileDraggingProtocol>
{
    CGPoint touchStart;
    UIColor * color;
    UIView * contentView;
    NSIndexPath * indexPath;
    id<DNDTileLocationDelegate> locationDelegate;
    id<DNDTileDraggingProtocol> draggingDelegate;
}

@property (nonatomic, strong) UIColor * color;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, strong) id<DNDTileLocationDelegate> locationDelegate;
@property (nonatomic, strong) id<DNDTileDraggingProtocol> draggingDelegate;
@property (nonatomic) BOOL moveable;
@property (nonatomic) BOOL snapToGrid;




@end
