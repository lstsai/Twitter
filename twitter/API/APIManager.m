//
//  APIManager.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "APIManager.h"
#import "Tweet.h"

static NSString * const baseURLString = @"https://api.twitter.com";
static NSString * const consumerKey = @"R5MQXi2JQtxyTHQFm6oV07Vg3";
static NSString * const consumerSecret = @"4qVHgVhlr1NIPlpgehYd62xQYNq7v8pJi6M1r3p7ct5GIExDyU";

@interface APIManager()

@end

@implementation APIManager

+ (instancetype)shared {
    static APIManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    
    NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSString *key = consumerKey;
    NSString *secret = consumerSecret;
    // Check for launch arguments override
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"]) {
        key = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-key"];
    }
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"]) {
        secret = [[NSUserDefaults standardUserDefaults] stringForKey:@"consumer-secret"];
    }
    
    self = [super initWithBaseURL:baseURL consumerKey:key consumerSecret:secret];
    if (self) {
        
    }
    return self;
}

- (void)getHomeTimelineWithCompletion:(void(^)(NSArray *tweets, NSError *error))completion {
    
    [self GET:@"1.1/statuses/home_timeline.json?tweet_mode=extended"
        parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
            // Success
        NSLog(@"%@", tweetDictionaries);
            NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
            completion(tweets, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            // There was a problem
            completion(nil, error);
        }];
}
- (void)postStatusWithText:(NSString *)text completion:(void (^)(Tweet *, NSError *))completion{
    NSString *urlString = @"1.1/statuses/update.json";//resource URL
    NSDictionary *parameters = @{@"status": text};//the text of the status update
    
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];//create a tweet with the text of the status
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
- (void)favorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{

    NSString *urlString = @"1.1/favorites/create.json";//the endpoint
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
- (void)unfavorite:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{

    NSString *urlString = @"1.1/favorites/destroy.json";//the endpoint
    NSDictionary *parameters = @{@"id": tweet.idStr};
    [self POST:urlString parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
- (void)retweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{

    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/retweet/%@.json",tweet.idStr];//the endpoint
    [self POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
- (void)unretweet:(Tweet *)tweet completion:(void (^)(Tweet *, NSError *))completion{

    NSString *urlString = [NSString stringWithFormat:@"1.1/statuses/unretweet/%@.json",tweet.idStr];//the endpoint
    [self POST:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable tweetDictionary) {
        Tweet *tweet = [[Tweet alloc]initWithDictionary:tweetDictionary];
        completion(tweet, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completion(nil, error);
    }];
}
- (void)getUserProfile:(void (^)(User *, NSError *))completion{
    NSString *urlString = [NSString stringWithFormat:@"1.1/account/verify_credentials.json"];//the endpoint
    [self GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable userDictionary) {
            User *user = [[User alloc]initWithDictionary:userDictionary];
            completion(user, nil);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            completion(nil, error);
        }];
}
- (void)loadMoreTweetsWithCompletion:(Tweet* )lastTweet completion:(void(^)(NSArray *tweets, NSError *error))completion{
    //get 20 more tweets since the last tweet
    NSDictionary *parameters = @{@"max_id": lastTweet.idStr};
    [self GET:@"1.1/statuses/home_timeline.json?tweet_mode=extended"
    parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        // Success
    //NSLog(@"%@", tweetDictionaries);
        NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        completion(tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // There was a problem
        completion(nil, error);
    }];
}
- (void)getUserTimelineWithCompletion:(User* )user completion:(void(^)(NSArray *tweets, NSError *error))completion{
    NSDictionary *parameters = @{@"user_id": user.id_str};
    [self GET:@"1.1/statuses/user_timeline.json?tweet_mode=extended"
    parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable tweetDictionaries) {
        // Success
    //NSLog(@"%@", tweetDictionaries);
        NSMutableArray *tweets  = [Tweet tweetsWithArray:tweetDictionaries];
        completion(tweets, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // There was a problem
        completion(nil, error);
    }];
}


@end
