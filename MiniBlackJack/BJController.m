//
//  BJController.m
//  Mini-BlackJack
//
//  Created by Dinesh Kumar Vyas on 23/04/19.
//  Copyright © 2019 Dinesh Kumar Vyas. All rights reserved.
//

#import "BJController.h"
#import "BlackJack.h"
#import "CardViewController.h"
#import "TabView.h"
#import "AppDelegate.h"

#define CARD_SIDE_WIDTH 22

@interface BJController ()
@property(nonatomic, retain) IBOutlet NSBox*loaderView;
@property(nonatomic, retain) IBOutlet NSLayoutConstraint*plWidth;
@property(nonatomic, retain) IBOutlet NSLayoutConstraint*dlWidth;
@property(nonatomic, retain) IBOutlet NSBox*plContainer;
@property(nonatomic, retain) IBOutlet NSBox*dlContainer;
@property(nonatomic, retain) IBOutlet NSTextField*pTotal;
@property(nonatomic, retain) IBOutlet NSTextField*dTotal;
@property(nonatomic, retain) IBOutlet NSBox*plTotalContainer;
@property(nonatomic, retain) IBOutlet NSBox*dlTotalContainer;
@property(nonatomic, retain) IBOutlet NSBox*dlResultContainer;
@property(nonatomic, retain) IBOutlet NSTextField*dResult;
@property(nonatomic, retain) IBOutlet NSBox*plResultContainer;
@property(nonatomic, retain) IBOutlet NSTextField*pResult;
@property(nonatomic, retain) IBOutlet NSTextField*bid;
@property(nonatomic, retain) IBOutlet NSTextField*cash;
@property(nonatomic, retain) IBOutlet NSButton*doubleBtn;
@property(nonatomic, retain) IBOutlet NSButton*hitBtn;
@property(nonatomic, retain) IBOutlet NSButton*standBtn;
@property(nonatomic, retain) IBOutlet NSBox*dealBox;
@property(nonatomic, retain) IBOutlet NSButton*dealBtn;
@property(nonatomic, retain) BlackJack*bj;
@property(nonatomic, retain) NSMutableArray*pCards;
@property(nonatomic, retain) NSMutableArray*dCards;
@property(nonatomic) BOOL isStand;
@property(nonatomic) BOOL isFinished;
@property(nonatomic) long bid_amount;

@end

@implementation BJController

- (void)viewDidLoad {
	[super viewDidLoad];
	AppDelegate*app = (AppDelegate*)[NSApplication sharedApplication].delegate;
	app.totalCash = 1000;
	_bj = [[BlackJack alloc] initWithPlayers:1];
	
	
	// Do view setup here.
}
-(void)viewDidAppear{
	[super viewDidAppear];
	//    [self updateBid];
	//    [self dealAction:self];
	[self resetBid];
	_loaderView.hidden = true;
}
-(void)viewDidDisappear{
	_loaderView.hidden = false;
}
-(void)updateBid{
	AppDelegate*app = (AppDelegate*)[NSApplication sharedApplication].delegate;
	_bid.stringValue = [NSString stringWithFormat:@"$%ld", app.bidAmount];
	_cash.stringValue = [NSString stringWithFormat:@"$%ld", app.totalCash];
}
-(void)showDealView{
	[self resetBid];
	_dealBox.hidden = false;
	//    AppDelegate*app = (AppDelegate*)[NSApplication sharedApplication].delegate;
	//    [app.tView setSelectedTabViewItemIndex:0];
}
-(void)finish{
	_isFinished = true;
	[self performSelector:@selector(showDealView) withObject:nil afterDelay:3];
}

-(void)resetBid{
	AppDelegate*app = (AppDelegate*)[NSApplication sharedApplication].delegate;
	app.bidAmount = 0;
	_bid_amount = 0;
	[self updateDealBid];
}
-(IBAction)resetBid:(id)sender{
	AppDelegate*app = (AppDelegate*)[NSApplication sharedApplication].delegate;
	app.totalCash = app.totalCash + _bid_amount;
	_bid_amount = 0;
	[self updateDealBid];
}
-(void)updateDealBid{
	if (_bid_amount > 0) {
		_dealBtn.enabled = true;
	}else{
		_dealBtn.enabled = false;
	}
	AppDelegate*app = (AppDelegate*)[NSApplication sharedApplication].delegate;
	app.bidAmount = _bid_amount;
	_bid.stringValue = [NSString stringWithFormat:@"$%ld", _bid_amount];
	_cash.stringValue = [NSString stringWithFormat:@"$%ld", app.totalCash];
}
-(IBAction)bidAction:(id)sender{
	_bid_amount += [sender tag];
	AppDelegate*app = (AppDelegate*)[NSApplication sharedApplication].delegate;
	app.totalCash -= [sender tag];
	[self updateDealBid];
}

-(IBAction)dealAction:(id)sender{
	_dealBox.hidden = true;
	_isFinished = false;
	_doubleBtn.enabled = true;
	_standBtn.enabled = true;
	_hitBtn.enabled = true;
	
	_doubleBtn.hidden = false;
	_standBtn.hidden = false;
	_hitBtn.hidden = false;
	
	_dlResultContainer.hidden = true;
	_plResultContainer.hidden = true;
	_dlTotalContainer.hidden = true;
	_isStand = false;
	_pCards = [[NSMutableArray alloc] init];
	_dCards = [[NSMutableArray alloc] init];
	NSOperationQueue*q = [[NSOperationQueue alloc] init];
	[q addOperationWithBlock:^{
		[self.bj reset];
		[self.bj throughCards];
		dispatch_async(dispatch_get_main_queue(), ^(void){
			[self updatePlayerCards];
			[self updateDealerCards];
			[self checkIfBJ];
		});
	}];
}
-(IBAction)hitAction:(id)sender{
	[_bj hit];
	[self updatePlayerCards];
}
-(IBAction)standAction:(id)sender{
	[_bj stand];
	_isStand = true;
	[self updateDealerCards];
	[self checkStandResults];
}
-(IBAction)doubleAction:(id)sender{
	_doubleBtn.hidden = true;
	_hitBtn.enabled = false;
	_standBtn.enabled = false;
	AppDelegate*app = (AppDelegate*)[NSApplication sharedApplication].delegate;
	app.bidAmount = app.bidAmount*2;
	[self updateBid];
	[self hitAction:sender];
	if (!_isFinished) {
		[self standAction:sender];
	}
}
-(void)removeCards:(NSArray*)cards{
	for(id card in cards){
		[card removeFromParentViewController];
	}
}
-(void)updatePlayerCards{
	[self removeCards:_pCards];
	[_pCards removeAllObjects];
	for(NSString*c in [_bj.playerCards objectAtIndex:1]){
		[self addPlayerCard:c];
	}
	_pTotal.stringValue = [NSString stringWithFormat:@"%i", [_bj getTotal:[_bj.playerCards objectAtIndex:1]]];
	[self drawPlayerCards];
	[self checkPlayerResult];
}
-(void)updateDealerCards{
	[self removeCards:_dCards];
	[_dCards removeAllObjects];
	for(NSString*c in [_bj.playerCards objectAtIndex:0]){
		[self addDealerCard:c];
	}
	_dTotal.stringValue = [NSString stringWithFormat:@"%i", [_bj getTotal:[_bj.playerCards objectAtIndex:0]]];
	[self drawDealerCards];
}
-(void)checkIfBJ{
	
	NSArray*ppcs = [_bj.playerCards objectAtIndex:1];
	int p_ttl = [_bj getTotal:ppcs];
	
	NSArray*dpcs = [_bj.playerCards objectAtIndex:0];
	int d_ttl = [_bj getTotal:dpcs];
	
	if (d_ttl == 21 && p_ttl != 21) {
		_dlResultContainer.hidden = false;
		_dlTotalContainer.hidden = false;
		_dResult.stringValue = @"BlackJack!";
		_pResult.stringValue = @"Lost!";
		[self lost];
		[self finish];
	}else if(p_ttl == 21 && d_ttl != 21) {
		_plResultContainer.hidden = false;
		_pResult.stringValue = @"BlackJack!";
		[self won];
		[self finish];
	}else if(p_ttl == 21 && d_ttl == 21) {
		_plResultContainer.hidden = false;
		_pResult.stringValue = @"Pushed!";
		[self push];
		[self finish];
	}
}
-(void)checkPlayerResult{
	NSArray*ppcs = [_bj.playerCards objectAtIndex:1];
	int p_ttl = [_bj getTotal:ppcs];
	
	NSArray*dpcs = [_bj.playerCards objectAtIndex:0];
	int d_ttl = [_bj getTotal:dpcs];
	
	if (p_ttl > 21) {
		_pResult.stringValue = @"Busted!";
		[self lost];
		[self finish];
	}else if (p_ttl == 21 && d_ttl == 21) {
		_dlTotalContainer.hidden = false;
		_pResult.stringValue = @"Pushed!";
		[self push];
		[self finish];
	}else if (p_ttl == 21) {
		_pResult.stringValue = @"Won!";
		[self won];
		[self finish];
	}
}
-(void)lost{
	_doubleBtn.hidden = true;
	_standBtn.hidden = true;
	_hitBtn.hidden = true;
	
	_plResultContainer.hidden = false;
	_plResultContainer.fillColor = [NSColor colorWithRed:0.5 green:0 blue:0 alpha:0.8];
}
-(void)won{
	_doubleBtn.hidden = true;
	_standBtn.hidden = true;
	_hitBtn.hidden = true;
	
	_plResultContainer.hidden = false;
	_plResultContainer.fillColor = [NSColor colorWithRed:0 green:0.5 blue:0 alpha:0.8];
	AppDelegate*app = (AppDelegate*)[NSApplication sharedApplication].delegate;
	app.totalCash += app.bidAmount*2;
	[self updateBid];
}
-(void)push{
	_doubleBtn.hidden = true;
	_standBtn.hidden = true;
	_hitBtn.hidden = true;
	
	_plResultContainer.hidden = false;
	_plResultContainer.fillColor = [NSColor colorWithRed:0.5 green:0.5 blue:0 alpha:0.8];
	AppDelegate*app = (AppDelegate*)[NSApplication sharedApplication].delegate;
	app.totalCash += app.bidAmount;
	[self updateBid];
}
-(void)checkStandResults{
	
	if (_isFinished) {
		return;
	}
	
	_dlTotalContainer.hidden = false;
	
	NSArray*dpcs = [_bj.playerCards objectAtIndex:0];
	int d_ttl = [_bj getTotal:dpcs];
	
	NSArray*ppcs = [_bj.playerCards objectAtIndex:1];
	int p_ttl = [_bj getTotal:ppcs];
	
	int prv = 21 - p_ttl;
	int drv = 21 - d_ttl;
	
	if (d_ttl > 21) {
		_pResult.stringValue = @"Won!";
		[self won];
		[self finish];
	}else if(d_ttl == p_ttl){
		_pResult.stringValue = @"Pushed!";
		[self lost];
		[self finish];
	}else if (d_ttl == 21) {
		_pResult.stringValue = @"Lost!";
		[self lost];
		[self finish];
	}else if(drv < prv){
		_pResult.stringValue = @"Lost!";
		[self lost];
		[self finish];
	}
}

-(void)drawPlayerCards{
	CGFloat sw = CARD_SIDE_WIDTH;
	CGFloat pw = ((_pCards.count - 1) * sw) + 69;
	_plWidth.constant = pw;
	
	CGFloat x = 0;
	for(CardViewController*card in _pCards){
		[_plContainer.contentView addSubview:card.view];
		card.view.frame = CGRectMake(x, 0, 69, 100);
		[card showCard];
		x += sw;
	}
}
-(void)drawDealerCards{
	CGFloat sw = CARD_SIDE_WIDTH;
	CGFloat pw = ((_dCards.count - 1) * sw) + 69;
	_dlWidth.constant = pw;
	
	CGFloat x = 0;
	BOOL isFirst = false;
	for(CardViewController*card in _dCards){
		[_dlContainer.contentView addSubview:card.view];
		card.view.frame = CGRectMake(x, 0, 69, 100);
		if (!isFirst || _isStand) {
			[card showCard];
			isFirst = true;
		}
		
		x += sw;
	}
}
-(void)addPlayerCard:(NSString*)c{
	CardViewController*card = [self getCard:c];
	[_pCards addObject:card];
	[self addChildViewController:card];
}
-(void)addDealerCard:(NSString*)c{
	CardViewController*card = [self getCard:c];
	[_dCards addObject:card];
	[self addChildViewController:card];
}
-(CardViewController*)getCard:(NSString*)c{
	NSStoryboard *sb = [NSStoryboard storyboardWithName:@"Main" bundle:nil];
	CardViewController*card = [sb instantiateControllerWithIdentifier:@"CardViewController"];
	card.card = c;
	return card;
}
@end
