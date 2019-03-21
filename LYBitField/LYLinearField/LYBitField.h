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

@class LYBitCellAttributes;

typedef void(^LYBitListen)(LYBitCellAttributes *object, NSString *keypath, id value);

/**
 * cell的属性模型
 */
@interface LYBitCellAttributes : NSObject

/** 单框尺寸 */
@property (assign, nonatomic) CGSize cellSize;
/** 边框类型 */
@property (assign, nonatomic) LYBitFieldStyle style;
/** 边框宽度 下划线高度 */
@property (assign, nonatomic) CGFloat borderWidth;
/** 下划线宽度 */
@property (assign, nonatomic) CGFloat underLineWidth;
/** 边框|下划线 的圆角 */
@property (assign, nonatomic) CGFloat borderCorner;
/** 文本字体 */
@property (strong, nonatomic) UIFont *textFont;
/** 文本颜色 */
@property (strong, nonatomic) UIColor *textColor;
/** 边框颜色 */
@property (strong, nonatomic) UIColor *borderColor;
/** 光标颜色 */
@property (strong, nonatomic) UIColor *cursorColor;
/** cell背景颜色 */
@property (strong, nonatomic) UIColor *cellBackgroundColor;
/** 边框图片 */
@property (strong, nonatomic) UIImage *borderImage;
/** 下划线图片 */
@property (strong, nonatomic) UIImage *underLineImage;
/** 编辑状态 */
@property (assign, nonatomic) LYBitCellState editState;
/** 属性监听 */
@property (copy, nonatomic) LYBitListen listen;

- (void)printPropertiesLog;

@end


/**
 * 单个输入框
 */
@interface LYBitCell : UIView

/** 该框的属性对象 */
@property (strong, nonatomic) LYBitCellAttributes *attributes;
@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) void(^finishedBlock)(NSString *value);

@end


/**
 * 主控件
 */
@interface LYBitField : UIView

/** 未编辑框的属性 */
@property (strong, nonatomic, readonly) LYBitCellAttributes *unEditAttributes;
/** 正在编辑框的属性 */
@property (strong, nonatomic, readonly) LYBitCellAttributes *editingAttributes;
/** 已编辑框的属性 */
@property (strong, nonatomic, readonly) LYBitCellAttributes *editedAttributes;
/** 光标动画 */
@property (assign, nonatomic) LYBitFieldBorderAnimation cursorAnmation;
@property (strong, nonatomic) UIColor *cursorColor;
/** 框数量 */
@property (assign, nonatomic) NSInteger cellNumber;
/** 间距 */
@property (assign, nonatomic) CGFloat cellSpace;

@property (copy, nonatomic) void (^editingBlock)(NSString *value);

@end

NS_ASSUME_NONNULL_END
