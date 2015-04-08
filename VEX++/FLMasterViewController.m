//
//  MasterViewController.m
//  VEX++
//
//  Created by Michael Hulet on 2/24/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLMasterViewController.h"
#import "FLDetailViewController.h"
#import "FLLoadingView.h"
#import "FLUIManager.h"
@import VEXKit;
@import Parse;
@interface FLMasterViewController()
@property (strong, nonatomic, nonnull) NSMutableArray *teams;
-(void)sortTableViewByVEXID;
@end
@implementation FLMasterViewController
#pragma mark - View Setup Code
-(void)awakeFromNib{
    [super awakeFromNib];
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        //So the UITableViewCell remains selected on iPad in Portrait Mode
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}
-(void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (FLDetailViewController *)[self.splitViewController.viewControllers.lastObject topViewController];
    self.refreshControl = [UIRefreshControl new];
    self.refreshControl.tintColor = [FLUIManager accentColor];
    [self.refreshControl addTarget:self action:@selector(updateTableViewData:) forControlEvents:UIControlEventValueChanged];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - IBActions
-(IBAction)logOut:(UIBarButtonItem *)sender{
    //Show the loading view
    __block FLLoadingView *loader = [FLLoadingView createInView:self.splitViewController.view];
    //logOutInBackgroundWithBlock: has an NSUnderlyingError in Parse 1.7.1, so we have to do it the old-fashioned way
    [PFUser logOut];
    [FLUIManager presentLoginSceneAnimated:YES inLaunchingState:NO completion:^{
        [loader hide];
    }];
}
#pragma mark - Data Manipulation
-(IBAction)newTeam{
    [self.teams insertObject:[FLTeam new] atIndex:0];
    NSIndexPath *const firstIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[firstIndex] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView selectRowAtIndexPath:firstIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}
-(void)updateTableViewData:(id)context{
    //TODO: Prioritize the cache on app launch
    PFQuery *allData = [PFQuery queryWithClassName:[FLTeam parseClassName]];
    __block NSInteger calls;
    if(self.refreshControl.refreshing){
        allData.cachePolicy = kPFCachePolicyCacheThenNetwork;
        calls = 1;
    }
    else{
        allData.cachePolicy = kPFCachePolicyCacheOnly;
        calls = 2;
    }
    allData.limit = 1000;
    [self.teams removeAllObjects];
    [allData findObjectsInBackgroundWithBlock:^(NSArray *teams, NSError *error){
        //Only update everything when it's done with the network
        [self.teams addObjectsFromArray:teams];
        if(calls == 1){
            calls++;
        }
        else{
            if(self.refreshControl.refreshing){
                [self.refreshControl endRefreshing];
            }
            if(error && error.code != kPFErrorCacheMiss){
                [self presentViewController:[FLUIManager defaultParseErrorAlertControllerForError:error defaultHandler:YES] animated:YES completion:nil];
            }
            else{
                if([context isKindOfClass:[FLLoadingView class]]){
                    [(FLLoadingView *)context hide];
                }
                [self sortTableViewByVEXID];
                [self.tableView reloadData];
            }
        }
    }];
}
#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        FLTeam *team = self.teams[indexPath.row];
        NSLog(@"%@", team);
        FLDetailViewController *controller = (FLDetailViewController *)[segue.destinationViewController topViewController];
        controller.team = team;
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        controller.navigationItem.rightBarButtonItem = self.splitViewController.editButtonItem;
    }
    [super prepareForSegue:segue sender:sender];
}
#pragma mark - UITableViewDelegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.teams.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    FLTeam *team = self.teams[indexPath.row];
    cell.textLabel.text = team.nickname;
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.teams removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if(editingStyle == UITableViewCellEditingStyleInsert){
        //Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [FLUIManager backgroundColor];
}
#pragma mark - Property Lazy Instantiation
-(NSMutableArray *)teams{
    if(!_teams){
        _teams = [NSMutableArray array];
    }
    return _teams;
}
#pragma mark - Helper Methods
-(void)sortTableViewByVEXID{
    self.teams = [self.teams sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"VEXID" ascending:YES selector:@selector(caseInsensitiveCompare:)]]].mutableCopy;
}
@end