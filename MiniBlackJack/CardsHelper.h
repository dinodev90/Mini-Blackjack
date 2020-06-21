//
//  ShuffleHelper.h
//  Shuffler
//
//  Created by Dinesh Kumar Vyas on 22/04/19.
//  Copyright © 2019 Dinesh Kumar Vyas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CardsHelper : NSObject
@property(nonatomic, retain) NSArray*cards;
-(NSArray*)shuffle;
@end

NS_ASSUME_NONNULL_END
