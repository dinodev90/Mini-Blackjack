//
//  BlackJack.m
//  Mini-BlackJack
//
//  Created by Dinesh Kumar Vyas on 22/04/19.
//  Copyright © 2019 Dinesh Kumar Vyas. All rights reserved.
//

#import "BlackJack.h"
#import "CardsHelper.h"

#define MIN_CARDS 20

@interface BlackJack()
@property(nonatomic, retain) CardsHelper*ch;
@property(nonatomic) int players;
@property(nonatomic, retain) NSMutableArray*cards;
@property(nonatomic) BOOL isStand;
@end

@implementation BlackJack
-(instancetype)initWithPlayers:(int) players{
	self = [super init];
	if (self) {
		_ch = [[CardsHelper alloc] init];
		_players = players;
		[self shuffle];
		[self reset];
	}
	return self;
}
-(void)reset{
	_playerCards = [[NSMutableArray alloc] init];
}
-(void)shuffle{
	_cards = [NSMutableArray arrayWithArray:[_ch shuffle]];
}
-(void)throughCards{
	if (_cards.count < MIN_CARDS) {
		[_cards addObjectsFromArray:[_ch shuffle]];
	}
	for (int i=0; i<_players+1; i++) {
		NSMutableArray*pc = [[NSMutableArray alloc] init];
		[pc addObject:[self serveCard]];
		[pc addObject:[self serveCard]];
		[_playerCards addObject:pc];
	}
}
-(void)stand{
	_isStand = true;
	while ([self dealerStand]);
}
-(BOOL)dealerStand{
	NSArray*ppcs = [_playerCards objectAtIndex:1];
	int p_ttl = [self getTotal:ppcs];
	int prv = 21 - p_ttl;
	
	NSArray*dpcs = [_playerCards objectAtIndex:0];
	int d_ttl = [self getTotal:dpcs];
	int drv = 21 - d_ttl;
	
	if (drv < prv) {
		//NSLog(@"Dealer Won");
		return false;
	}else{
		[[_playerCards objectAtIndex:0] addObject:[self serveCard]];
		//[self logCards:0];
		//[self checkResults];
	}
	return true;
}
-(void)hit{
	[[_playerCards objectAtIndex:1] addObject:[self serveCard]];
	//[self logCards:1];
	//[self checkResults];
}

//-(void)logDealerCards{
//    NSArray*pcs = [_playerCards objectAtIndex:0];
//
//    NSLog(@"Dealer -");
//
//    for (int i=0; i<pcs.count; i++) {
//        if (i > 0) {
//            printf(" **");
//            continue;
//        }
//        printf(" %s", [[self getCardName:[pcs objectAtIndex:i]] UTF8String]);
//    }
//
//    printf("\n");
//}
//-(void)logCards:(int)index{
//    NSArray*pcs = [_playerCards objectAtIndex:index];
//    int ttl = [self getTotal:pcs];
//
//    if (index == 0) {
//        NSLog(@"Dealer -");
//    }else{
//        NSLog(@"Player %i -", index);
//    }
//
//    [self print_cards:pcs];
//    printf(" = %i", ttl);
//    printf("\n");
//}
-(NSString*)getCardName:(NSString*)c{
	NSString*t = [c substringToIndex:1];
	int v = [[c substringFromIndex:1] intValue];
	NSDictionary*sym = @{
		@"h":@"♥️",
		@"s":@"♠️",
		@"c":@"♣️",
		@"d":@"♦️"
	};
	NSString*cv;
	switch (v) {
		case 11:
			cv = @"J";
			break;
		case 12:
			cv = @"Q";
			break;
		case 13:
			cv = @"K";
			break;
		case 1:
			cv = @"A";
			break;
		default:
			cv = [c substringFromIndex:1];
			break;
	}
	return [NSString stringWithFormat:@"%@%@", [sym valueForKey:t], cv];
}
-(void)print_cards:(NSArray*)cs{
	for (int i=0; i<cs.count; i++) {
		printf(" %s", [[self getCardName:[cs objectAtIndex:i]] UTF8String]);
	}
}
-(NSString*)serveCard{
	NSString*c = [_cards firstObject];
	//c = [self getCardName:c];
	[_cards removeObjectAtIndex:0];
	return c;
}
-(int)getTotal:(NSArray*)cs{
	int oc = 0;
	int tc = 0;
	for(NSString*c in cs){
		int cn = [[c substringFromIndex:1] intValue];
		if (cn == 1) {
			oc++;
		}else{
			tc += cn;
		}
	}
	
	int once = oc;
	int tens = 0;
	int f = 0;
	for (int i=0; i<=oc; i++) {
		int t = tc + (1*once) + (10*tens);
		if (f == 0) {
			f = t;
		}
		if (t == 21) {
			tc = 21;
			break;
		}else if (t > 21) {
			tc = t;
			break;
		}
		once--;
		tens++;
	}
	if (tc != 21) {
		return f;
	}
	
	return tc;
}
-(int)statBJ:(int)c{
	if(c < 21){
		return 1;
	}else if(c == 21){
		return 2;
	}else{
		return 3;
	}
}

@end
