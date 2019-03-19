//
//  LYBitField.h
//  LYBitField
//
//  Created by 刘宇 on 2019/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LYBitFieldDefine.h"

NS_ASSUME_NONNULL_BEGIN

/**
 cell的属性模型
 */
@interface LYBitCellAttributes : NSObject

@property (assign, nonatomic) CGSize cellSize;
@property (assign, nonatomic) LYBitFieldStyle Style;
@property (assign, nonatomic) LYBitFieldBorderAnimation cursorAnmation;
@property (assign, nonatomic) CGFloat borderWidth;
@property (strong, nonatomic) UIFont *textFont;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *borderColor;

@end

@interface LYBitCell : UIView

@property (strong, nonatomic) LYBitCellAttributes *attributes;

@end

@interface LYBitField : UIView

@property (strong, nonatomic) LYBitCellAttributes *noEditAttributes;
@property (strong, nonatomic) LYBitCellAttributes *editingAttributes;
@property (strong, nonatomic) LYBitCellAttributes *editedAttributes;

@end

NS_ASSUME_NONNULL_END
