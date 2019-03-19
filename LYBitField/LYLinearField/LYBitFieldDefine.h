//
//  LYBitFieldDefine.h
//  LYBitField
//
//  Created by 刘宇 on 2019/3/19.
//  Copyright © 2019 刘宇. All rights reserved.
//

#ifndef LYBitFieldDefine_h
#define LYBitFieldDefine_h

#define CBColorRGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

/**
 cell的状态

 - LYBitCellStateUnEdit: 未编辑状态
 - LYBitCellStateEditing: 正在编辑状态
 - LYBitCellStateEdited: 已经编辑状态
 */
typedef NS_ENUM(NSUInteger, LYBitCellState) {
    LYBitCellStateUnEdit,
    LYBitCellStateEditing,
    LYBitCellStateEdited,
};

/**
 cell样式
 
 - LYLinearCellStyleBorder: 边框
 - LYLinearCellStyleUnderLine: 下划线
 - LYLinearCellStyleNoBorderAndUnderLine: 既无边框也无下划线
 */
typedef NS_ENUM(NSUInteger, LYBitFieldStyle) {
    LYBitFieldStyleUnderLine,
    LYBitFieldStyleBorder,
    LYBitFieldStyleNoBorderAndUnderLine,
};

/**
 光标边框动画
 
 - LYLinearFieldBorderAnimationNo: 无动画
 - LYLinearFieldBorderAnimationFlash: 闪现动画
 - LYLinearFieldBorderAnimationZoom: 放大缩小动画
 - LYLinearFieldBorderAnimationShake: 晃动
 */
typedef NS_ENUM(NSUInteger, LYBitFieldBorderAnimation) {
    LYBitFieldBorderAnimationNo,
    LYBitFieldBorderAnimationFlash,
    LYBitFieldBorderAnimationZoom,
    LYBitFieldBorderAnimationShake,
};

#endif /* LYLinerFieldDefine_h */
