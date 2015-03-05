//
//  Created by Luka Gabrić.
//  Copyright (c) 2013 Luka Gabrić. All rights reserved.
//

@import UIKit;
@interface LPlaceholderTextView : UITextView{
    UILabel *_placeholderLabel;
}
@property (strong, nonatomic, nullable) NSString *placeholderText;
@property (strong, nonatomic, nonnull) UIColor *placeholderColor;
-(void)toggleCursor;
@end