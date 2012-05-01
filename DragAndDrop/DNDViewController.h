//
//  DNDViewController.h
//  DragAndDrop
//
//  Created by Jack Tihon on 4/27/12.
//  Copyright (c) 2012 Jack Tihon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNDTile.h"

@interface DNDViewController : UIViewController<DNDTileLocationDelegate, DNDTileDraggingDelegate>
{
    NSMutableArray * tiles;
}

@property (nonatomic) NSMutableArray * tiles;

@end
