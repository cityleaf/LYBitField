//
//  LYBitField.m
//  LYBitField
//
//  Created by 刘宇 on 2019/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "LYBitField.h"
#import "LYViewFrame.h"
#import <objc/runtime.h>

/**
 * *********************** 属性 ***********************
 */
@interface LYBitCellAttributes () <NSCopying>

@end

@implementation LYBitCellAttributes
{
    NSArray *_propertyLists;
}

- (void)dealloc
{
    [self removeOberver];
}

- (id)copyWithZone:(NSZone *)zone
{
    LYBitCellAttributes *attributes = [[LYBitCellAttributes alloc] init];
    attributes.style = self.style;
    attributes.editState = self.editState;
    attributes.borderWidth = self.borderWidth;
    attributes.borderCorner = self.borderCorner;
    attributes.borderColor = self.borderColor;
    attributes.underLineWidth = self.underLineWidth;
    attributes.textFont = self.textFont;
    attributes.textColor = self.textColor;
    attributes.cursorColor = self.cursorColor;
    attributes.cellSize = self.cellSize;
    attributes.cellBackgroundColor = self.cellBackgroundColor;
    return attributes;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _propertyLists = [self allPropertyNames];
        self.style = LYBitFieldStyleUnderLine;
        self.borderWidth = 2;
        self.borderCorner = 0;
        self.borderColor = CBColorRGB(244, 67, 54);
        self.underLineWidth = 40;
        self.textFont = [UIFont systemFontOfSize:26];
        self.textColor = CBColorRGB(26, 26, 26);
        self.cursorColor = CBColorRGB(244, 67, 54);
        self.cellSize = CGSizeMake(40, 40);
        self.cellBackgroundColor = CBColorRGB(255, 255, 255);
        [self addObserver];
    }
    return self;
}

- (NSArray *)allPropertyNames{
   
    unsigned int propertyCount = 0, i = 0;
    objc_property_t *properties = class_copyPropertyList(self.class, &propertyCount);
    
    NSMutableArray *allNames = [[NSMutableArray alloc] initWithCapacity:propertyCount];
    
    if (properties) {
        for (i = 0; i < propertyCount; i++) {
            objc_property_t property = properties[i];
            
            NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
            
            [allNames addObject:propertyName];
        }
        free(properties);
    }

    return allNames;
}

- (void)addObserver
{
    for (int i = 0; i < _propertyLists.count; i++) {
        [self addObserver:self forKeyPath:_propertyLists[i] options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)removeOberver
{
    for (int i = 0; i < _propertyLists.count; i++) {
        [self removeObserver:self forKeyPath:_propertyLists[i] context:NULL];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([_propertyLists containsObject:keyPath]) {
        if (self.listen) {
            self.listen(self, keyPath, [self valueForKey:keyPath]);
        }
    }
}

- (void)printPropertiesLog
{
    return NSLog(@"_propertyLists \n %@",_propertyLists);
}

@end


/**
 * *********************** 单个cell ***********************
 */
@interface LYBitCell () <UITextFieldDelegate>

@end
@implementation LYBitCell
{
    __weak UITextField *_textfield;
    __weak UIImageView *_borderView;
}

- (void)dealloc
{
    
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self configureUI];
    }
    
    return self;
}

- (void)configureUI
{
    UIImageView *borderView = [UIImageView.alloc init];
    [self addSubview:borderView];
    _borderView = borderView;
    
    UITextField *textfield = [UITextField.alloc init];
    textfield.textAlignment = NSTextAlignmentCenter;
    textfield.keyboardType = UIKeyboardTypeNumberPad;
    textfield.delegate = self;
    [self addSubview:textfield];
    _textfield = textfield;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    if (self.attributes.style == LYBitFieldStyleBorder) {
        // 边框
        _borderView.frame = CGRectZero;
        _textfield.frame = CGRectMake(0, 0, width,height);
    } else if (self.attributes.style == LYBitFieldStyleUnderLine) {
        // 下划线
        _borderView.frame = CGRectMake((width - self.attributes.underLineWidth) * 0.5, height - self.attributes.borderWidth, self.attributes.underLineWidth, self.attributes.borderWidth);
        _textfield.frame = CGRectMake(0, 0, width, height - self.attributes.borderWidth);
    } else {
        // 无边框和下划线
        _borderView.frame = CGRectZero;
    }
}

- (void)setAttributes:(LYBitCellAttributes *)attributes
{
    _attributes = attributes;
    
    _textfield.font = attributes.textFont;
    _textfield.textColor = attributes.textColor;
    _textfield.backgroundColor = attributes.cellBackgroundColor;
    _textfield.tintColor = attributes.cursorColor;
    
    if (self.attributes.style == LYBitFieldStyleBorder) {
        // 边框
        _borderView.hidden = YES;
        _textfield.layer.borderColor = attributes.borderColor.CGColor;
        _textfield.layer.borderWidth = attributes.borderWidth;
        _textfield.layer.cornerRadius = attributes.borderCorner;
    } else if (self.attributes.style == LYBitFieldStyleUnderLine) {
        // 下划线
        _borderView.hidden = NO;
        _borderView.layer.borderWidth = 0;
        _textfield.layer.cornerRadius = 0;
        _borderView.layer.cornerRadius = attributes.borderCorner;
        _borderView.backgroundColor = attributes.borderColor;
    } else {
        // 无边框和下划线
        _textfield.layer.cornerRadius = 0;
        _borderView.hidden = YES;
    }
    
    if (attributes.editState == LYBitCellStateEditing) {
        // 正在编辑
        self->_textfield.enabled = YES;
        [self->_textfield becomeFirstResponder];
    } else if (attributes.editState == LYBitCellStateUnEdit) {
        // 未编辑
        self->_textfield.enabled = NO;
    } else {
        // 已编辑
        self->_textfield.enabled = NO;
    }
    
    // 处理监听
    CBWeakSelf
    attributes.listen = ^(LYBitCellAttributes * _Nonnull object, NSString * _Nonnull keypath, id  _Nonnull value) {
        CBStrongSelfElseReturn
        if ([keypath isEqualToString:@"style"]) {
            NSInteger style = [value integerValue];
            if (style == LYBitFieldStyleBorder) {
                self->_borderView.hidden = YES;
                self->_textfield.layer.borderColor = object.borderColor.CGColor;
                self->_textfield.layer.borderWidth = object.borderWidth;
                self->_textfield.layer.cornerRadius = object.borderCorner;
            } else if (self.attributes.style == LYBitFieldStyleUnderLine) {
                // 下划线
                self->_borderView.hidden = NO;
            } else {
                // 无边框和下划线
                self->_borderView.hidden = YES;
                self->_textfield.layer.borderWidth = 0;
            }
            [self setNeedsLayout];
        }
        
        if ([keypath isEqualToString:@"borderCorner"]) {
            CGFloat corner = [value floatValue];
            if ((attributes.style == LYBitFieldStyleUnderLine && corner <= attributes.borderWidth * 0.5) || (corner <= MIN(self.width, self.height) * 0.5 && attributes.style == LYBitFieldStyleBorder)) {
                self->_textfield.layer.cornerRadius = corner;
                self->_borderView.layer.cornerRadius = corner;
                [self setNeedsLayout];
            }
        }
        
        if ([keypath isEqualToString:@"underLineWidth"]) {
            [self setNeedsLayout];
        }
        
        if ([keypath isEqualToString:@"cursorColor"]) {
            UIColor *color = value;
            self->_textfield.tintColor = color;
        }
        
        if ([keypath isEqualToString:@"editState"]) {
            LYBitCellState state = [value integerValue];
            if (state == LYBitCellStateEditing) {
                // 正在编辑
                self->_textfield.enabled = YES;
                [self->_textfield becomeFirstResponder];
            } else if (state == LYBitCellStateUnEdit) {
                // 未编辑
                self->_textfield.enabled = NO;
            } else {
                // 已编辑
                self->_textfield.enabled = NO;
            }
        }
    };
}

- (void)setText:(NSString *)text
{
    if (text.length > 0) {
        self.attributes.editState = LYBitCellStateEdited;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newString.length < 2) {
        return YES;
    } else {
        
    }
    return NO;
}

@end


/**
 * *********************** 主控件 ***********************
 */
@implementation LYBitField
{
    NSMutableArray <LYBitCell *>*_fieldArray;
    NSInteger _editingIndex;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _fieldArray = [NSMutableArray array];
        self.cellSpace = 20;
        self.cursorColor = CBColorRGB(244, 67, 54);
        
        LYBitCellAttributes *attributes1 = [LYBitCellAttributes.alloc init];
        attributes1.editState = LYBitCellStateUnEdit;
        [self addListen:attributes1];
        
        LYBitCellAttributes *attributes2 = [LYBitCellAttributes.alloc init];
        attributes2.editState = LYBitCellStateEditing;
        [self addListen:attributes2];
        
        LYBitCellAttributes *attributes3 = [LYBitCellAttributes.alloc init];
        attributes3.editState = LYBitCellStateEdited;
        [self addListen:attributes3];
        
        _unEditAttributes = attributes1;
        _editingAttributes = attributes2;
        _editedAttributes = attributes3;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    __block CGFloat originX = 0;
    
    __block NSInteger unEditNumber = self.cellNumber - _editingIndex - 1;
    __block NSInteger editingNumber = 1;
    __block NSInteger editedNumber = _editingIndex;
    
    originX = (CGRectGetWidth(self.frame) - unEditNumber * self.unEditAttributes.cellSize.width - editingNumber * self.editingAttributes.cellSize.width - editedNumber * self.editedAttributes.cellSize.width - self.cellSpace * (self.cellNumber - 1)) * 0.5;
    
    CBWeakSelf
    [_fieldArray enumerateObjectsUsingBlock:^(LYBitCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CBStrongSelfElseReturn
        CGSize size;
        CGFloat x;
        if (self->_editingIndex < idx) {
            // 未编辑
            size = self.unEditAttributes.cellSize;
            x = (idx - self->_editingIndex) * (size.width + self.cellSpace) + originX;
        } else if (self->_editingIndex == idx) {
            // 正在编辑
            size = self.editingAttributes.cellSize;
            x = (idx ? self.cellSpace : 0) + originX;
        } else {
            // 已编辑
            size = self.editedAttributes.cellSize;
            x = idx * (size.width + self.cellSpace) + originX;
        }
        
        obj.frame = CGRectMake(x, 0, size.width, size.height);
        obj.centerY = CGRectGetHeight(self.frame) * 0.5;
        
    }];
}

- (void)setCellNumber:(NSInteger)cellNumber
{
    if (_cellNumber != cellNumber) {
        for (int i = 0; i < cellNumber; i++) {
            if (i == 0) {
                LYBitCell *cell = [self cellWithAttributes:self.editingAttributes];
                [self addSubview:cell];
                [_fieldArray addObject:cell];
            } else {
                LYBitCell *cell = [self cellWithAttributes:self.unEditAttributes];
                [self addSubview:cell];
                [_fieldArray addObject:cell];
            }
        }
        [self setNeedsLayout];
    }
    _cellNumber = cellNumber;
}

- (void)setCellSpace:(CGFloat)cellSpace
{
    _cellSpace = cellSpace;
    [self setNeedsLayout];
}

- (void)setCursorColor:(UIColor *)cursorColor
{
    _cursorColor = cursorColor;
    
    [_fieldArray enumerateObjectsUsingBlock:^(LYBitCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.attributes.cursorColor = cursorColor;
    }];
}

- (void)addListen:(LYBitCellAttributes *)attributes
{
    CBWeakSelf
    
    attributes.listen = ^(LYBitCellAttributes * _Nonnull object, NSString * _Nonnull keypath, id  _Nonnull value) {
        CBStrongSelfElseReturn
        if ([keypath isEqualToString:@"cellSize"]) {
            [self setNeedsLayout];
        }
        
        if ([keypath isEqualToString:@"underLineWidth"]) {
            if (attributes.editState == LYBitCellStateUnEdit) {
                // 未编辑
                for (NSInteger i = self->_editingIndex + 1; i < self.cellNumber; i++) {
                    LYBitCell *cell = self->_fieldArray[i];
                    cell.attributes.underLineWidth = [value floatValue];
                }
            } else if (attributes.editState == LYBitCellStateEditing) {
                // 正在编辑
                LYBitCell *cell = self->_fieldArray[self->_editingIndex];
                cell.attributes.underLineWidth = [value floatValue];
            } else {
                // 已编辑
                for (NSInteger i = 0; i < self->_editingIndex; i++) {
                    LYBitCell *cell = self->_fieldArray[i];
                    cell.attributes.underLineWidth = [value floatValue];
                }
            }
        }
        
        if ([keypath isEqualToString:@"style"]) {
            if (attributes.editState == LYBitCellStateUnEdit) {
                // 未编辑
                for (NSInteger i = self->_editingIndex + 1; i < self.cellNumber; i++) {
                    LYBitCell *cell = self->_fieldArray[i];
                    cell.attributes.style = [value integerValue];
                }
            } else if (attributes.editState == LYBitCellStateEditing) {
                // 正在编辑
                LYBitCell *cell = self->_fieldArray[self->_editingIndex];
                cell.attributes.style = [value integerValue];
            } else {
                // 已编辑
                for (NSInteger i = 0; i < self->_editingIndex; i++) {
                    LYBitCell *cell = self->_fieldArray[i];
                    cell.attributes.style = [value integerValue];
                }
            }
        }
        
        if ([keypath isEqualToString:@"borderCorner"]) {
            if (attributes.editState == LYBitCellStateUnEdit) {
                // 未编辑
                for (NSInteger i = self->_editingIndex + 1; i < self.cellNumber; i++) {
                    LYBitCell *cell = self->_fieldArray[i];
                    cell.attributes.borderCorner = [value floatValue];
                }
            } else if (attributes.editState == LYBitCellStateEditing) {
                // 正在编辑
                LYBitCell *cell = self->_fieldArray[self->_editingIndex];
                cell.attributes.borderCorner = [value floatValue];
            } else {
                // 已编辑
                for (NSInteger i = 0; i < self->_editingIndex; i++) {
                    LYBitCell *cell = self->_fieldArray[i];
                    cell.attributes.borderCorner = [value floatValue];
                }
            }
        }
    };
}

#pragma mark - create field

- (LYBitCell *)cellWithAttributes:(LYBitCellAttributes *)attributes
{
    LYBitCell *cell = [LYBitCell.alloc init];
    cell.attributes = [attributes copy];
    CBWeakSelf
    cell.finishedBlock = ^(NSString * _Nonnull value) {
        CBStrongSelfElseReturn
//        if (value) {
//            NSInteger index = ++self->_editingIndex % self.cellNumber;
//            if (index < self.cellNumber) {
//                LYBitCell *nextCell = self->_fieldArray[index];
////                nextCell.attributes.editState = LYBitCellStateEditing;
//            }
//        }
    };
    return cell;
}

@end
