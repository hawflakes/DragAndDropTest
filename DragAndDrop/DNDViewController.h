//
//  DNDViewController.h
//  DragAndDrop
//
//  Created by Jack Tihon on 4/27/12.
//  Copyright (c) 2012 Jack Tihon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DNDTile;

@interface DNDViewController : UIViewController
{
    NSMutableArray * tiles;
}

@property (nonatomic) NSMutableArray * tiles;

-(NSIndexPath *) tileIndexForPoint:(CGPoint) _point;
-(DNDTile *) tileForIndexPath:(NSIndexPath *) _indexPath;

@end
