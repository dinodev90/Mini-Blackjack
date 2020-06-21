//
//  DealController.m
//  Mini-BlackJack
//
//  Created by Dinesh Kumar Vyas on 23/04/19.
//  Copyright © 2019 Dinesh Kumar Vyas. All rights reserved.
//

#import "DealController.h"
#import "TabView.h"
#import "AppDelegate.h"

@interface DealController ()
@property(nonatomic, retain) IBOutlet NSTextField*bid;
@property(nonatomic, retain) IBOutlet NSTextField*cash;
@property(nonatomic, retain) IBOutlet NSButton*dealBtn;
@property(nonatomic, retain) AppDelegate*app;
@property(nonatomic) long bid_amount;
@end

@implementation DealController

- (void)viewDidLoad {
    [super viewDidLoad];
    _app = (AppDelegate*)[NSApplication sharedApplication].delegate;
    _app.totalCash = 1000;
}

- (void)viewDidAppear {
    [super viewDidAppear];
}


@end
