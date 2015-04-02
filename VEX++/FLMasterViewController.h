//
//  MasterViewController.h
//  VEX++
//
//  Created by Michael Hulet on 2/24/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

@import UIKit;
@class FLDetailViewController;
@interface FLMasterViewController : UITableViewController
@property (strong, nonatomic, nonnull) FLDetailViewController *detailViewController;
@end