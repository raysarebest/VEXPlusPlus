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
@property (strong, nonatomic, nonnull) NSMutableDictionary *layers;
-(void)underlineView:(UIView *)view animated:(BOOL)animated;
-(void)removeUnderlineFromView:(UIView *)view animated:(BOOL)animated;
@end
@implementation FLDetailViewController
#pragma mark - Custom Setters
-(void)setTeam:(FLTeam *)newTeam{
    if(_team != newTeam){
        _team = newTeam;
        if(!newTeam.robot){
            newTeam.robot = [FLRobot new];
        }
        // Update the view.
        __block FLLoadingView *const loader = [FLLoadingView createInView:self.view];
        if(newTeam.VEXID && ![newTeam.VEXID isEqualToString:@"????"]){
            self.navigationItem.title = newTeam.VEXID;
        }
        [newTeam.robot fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error){
            [loader hide];
            if(error){
                [self presentViewController:[FLUIManager defaultParseErrorAlertControllerForError:error defaultHandler:YES] animated:YES completion:nil];
            }
            else{
                if(newTeam.VEXID && ![newTeam.VEXID isEqualToString:@"????"]){
                    self.navigationItem.title = newTeam.VEXID;
                }
            }
        }];
        if(![newTeam.VEXID isEqualToString:@"????"]){
            [newTeam saveEventually];
        }
    }
}
#pragma mark - Computed Properties
-(FLMasterViewController *)masterViewController{
    return ((FLMasterViewController *)((UINavigationController *)self.splitViewController.viewControllers.firstObject).viewControllers.firstObject);
}
#pragma mark - Property Lazy Instantiation
-(NSMutableDictionary *)layers{
    if(!_layers){
        _layers = [NSMutableDictionary dictionary];
    }
    return _layers;
}
#pragma mark - Private Helper Methods
-(void)viewDidLoad{
    [super viewDidLoad];
    UILabel *newView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    newView.text = @"Test Label";
    newView.center = self.view.center;
    //[self underlineView:newView animated:NO];
    [self.view addSubview:newView];
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[UIScrollView class]]){
            [view removeFromSuperview];
        }
//        if([view isKindOfClass:[UILabel class]]){
//            [self underlineView:view animated:NO];
//        }
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[UILabel class]]){
            [self underlineView:view animated:YES];
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[UILabel class]]){
            [self removeUnderlineFromView:view animated:YES];
        }
    }
}
-(void)underlineView:(UIView *)view animated:(BOOL)animated{
    CALayer *underline = [CALayer layer];
    CGFloat underlineHeight = 2;
    underline.borderColor = [FLUIManager accentColor].CGColor;
    underline.frame = CGRectMake(0, view.frame.size.height - underlineHeight, view.frame.size.width, view.frame.size.height);
    underline.borderWidth = underlineHeight;
    if(animated){
        underline.opacity = 0;
    }
    [view.layer addSublayer:underline];
    view.layer.masksToBounds = YES;
    if(animated){
        CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeIn.duration = .1;
        fadeIn.toValue = @1;
        [underline addAnimation:fadeIn forKey:@"opacity"];
        underline.opacity = 1;
    }
}
-(void)removeUnderlineFromView:(UIView *)view animated:(BOOL)animated{
    if(view.layer.sublayers.count > 0){
        CALayer *underline = view.layer.sublayers.firstObject;
        if(animated){
            [underline removeAllAnimations];
            CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
            fadeOut.duration = .1;
            fadeOut.toValue = @0;
            fadeOut.delegate = self;
            self.layers[fadeOut] = underline;
            [underline addAnimation:fadeOut forKey:@"opacity"];
            underline.opacity = 0;
        }
        else{
            [underline removeFromSuperlayer];
        }
    }
}
#pragma mark - Animation Delegation
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"%@", self.layers[anim]);
    [(CALayer *)self.layers[anim] removeFromSuperlayer];
    for(UIView *view in self.view.subviews){
        if([view isKindOfClass:[UILabel class]]){
            NSLog(@"%ld", (unsigned long)view.layer.sublayers.count);
        }
    }
}
@end