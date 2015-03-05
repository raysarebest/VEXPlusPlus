//
//  FLLoadingView.m
//  VEX++
//
//  Created by Michael Hulet on 3/4/15.
//  Copyright (c) 2015 Michael Hulet. All rights reserved.
//

#import "FLLoadingView.h"
#import "FLColorScheme.h"
@interface FLLoadingView()
@property (strong, nonatomic, nonnull) UIActivityIndicatorView *spinner;
@end
@implementation FLLoadingView
#pragma mark - Initialization
-(instancetype)init{
    if(self = [super init]){
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.5];
        self.spinner.color = [FLColorScheme accentColor];
        [self addSubview:self.spinner];
        return self;
    }
    else{
        return nil;
    }
}
-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self = [self init];
        self.frame = frame;
        return self;
    }
    else{
        return nil;
    }
}
+(nonnull instancetype)createInView:(nonnull UIView *)view{
    FLLoadingView *loader = [[self alloc] init];
    [loader showInView:view];
    return loader;
}
#pragma mark - Showing/Hiding
-(void)showInView:(nonnull UIView *)view{
    self.frame = view.frame;
    self.spinner.center = self.center;
    [self.spinner startAnimating];
    [view addSubview:self];
}
-(void)hide{
    if(self.superview != nil){
        [self.spinner stopAnimating];
        [self removeFromSuperview];
    }
}
#pragma mark - Property Lazy Instantiation
-(nonnull UIActivityIndicatorView *)spinner{
    if(!_spinner){
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _spinner;
}
@end