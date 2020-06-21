//
//  AppDelegate.h
//  Mini-BlackJack
//
//  Created by Dinesh Kumar Vyas on 23/04/19.
//  Copyright © 2019 Dinesh Kumar Vyas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class TabView;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property(nonatomic, retain) TabView*tabView;
@property(nonatomic) long totalCash;
@property(nonatomic) long bidAmount;
@end

