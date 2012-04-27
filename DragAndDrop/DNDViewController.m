//
//  DNDViewController.m
//  DragAndDrop
//
//  Created by Jack Tihon on 4/27/12.
//  Copyright (c) 2012 Endorse. All rights reserved.
//

#import "DNDViewController.h"

@interface DNDViewController ()

@end

@implementation DNDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

@end
