//
//  DNDViewController.m
//  DragAndDrop
//
//  Created by Jack Tihon on 4/27/12.
//  Copyright (c) 2012 Jack Tihon. All rights reserved.
//

#import "DNDTile.h"
#import "DNDViewController.h"


@interface DNDViewController ()

@end

@implementation DNDViewController
@synthesize tiles;

static CGSize TILESIZE;


-(UIView *) backgroundGrid
{
    [tiles removeAllObjects];
    CGFloat gridHeight = 320;
    CGFloat gridWidth = 320;
    UIView * grid = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    
    const int ROWS = 3;
    const int COLS = 3;
    
    
    const CGFloat colPadding = (gridWidth - (TILESIZE.width*COLS)) /(COLS+1);
    const CGFloat rowPadding = (gridHeight - (TILESIZE.height*ROWS)) /(ROWS+1);
    
    
    //generate grid cell
    for (int row = 0; row < ROWS; ++row) {
        for (int col = 0; col < COLS; ++col) {
            
            int x_off = col*(TILESIZE.width + colPadding) + colPadding;
            int y_off = row*(TILESIZE.height+ rowPadding) + rowPadding;
            DNDTile * emptyTile = [[DNDTile alloc] initWithFrame:CGRectMake(x_off, y_off, TILESIZE.width, TILESIZE.height)];
            
            NSUInteger ipArr[2];
            ipArr[0] = row;
            ipArr[1] = col;
            emptyTile.indexPath = [[NSIndexPath alloc] initWithIndexes:ipArr length:2];
            emptyTile.color = [UIColor redColor];
            
            UILabel * label = [[UILabel alloc] init];
            label.text = [NSString stringWithFormat:@"cell %d", row*COLS + col];
            emptyTile.moveable = NO;
            emptyTile.contentView = label;
            emptyTile.tapDelegate = self;
        
            [grid addSubview:emptyTile];
            [tiles addObject:emptyTile];
        }
    }
    
    return grid;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    tiles = [[NSMutableArray alloc] initWithCapacity:9];
    TILESIZE = CGSizeMake(90, 90);
    
    [self.view addSubview:[self backgroundGrid]];
    
    DNDTile * t = [[DNDTile alloc] initWithFrame:CGRectMake(5, 5, TILESIZE.width, TILESIZE.height)];
    t.locationDelegate = self;
    t.draggingDelegate = self;
    t.moveable = YES;
    t.snapToGrid = YES;
    [self.view addSubview:t];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"VC touchesEnded touches.count=%d", touches.count);
}

#pragma mark - DNDTileLocationDelegate methods

-(NSIndexPath *) tileIndexForPoint:(CGPoint) _point
{
    for (DNDTile * t in tiles) {
        if (CGRectContainsPoint(t.frame, _point)) {
            NSLog(@"found an index: %d.%d", t.indexPath.section, t.indexPath.row);
            return t.indexPath;
        }
    }
    return nil;
}

-(DNDTile *) tileForIndexPath:(NSIndexPath *) _indexPath
{
    for (DNDTile * t in tiles) {
        if ((t.indexPath.section == _indexPath.section)&&(t.indexPath.row == _indexPath.row)) {//is there a more succint equality operator?
            NSLog(@"found an index: %d.%d", t.indexPath.section, t.indexPath.row);
            return t;
        }
    }
    return nil;
}


#pragma mark - DNDTile notifications
-(void) didStartDragging:(DNDTile*) tile
{
    
}

-(void) isStillDragging:(DNDTile*) tile atIndexPath:(NSIndexPath *) _indexPath
{
    UILabel * label = [[UILabel alloc] init];
    
    if (_indexPath)
    {
        NSLog(@"tile moved to iP:%d.%d", _indexPath.section, _indexPath.row);
        label.text = [NSString stringWithFormat:@"cell %d.%d", _indexPath.section, _indexPath.row];
        label.backgroundColor = [UIColor redColor];
    } else {
        label.text = [NSString stringWithFormat:@"no cell"];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor blackColor];
    }
    tile.contentView = label;
    
    
}

-(void) didEndDragging:(DNDTile*) tile toPosition:(DNDPosition) position
{
    if (position == DNDPositionNewCell) 
    {
        
    } else if (position == DNDPositionSnappedBack)
    {
        UILabel * label = [[UILabel alloc] init];
        label.text = [NSString stringWithFormat:@"oh SNAPPED back!"];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor orangeColor];
        tile.contentView = label;        
    } else if (position == DNDPositionSameCell)
    {
        
    } else {
        NSLog(@"unknown position");
    }
}


#pragma mark - DNDTile tap delegate
-(void) didTapTile:(DNDTile *)tile
{
    NSLog(@"did tap tile");
}

@end
