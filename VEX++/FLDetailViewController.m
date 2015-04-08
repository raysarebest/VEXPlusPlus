//
//  DetailViewController.m
//  VEX++
//
//  Created by Michael Hulet on 2/24/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLDetailViewController.h"
#import "FLMasterViewController.h"
#import "FLUIManager.h"
#import "FLLoadingView.h"
@import VEXKit;
@interface FLDetailViewController()
@property (strong, nonatomic, nonnull, readonly) FLMasterViewController *masterViewController;
@end
@implementation FLDetailViewController
#pragma mark - Managing the detail item
-(void)setTeam:(FLTeam *)newTeam{
    if(_team != newTeam){
        _team = newTeam;
        if(!newTeam.robot){
            newTeam.robot = [FLRobot new];
        }
        // Update the view.
        __block FLLoadingView *const loader = [FLLoadingView createInView:self.view];
        [newTeam.robot fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
            if(error){
                [loader hide];
                [self presentViewController:[FLUIManager defaultParseErrorAlertControllerForError:error defaultHandler:YES] animated:YES completion:nil];
            }
            else{
                [self configureView];
                [loader hide];
            }
        }];
    }
}
-(void)configureView{
    // Update the user interface for the detail item.
    if(self.team){
        self.detailDescriptionLabel.text = self.team.description;
    }
}
-(void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}
#pragma mark - Computed Properties
-(FLMasterViewController *)masterViewController{
    return ((FLMasterViewController *)((UINavigationController *)self.splitViewController.viewControllers.firstObject).viewControllers.firstObject);
}
@end