//
//  Created by Luka Gabrić.
//  Copyright (c) 2013 Luka Gabrić. All rights reserved.
//

@import QuartzCore;
#import "LPlaceholderTextView.h"
@implementation LPlaceholderTextView
#pragma mark - init & dealloc
-(instancetype)initWithCoder:(nonnull NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self initialize];
    }
    return self;
}
-(instancetype)init{
    self = [super init];
    if(self){
        [self initialize];
    }
    return self;
}
-(void)initialize{
    _placeholderColor = [UIColor lightGrayColor];
    [self layoutGUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleCursor) name:UITextViewTextDidEndEditingNotification object:self];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Notification Center
-(void)textChanged:(nonnull NSNotification *)notification{
    if(notification.object == self){
        [self layoutGUI];
    }
}
#pragma mark - layoutGUI
-(void)layoutGUI{
    _placeholderLabel.textAlignment = NSTextAlignmentCenter;
    _placeholderLabel.frame = CGRectMake((self.frame.size.width / 2) - (_placeholderLabel.frame.size.width / 2), (self.frame.size.height / 2) - (_placeholderLabel.frame.size.height / 2), _placeholderLabel.frame.size.width, _placeholderLabel.frame.size.height);
    _placeholderLabel.alpha = [self.text length] > 0 || [_placeholderText length] == 0 ? 0 : 1;
}
#pragma mark - Setters
-(void)setText:(nonnull NSString *)text{
    [super setText:text];
    [self layoutGUI];
}
-(void)setPlaceholderText:(nullable NSString*)placeholderText{
	_placeholderText = placeholderText;
	[self setNeedsDisplay];
}
-(void)setPlaceholderColor:(nonnull UIColor*)color{
	_placeholderColor = color;
	[self setNeedsDisplay];
}
#pragma mark - drawRect
-(void)drawRect:(CGRect)rect{
    if ([_placeholderText length] > 0){
        if (!_placeholderLabel){
            _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 8, self.bounds.size.width - 16, 0)];
            _placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            _placeholderLabel.numberOfLines = 0;
            _placeholderLabel.font = self.font;
            _placeholderLabel.backgroundColor = [UIColor clearColor];
            _placeholderLabel.alpha = 0;
            [self addSubview:_placeholderLabel];
        }
        _placeholderLabel.text = _placeholderText;
        _placeholderLabel.textColor = _placeholderColor;
        [_placeholderLabel sizeToFit];
        [self sendSubviewToBack:_placeholderLabel];
    }
    [self layoutGUI];
    [super drawRect:rect];
}
#pragma mark - Custom Additions
-(void)toggleCursor{
    if(self.isEditable){
        self.editable = NO;
    }
    else{
        self.editable = YES;
    }
}
-(void)touchesEnded:(nonnull NSSet *)touches withEvent:(nonnull UIEvent *)event{
    [self toggleCursor];
    [self becomeFirstResponder];
}
@end