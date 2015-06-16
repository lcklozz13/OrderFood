//
//  ChangebleRoomsSelectionViewController.m
//  OrderFood
//
//  Created by aplle on 8/4/13.
//  Copyright (c) 2013 handcent. All rights reserved.
//

#import "ChangebleRoomsSelectionViewController.h"

@interface ChangebleRoomsSelectionViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) IBOutlet  UITableView     *tableView;
@property (nonatomic, retain) IBOutlet  UIButton        *closeBtn;
@property (nonatomic, retain) NSMutableArray            *dataArray;
@property (nonatomic, retain) NSString                  *roomId;
- (IBAction)closeAction:(id)sender;
@end

@implementation ChangebleRoomsSelectionViewController
@synthesize dataArray;
@synthesize closeBtn;
@synthesize tableView;
@synthesize didSelectAction;
@synthesize roomId;

- (void)dealloc
{
    self.dataArray = nil;
    self.closeBtn = nil;
    self.tableView = nil;
    self.didSelectAction = nil;
    self.roomId = nil;
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)closeAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString     *identifies = @"CellForChangeRoomView";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifies];
    
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifies] autorelease];
    }
    
    NSMutableArray *array = [dataArray objectAtIndex:indexPath.row];
    
    if ([array count] == 5)
    {
        [cell.textLabel setText:[array objectAtIndex:3]];
//        self.title = [array objectAtIndex:3];
//        [titleLab setText:title];
//        self.code = [curCellInfor objectAtIndex:2];
//        self.category = [curCellInfor objectAtIndex:4];
//        self.roomId = [curCellInfor objectAtIndex:1];
    }
    else if ([array count] == 4)
    {
        [cell.textLabel setText:[array objectAtIndex:2]];
//        self.title = [curCellInfor objectAtIndex:2];
//        [titleLab setText:title];
//        self.code = [curCellInfor objectAtIndex:1];
//        self.category = [curCellInfor objectAtIndex:3];
//        self.roomId = [curCellInfor objectAtIndex:0];
    }
    
    return nil;
}
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *array = [dataArray objectAtIndex:indexPath.row];
    NSString *roomName = nil;
        
    if ([array count] == 5)
    {
        self.roomId = [array objectAtIndex:1];
        roomName = [array objectAtIndex:3];
    }
    else if ([array count] == 4)
    {
        self.roomId = [array objectAtIndex:0];
        roomName = [array objectAtIndex:2];
    }
    
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"您确定要换到%@房间？", roomName] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [view show];
    [view release];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (didSelectAction)
        {
            didSelectAction(roomId);
        }
        
        [self.navigationController popViewControllerAnimated:NO];
    }
}
@end
