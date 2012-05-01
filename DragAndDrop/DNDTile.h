//
//  DNDTile.h
//  DragAndDrop
//
//  Created by Jack Tihon on 4/27/12.
//  Copyright (c) 2012 Jack Tihon. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum 
{
    DNDPositionSameCell,
    DNDPositionNewCell,
    DNDPositionSnappedBack,
} DNDPosition;



@protocol DNDTileDraggingDelegate;
@protocol DNDTileLocationDelegate;


@interface DNDTile : UIView
{
    CGPoint touchStart;
    UIColor * color;
    UIView * contentView;
    NSIndexPath * indexPath;
    id<DNDTileLocationDelegate> locationDelegate;
    id<DNDTileDraggingDelegate> draggingDelegate;
}

@property (nonatomic, strong) UIColor * color;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, strong) NSIndexPath * indexPath;
@property (nonatomic, strong) id<DNDTileLocationDelegate> locationDelegate;
@property (nonatomic, strong) id<DNDTileDraggingDelegate> draggingDelegate;
@property (nonatomic) BOOL moveable;
@property (nonatomic) BOOL snapToGrid;

@end


@protocol DNDTileLocationDelegate <NSObject>

@optional
-(NSIndexPath *) tileIndexForPoint:(CGPoint) _point;
-(DNDTile *) tileForIndexPath:(NSIndexPath *) _indexPath;

@property (nonatomic) UIView * view;
@end


@protocol DNDTileDraggingDelegate <NSObject>

@optional
-(void) didStartDragging:(DNDTile*) tile;
-(void) isStillDragging:(DNDTile*) tile atIndexPath: (NSIndexPath *) indexPath;
-(void) didEndDragging:(DNDTile*) tile toPosition:(DNDPosition) position;
@end
