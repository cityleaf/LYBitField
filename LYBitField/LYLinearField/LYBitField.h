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
@property (assign, nonatomic) LYBitFieldStyle style;
@property (assign, nonatomic) CGFloat borderWidth;
@property (assign, nonatomic) CGFloat underLineWidth;
@property (strong, nonatomic) UIFont *textFont;
@property (strong, nonatomic) UIColor *textColor;
@property (strong, nonatomic) UIColor *borderColor;
@property (strong, nonatomic) UIImage *borderImage;
@property (strong, nonatomic) UIImage *underLineImage;
@property (assign, nonatomic) LYBitCellState editState;

@end

@interface LYBitCell : UIView

@property (strong, nonatomic) LYBitCellAttributes *attributes;

@end

@interface LYBitField : UIView

@property (strong, nonatomic) LYBitCellAttributes *unEditAttributes;
@property (strong, nonatomic) LYBitCellAttributes *editingAttributes;
@property (strong, nonatomic) LYBitCellAttributes *editedAttributes;

@property (assign, nonatomic) LYBitFieldBorderAnimation cursorAnmation;

@property (assign, nonatomic) NSInteger cellNumber;

@end

NS_ASSUME_NONNULL_END
