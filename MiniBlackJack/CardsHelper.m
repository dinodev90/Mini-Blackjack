//
//  ShuffleHelper.m
//  Mini-Poker
//
//  Created by Dinesh Kumar Vyas on 22/04/19.
//  Copyright © 2019 Dinesh Kumar Vyas. All rights reserved.
//

#import "CardsHelper.h"

@implementation CardsHelper

-(instancetype)init{
	self = [super init];
	if (self) {
		_cards = @[@"h1", @"h2", @"h3", @"h4", @"h5", @"h6", @"h7", @"h8", @"h9", @"h10", @"h11", @"h12", @"h13",
				   @"c1", @"c2", @"c3", @"c4", @"c5", @"c6", @"c7", @"c8", @"c9", @"c10", @"c11", @"c12", @"c13",
				   @"s1", @"s2", @"s3", @"s4", @"s5", @"s6", @"s7", @"s8", @"s9", @"s10", @"s11", @"s12", @"s13",
				   @"d1", @"d2", @"d3", @"d4", @"d5", @"d6", @"d7", @"d8", @"d9", @"d10", @"d11", @"d12", @"d13"];
	}
	return self;
}

-(NSArray*)shuffle{
	_cards = [self shuffle_rand:_cards];
	_cards = [self shuffle_reverse:_cards];
	_cards = [self shuffle_cross:_cards];
	_cards = [self shuffle_fl:_cards];
	_cards = [self shuffle_evo:_cards];
	_cards = [self shuffle_rand:_cards];
	_cards = [self shuffle_cross:_cards];
	return _cards;
}

// MARK: -
// MARK: Shuffle Algos

-(NSArray*)shuffle_cross:(NSArray*)cards{
	long count = cards.count;
	long slot1count = floor(count/2.0);
	long slot2count = ceil(count/2.0);
	NSArray*slot1 = [cards subarrayWithRange:NSMakeRange(0, slot1count)];
	NSArray*slot2 = [cards subarrayWithRange:NSMakeRange(slot1count, slot2count)];
	NSMutableArray*finalSlot = [[NSMutableArray alloc] init];
	
	for (long c=0; c<slot1count; c++) {
		[finalSlot addObject:[slot1 objectAtIndex:c]];
		[finalSlot addObject:[slot2 objectAtIndex:c]];
	}
	
	if (slot2count > slot1count) {
		[finalSlot addObject:[slot2 lastObject]];
	}
	
	return finalSlot;
}

-(NSArray*)shuffle_reverse:(NSArray*)cards{
	return [[cards reverseObjectEnumerator] allObjects];
}

-(NSArray*)shuffle_evo:(NSArray*)cards{
	long count = cards.count;
	NSMutableArray*slot = [[NSMutableArray alloc] init];
	
	for (long c = 0; c<count; c+=2) {
		[slot addObject:[cards objectAtIndex:c]];
	}
	
	for (long c = 1; c<count; c+=2) {
		[slot addObject:[cards objectAtIndex:c]];
	}
	
	return slot;
}

-(NSArray*)shuffle_fl:(NSArray*)cards{
	long count = cards.count;
	long slotCount = floor(count/2.0);
	NSMutableArray*slot = [[NSMutableArray alloc] init];
	
	for (long c = 0; c<slotCount; c++) {
		[slot addObject:[cards objectAtIndex:c]];
		[slot addObject:[cards objectAtIndex:count-(c+1)]];
	}
	
	if (slotCount != count/2.0) {
		[slot addObject:[cards objectAtIndex:ceil(count/2)]];
	}
	
	return slot;
}

-(NSArray*)shuffle_rand:(NSArray*)cards{
	NSMutableArray*mutableTargetSlot = [NSMutableArray arrayWithArray:cards];
	NSMutableArray*slot = [[NSMutableArray alloc] init];
	long count = cards.count;
	
	for (long c = 0; c<count; c++) {
		unsigned long r = 0 + arc4random_uniform(mutableTargetSlot.count);
		[slot addObject:[mutableTargetSlot objectAtIndex:r]];
		[mutableTargetSlot removeObjectAtIndex:r];
	}
	
	return slot;
}

@end
