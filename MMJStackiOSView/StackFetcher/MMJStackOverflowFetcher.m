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


//{
//    "items": [
//              {
//                  "question_id": 17320811,
//                  "last_edit_date": 1372252829,
//                  "creation_date": 1372251758,
//                  "last_activity_date": 1372252829,
//                  "score": 0,
//                  "answer_count": 1,
//                  "body": "<p>I'm confused with this <strong>NSFetchedResultsController</strong>…",
//                  "title": "NSFetchedResults not updating automatically",
//                  "tags": [
//                           "iphone",
//                           "ios",
//                           "objective-c",
//                           "nsfetchedresultscontrolle"
//                           ],
//                  "view_count": 12,
//                  "owner": {
//                      "user_id": 1833434,
//                      "display_name": "MichiZH",
//                      "reputation": 70,
//                      "user_type": "registered",
//                      "profile_image": "https://www.gravatar.com/avatar/1da6620d08d9017917972f8bce78039c?d=identicon&r=PG",
//                      "link": "http://stackoverflow.com/users/1833434/michizh",
//                      "accept_rate": 50
//                  },
//                  "link": "http://stackoverflow.com/questions/17320811/nsfetchedresults-not-updating-automatically",
//                  "is_answered": false
//              }
//}

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
//    NSDictionary *questionDict = [[self executeSOFetch:questionURL] valueForKeyPath:SO_ITEMS];
    NSDictionary *questionWithItemsDict = [self executeSOFetch:questionURL];
    NSArray *items = [questionWithItemsDict valueForKeyPath:SO_ITEMS];
    NSDictionary *questionDict = [items lastObject];
    
    NSLog(@"questionWithItemsDict: %@", questionWithItemsDict);    
    NSLog(@"items: %@", items);
    NSLog(@"questionDict: %@", questionDict);
    
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
//    return (NSDictionary *)[questions objectAtIndex:index]; // this would require weak pointer
    
}

+ (NSDictionary *)getQuestionOwner:(NSArray *)questions atIndex:(NSUInteger)index
{
    NSDictionary *owner = nil;
    NSDictionary *question = [self getQuestion:questions atIndex:index];
    if (question) owner = [question objectForKey:SO_QUESTION_OWNER];
    return owner;    
}



@end
