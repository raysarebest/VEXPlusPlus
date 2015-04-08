//
//  DetailViewController.h
//  VEX++
//
//  Created by Michael Hulet on 2/24/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

@import UIKit;
@class FLTeam;
@interface FLDetailViewController : UIViewController
@property (strong, nonatomic, nonnull) FLTeam *team;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *detailDescriptionLabel;
@end