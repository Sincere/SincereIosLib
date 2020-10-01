//
//  ScTableViewController.m
//  fotocase
//
//  Created by Masamoto Miyata on 2012/12/05.
//  Copyright (c) 2012年 Masamoto Miyata. All rights reserved.
//

#import "ScEachDifferedCellTableViewController.h"

@interface ScEachDifferedCellTableViewController ()

@end

@implementation ScEachDifferedCellTableViewController

#pragma mark - private

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *data = [_sections objectAtIndex:section];
    
    NSString *title = [data objectForKey:@"title"];
    if(title != nil)
    {
        return title;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSDictionary *sectionData = [_sections objectAtIndex:section];
    NSArray *rows = [sectionData objectForKey:@"rows"];
    if(rows)
    {
        return [rows count];
    }
    else
    {
        NSString *selector = [NSString stringWithFormat:@"numberOfRowsIn%@Section", [sectionData objectForKey:@"name"]];
        NSNumber *count = (NSNumber *)[self performSelector:NSSelectorFromString(selector)];
        return [count integerValue];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *section = [_sections objectAtIndex:indexPath.section];
    NSDictionary *row = [[section objectForKey:@"rows"] objectAtIndex:indexPath.row];
    
    if(row != nil)
    {
        NSString *key = [[section objectForKey:@"name"] stringByAppendingString:[row objectForKey:@"name"]];
        NSString *selector = [NSString stringWithFormat:@"create%@Cell:", key];
        return (UITableViewCell *)[self performSelector:NSSelectorFromString(selector) withObject:@{@"tableView": tableView, @"section":section, @"row":row, @"indexPath":indexPath}];
    }
    else
    {
        NSString *key = [section objectForKey:@"name"];
        NSString *selector = [NSString stringWithFormat:@"create%@SectionCell:", key];
        return (UITableViewCell *)[self performSelector:NSSelectorFromString(selector) withObject:@{@"tableView": tableView, @"section":section, @"indexPath":indexPath}];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
