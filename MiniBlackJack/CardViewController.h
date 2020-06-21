//
//  CardViewController.h
//  Mini-BlackJack
//
//  Created by Dinesh Kumar Vyas on 23/04/19.
//  Copyright © 2019 Dinesh Kumar Vyas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardViewController : NSViewController
@property(nonatomic, retain) NSString*card;
-(void)showCard;
-(void)hideCard;
@end

NS_ASSUME_NONNULL_END
