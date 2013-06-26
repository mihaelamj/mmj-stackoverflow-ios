//
//  StackOFQuestionViewController.m
//  MMJStackiOSView
//
//  Created by Mihaela Mihaljević Jakić on 6/26/13.
//  Copyright (c) 2013 Token d.o.o. All rights reserved.
//

#import "StackOFQuestionViewController.h"
#import "MMJStackOverflowFetcher.h"

@interface StackOFQuestionViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *questionWebView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;

@end

@implementation StackOFQuestionViewController

- (void) setQuestion:(NSDictionary *)question
{
    _question = question;
    [self updateUI];
}

- (NSString *)questionBody
{
    return _questionBody ? _questionBody : @"?";
}

- (void)loadQuestionBody
{
    if (self.question) {        
        int qid = [self.question[SO_QUESTION_ID] intValue];
        
        [self.activitySpinner startAnimating];
        dispatch_queue_t downloadSOQueue = dispatch_queue_create("Question body downloader", NULL);
        
        dispatch_async(downloadSOQueue, ^{ //1. get in another thread
            
#pragma mark - Remove this line below - testing
            [NSThread sleepForTimeInterval:2.0];
            
            NSString *body = [MMJStackOverflowFetcher getQuestionBody:[NSString stringWithFormat:@"%d", qid]];
            //check if user clicked back, if we still have the same question
            if ([self.question[SO_QUESTION_ID] intValue] == qid) {
                dispatch_async(dispatch_get_main_queue(), ^{ // 2. do in main queue
                if (body) {
                    self.questionBody = body;
                    [self.questionWebView loadHTMLString:[self.questionBody description] baseURL:[NSURL URLWithString:@"about:none"]];
                }
                [self.activitySpinner stopAnimating];
            });            }
            
        });
    } else {
        self.questionBody = nil;
    }
}

- (void)updateUI
{
    NSLog(@"%@", self.question);
    
    self.navigationItem.title = self.question[SO_QUESTION_TITLE];
    [self loadQuestionBody];


    
    NSLog(@"%@", self.questionBody);
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
	//need to call updateUI, because when segue is calling setQuestion, IBOutlets are nil
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
