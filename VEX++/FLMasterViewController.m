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
@import Parse;
@interface FLMasterViewController()
@property (strong, nonatomic, nonnull) NSMutableArray *objects;
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
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.detailViewController = (FLDetailViewController *)[self.splitViewController.viewControllers.lastObject topViewController];
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
#pragma mark - IBActions
-(IBAction)logOut:(UIBarButtonItem *)sender{
    //A super hacky way to hide the master view controller
    if([FLUIManager sizeIsPortrait:self.splitViewController.view.frame.size] && [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad){
        UIBarButtonItem *const button = self.splitViewController.displayModeButtonItem;
        [[UIApplication sharedApplication] sendAction:button.action to:button.target from:self forEvent:nil];
    }
    //Show the loading view
    FLLoadingView *loader = [FLLoadingView createInView:self.splitViewController.view];
    //Log out
    [PFUser logOutInBackgroundWithBlock:^(NSError *error){
        if(error){
            [loader hide];
            [self.splitViewController presentViewController:[FLUIManager defaultParseErrorAlertControllerForError:error defaultHandler:YES] animated:YES completion:nil];
        }
        else{
            [FLUIManager presentLoginSceneAnimated:YES inLaunchingState:NO completion:^{
                [loader hide];
            }];
        }
    }];
}
#pragma mark - Editing
-(void)insertNewObject:(id)sender{
    [self.objects insertObject:[NSDate date] atIndex:0];
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark - Segues
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier isEqualToString:@"showDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = self.objects[indexPath.row];
        FLDetailViewController *controller = (FLDetailViewController *)[segue.destinationViewController topViewController];
        [controller setDetailItem:object];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        controller.navigationItem.rightBarButtonItem = self.splitViewController.editButtonItem;
    }
}
#pragma mark - UITableViewDelegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.objects.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    NSDate *object = self.objects[indexPath.row];
    cell.textLabel.text = object.description;
    return cell;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else if(editingStyle == UITableViewCellEditingStyleInsert){
        //Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
#pragma mark - Property Lazy Instantiation
-(NSMutableArray *)objects{
    if(!_objects){
        _objects = [NSMutableArray array];
    }
    return _objects;
}
@end