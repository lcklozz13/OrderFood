//
//  InquiryOrderViewController.m
//  OrderFood
//
//  Created by aplle on 8/3/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "InquiryOrderViewController.h"
#import "InquiryOrderCell.h"

@interface InquiryOrderViewController ()
{
    NSMutableArray      *foodListArray;
}
@property (nonatomic, retain) IBOutlet UIButton     *closeBtn;
@property (nonatomic, retain) IBOutlet UITableView  *tableView;
@property (nonatomic, retain) IBOutlet UIView       *headView;
@property (nonatomic, retain) InstructionParse      *curParse;
- (IBAction)closeAction:(id)sender;
@end

@implementation InquiryOrderViewController
@synthesize closeBtn;
@synthesize curParse;
@synthesize tableView;
@synthesize headView;

- (id)initWithResult:(InstructionParse *)result
{
    self = [super init];
    
    if (self)
    {
        self.curParse = result;
        foodListArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (IBAction)closeAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)dealloc
{
    self.closeBtn = nil;
    self.curParse = nil;
    [foodListArray removeAllObjects], [foodListArray release], foodListArray = nil;
    self.tableView = nil;
    self.headView = nil;
    
    [super dealloc];
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
    // Do any additional setup after loading the view from its nib.
    tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    int tag = 1;
    
    for (NSMutableArray *result in curParse.contents)
    {   
        if ([result count] > 1)
        {
            [foodListArray addObject:result];
        }
        else
        {
            UILabel *lab = (UILabel *)[self.view viewWithTag:tag++];
            
            [lab setText:[result objectAtIndex:0]];
        }
    }
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return headView.frame.size.height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [foodListArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifies = @"OrderListCell";
    
    InquiryOrderCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifies];
    
    if (!cell)
    {
        cell = [[[InquiryOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifies] autorelease];
    }
    
    cell.dataShow = [foodListArray objectAtIndex:indexPath.row];
    
    return cell;
}
@end
