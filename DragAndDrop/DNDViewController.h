//
//  DNDViewController.h
//  DragAndDrop
//
//  Created by Jack Tihon on 4/27/12.
//  Copyright (c) 2012 Jack Tihon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DNDTile;

@protocol DNDTileLocationDelegate <NSObject>
@optional
-(NSIndexPath *) tileIndexForPoint:(CGPoint) _point;
-(DNDTile *) tileForIndexPath:(NSIndexPath *) _indexPath;

@property (nonatomic) UIView * view;
@end


@interface DNDViewController : UIViewController<DNDTileLocationDelegate>
{
    NSMutableArray * tiles;
}

@property (nonatomic) NSMutableArray * tiles;

@end
