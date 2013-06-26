//
//  MMJStackOverflowFetcher.h
//  MMJStackiOSView
//
//  Created by Mihaela Mihaljević Jakić on 6/25/13.
//  Copyright (c) 2013 Token d.o.o. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SO_ITEMS @"items"
#define SO_QUESTION_TITLE @"title"
#define SO_QUESTION_LINK @"link"
#define SO_QUESTION_OWNER @"owner"
#define SO_QUESTION_OWNER_NAME @"display_name"
#define SO_QUESTION_OWNER_REP @"reputation"
#define SO_QUESTION_BODY @"body"
#define SO_QUESTION_ID @"question_id"


@interface MMJStackOverflowFetcher : NSObject

+ (NSDictionary *)executeSOFetch;
+ (NSDictionary *)executeSOFetch:(NSString *)URL;

+ (NSArray *)latestiOSQuestions;

+ (NSDictionary *)getQuestion:(NSArray *)questions atIndex:(NSUInteger)index;

+ (NSDictionary *)getQuestionOwner:(NSArray *)questions atIndex:(NSUInteger)index;

+ (NSDictionary *)getQuestionWithBody:(NSString *)questionID;

+ (NSString *)getQuestionBody:(NSString *)questionID;

@end
