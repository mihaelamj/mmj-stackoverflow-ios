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
    self.soQuestions = [MMJStackOverflowFetcher latestiOSQuestions];
}


@end
