//
//  Tweet.h
//  twitter
//
//  Created by laurentsai on 6/29/20.
//  Copyright © 2020 Emerson Malca. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"


NS_ASSUME_NONNULL_BEGIN

@interface Tweet : NSObject

// MARK: Properties
@property (nonatomic, strong) NSString *idStr; // For favoriting, retweeting & replying
@property (nonatomic, strong) NSString *text; // Text content of tweet
@property (nonatomic) int favoriteCount; // Update favorite count label
@property (nonatomic) BOOL favorited; // Configure favorite button
@property (nonatomic) int retweetCount; // Update retweet count label
@property (nonatomic) BOOL retweeted; // Configure retweet button
@property (nonatomic, strong) User *user; // Contains Tweet author's name, screenname, etc.
@property (nonatomic, strong) NSString *createdAtString; // Display date
@property (nonatomic, strong) NSString *timeAgo; // Display date
@property (nonatomic, strong) NSString *timeStamp; // Display date
@property (nonatomic) int replyCount; // Update reply count label
@property (nonatomic, strong) NSURL *mediaUrl;
@property (nonatomic) double mediaRatio;


// For Retweets
@property (nonatomic, strong) User *retweetedByUser;  // user who retweeted if tweet is retweet

// MARK: Methods
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
