//
//  StackOFTableViewController.m
//  MMJStackiOSView
//
//  Created by Mihaela Mihaljević Jakić on 6/26/13.
//  Copyright (c) 2013 Token d.o.o. All rights reserved.
//

#import "StackOFTableViewController.h"
#import "MMJStackOverflowFetcher.h"

@interface StackOFTableViewController ()

@end

@implementation StackOFTableViewController

- (void)setSoQuestions:(NSArray *)soQuestions
{
    _soQuestions = soQuestions;
    [self.tableView reloadData];
}


- (NSString *)titleForRow:(NSUInteger)row
{
    NSLog(@"%@", self.soQuestions[row]);
    return [self.soQuestions[row][SO_QUESTION_TITLE] description]; // description because could be NSNull
}

- (NSString *)subtitleForRow:(NSUInteger)row
{
    NSDictionary *owner = [MMJStackOverflowFetcher getQuestion:self.soQuestions atIndex:row];
    if (owner) {
        NSLog(@"owner: %@", owner[SO_QUESTION_OWNER][SO_QUESTION_OWNER_NAME]);
        NSLog(@"rep: %d", (int)[owner[SO_QUESTION_OWNER][SO_QUESTION_OWNER_REP] intValue]);
        return [NSString stringWithFormat:@"%@ : %d", owner[SO_QUESTION_OWNER][SO_QUESTION_OWNER_NAME], (int)[owner[SO_QUESTION_OWNER][SO_QUESTION_OWNER_REP] intValue]]; // 
    }
    return @"unknown";
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.soQuestions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SOQuestionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self titleForRow:indexPath.row];
    cell.detailTextLabel.text = [self subtitleForRow:indexPath.row];    
    return cell;
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"ShowQuestion"]) {
                if ([segue.destinationViewController respondsToSelector:@selector(setQuestion:)]) {
                    NSDictionary *question = [MMJStackOverflowFetcher getQuestion:self.soQuestions atIndex:indexPath.row];
                    [segue.destinationViewController performSelector:@selector(setQuestion:) withObject:question];
                }
            }
        }
    }
}

@end
