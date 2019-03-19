//
//  LYLinerFieldDefine.h
//  LYUnitField
//
//  Created by admin on 2019/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

#ifndef LYBitFieldDefine_h
#define LYBitFieldDefine_h

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
