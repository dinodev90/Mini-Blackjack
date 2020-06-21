//
//  BlackJack.h
//  Mini-BlackJack
//
//  Created by Dinesh Kumar Vyas on 22/04/19.
//  Copyright © 2019 Dinesh Kumar Vyas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlackJack : NSObject
@property(nonatomic, retain) NSMutableArray*playerCards;
-(instancetype)initWithPlayers:(int) players;
-(int)getTotal:(NSArray*)cs;
-(void)throughCards;
-(void)hit;
-(void)stand;
-(void)reset;
@end

NS_ASSUME_NONNULL_END
