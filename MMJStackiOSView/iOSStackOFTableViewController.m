//
//  iOSStackOFTableViewController.m
//  MMJStackiOSView
//
//  Created by Mihaela Mihaljević Jakić on 6/26/13.
//  Copyright (c) 2013 Token d.o.o. All rights reserved.
//

#import "iOSStackOFTableViewController.h"
#import "MMJStackOverflowFetcher.h"

@interface iOSStackOFTableViewController ()

@end

@implementation iOSStackOFTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadLatestiOSSOQuestions];
    //set the target action in code for refreshControl, because it cannot be done in XCode
	[self.refreshControl addTarget:self
                            action:@selector(loadLatestiOSSOQuestions)
                  forControlEvents:(UIControlEventValueChanged)];
}

- (void)loadLatestiOSSOQuestions
{
    [self.refreshControl beginRefreshing];
    dispatch_queue_t loadSO= dispatch_queue_create("MMJStackOverflowFetcher latest questions", NULL);
    dispatch_async(loadSO, ^{
        //simulate long operation
        [NSThread sleepForTimeInterval:2.0];
        // make local variable to stay out of the UI
        NSArray *latestiOSQuestions = [MMJStackOverflowFetcher latestiOSQuestions];
        dispatch_async(dispatch_get_main_queue(), ^{
            // in the main queue set the self.photos because it affects the UI
            self.soQuestions = latestiOSQuestions;
            [self.refreshControl endRefreshing];
        });
    });
}


@end
