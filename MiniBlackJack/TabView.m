//
//  TabView.m
//  Mini-BlackJack
//
//  Created by Dinesh Kumar Vyas on 23/04/19.
//  Copyright © 2019 Dinesh Kumar Vyas. All rights reserved.
//

#import "TabView.h"
#import "AppDelegate.h"

@interface TabView ()

@end

@implementation TabView

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate*app = (AppDelegate*)[NSApplication sharedApplication].delegate;
    app.tabView = self;
}

@end
