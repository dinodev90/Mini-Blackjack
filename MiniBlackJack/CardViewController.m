//
//  CardViewController.m
//  Mini-Poker
//
//  Created by Dinesh Kumar Vyas on 23/04/19.
//  Copyright © 2019 Dinesh Kumar Vyas. All rights reserved.
//

#import "CardViewController.h"

@interface CardViewController ()
@property(nonatomic, retain) IBOutlet NSTextField*ls;
@property(nonatomic, retain) IBOutlet NSTextField*cs;
@property(nonatomic, retain) IBOutlet NSTextField*val;
@property(nonatomic, retain) IBOutlet NSImageView*bg;

@end

@implementation CardViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self drawCardWithVal:_card];
}

-(void)drawCardWithVal:(NSString*)c{
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
	
	_cs.stringValue = [sym valueForKey:t];
	_ls.stringValue = [sym valueForKey:t];
	if([t isEqualToString:@"h"] || [t isEqualToString:@"d"]){
		_val.textColor = [NSColor colorWithRed:0.8 green:0 blue:0 alpha:1];
	}else{
		_val.textColor = [NSColor blackColor];
	}
	_val.stringValue = cv;
}

-(void)showCard{
	_bg.hidden = true;
}

-(void)hideCard{
	_bg.hidden = false;
}

@end
