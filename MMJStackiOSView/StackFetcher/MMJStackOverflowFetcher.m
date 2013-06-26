//
//  MMJStackOverflowFetcher.m
//  MMJStackiOSView
//
//  Created by Mihaela Mihaljević Jakić on 6/25/13.
//  Copyright (c) 2013 Token d.o.o. All rights reserved.
//

#import "MMJStackOverflowFetcher.h"

#define STACKOVERFLOW_URL @"https://api.stackexchange.com/2.1/questions?order=desc&min=10&sort=creation&tagged=iOS&site=stackoverflow"

#define STACKOVERFLOW_QUESTION_URL @"http://api.stackexchange.com/2.1/questions/%@?order=desc&sort=activity&site=stackoverflow&filter=!9hnGsr.M2"

@implementation MMJStackOverflowFetcher

+ (NSDictionary *)executeSOFetch:(NSString *)URL
{
    NSLog(@"fetching %@", URL);
    NSData *jsonData = [[NSString stringWithContentsOfURL:[NSURL URLWithString:URL] encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    
    NSDictionary *results = jsonData ? [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves error:&error] : nil;
    
    if (error) NSLog(@"[%@ %@] JSON error: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), error.localizedDescription);
    
    NSLog(@"got data from StackOverflow\n%@", results);
    
    return results;
}

+ (NSDictionary *)executeSOFetch
{
    return [self executeSOFetch:STACKOVERFLOW_URL];
}

+ (NSArray *)latestiOSQuestions
{
    return [[self executeSOFetch] valueForKeyPath:SO_ITEMS];
}

+ (NSDictionary *)getQuestionWithBody:(NSString *)questionID
{
    NSString *questionURL = [NSString stringWithFormat:STACKOVERFLOW_QUESTION_URL, questionID];
    NSDictionary *questionWithItemsDict = [self executeSOFetch:questionURL];   
    return [[questionWithItemsDict valueForKeyPath:SO_ITEMS] lastObject];
}

+ (NSString *)getQuestionBody:(NSString *)questionID
{
    NSString *body = @"?";
    NSDictionary *question = [self getQuestionWithBody:questionID];
    if (question) {
        body = [question[SO_QUESTION_BODY] description];
    }
    return body;
}

+ (NSDictionary *)getQuestion:(NSArray *)questions atIndex:(NSUInteger)index
{
    return [NSDictionary dictionaryWithDictionary:[questions objectAtIndex:index]];  
}

+ (NSDictionary *)getQuestionOwner:(NSArray *)questions atIndex:(NSUInteger)index
{
    NSDictionary *owner = nil;
    NSDictionary *question = [self getQuestion:questions atIndex:index];
    if (question) owner = [question objectForKey:SO_QUESTION_OWNER];
    return owner;    
}



@end
