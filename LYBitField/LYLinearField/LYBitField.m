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
    attributes.borderWidth = self.borderWidth;
    attributes.borderColor = self.borderColor;
    attributes.underLineWidth = self.underLineWidth;
    attributes.textFont = self.textFont;
    attributes.textColor = self.textColor;
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
        self.borderColor = UIColor.grayColor;
        self.underLineWidth = 50;
        self.textFont = [UIFont systemFontOfSize:16];
        self.textColor = CBColorRGB(244, 67, 54);
        self.cellSize = CGSizeMake(40, 40);
        self.cellBackgroundColor = CBColorRGB(155, 155, 155);
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
            self.listen(keyPath, [self valueForKey:keyPath]);
        }
    }
}

- (void)printPropertiesLog
{
    return NSLog(@"_propertyLists \n %@",_propertyLists);
}

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
    
    UITextField *textfield = [UITextField.alloc init];
    textfield.textAlignment = NSTextAlignmentCenter;
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
        _borderView.frame = CGRectMake(0, 0, width, height);
        _textfield.frame = CGRectMake(0, 0, width, height);
    } else if (self.attributes.style == LYBitFieldStyleUnderLine) {
        // 下划线
        _borderView.frame = CGRectMake((width - self.attributes.underLineWidth) * 0.5, height - self.attributes.borderWidth, self.attributes.underLineWidth, self.attributes.borderWidth);
        _textfield.frame = CGRectMake(0, 0, width, height);
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
    self.backgroundColor = attributes.cellBackgroundColor;
    
    if (self.attributes.style == LYBitFieldStyleBorder) {
        // 边框
        _borderView.hidden = NO;
        if (self.attributes.borderImage) {
            _borderView.image = attributes.borderImage;
        } else {
            _borderView.layer.borderColor = attributes.borderColor.CGColor;
            _borderView.layer.borderWidth = attributes.borderWidth;
            _borderView.backgroundColor = UIColor.clearColor;
        }
    } else if (self.attributes.style == LYBitFieldStyleUnderLine) {
        // 下划线
        _borderView.hidden = NO;
        _borderView.layer.borderWidth = 0;
        if (self.attributes.underLineImage) {
            _borderView.image = attributes.borderImage;
        } else {
            _borderView.backgroundColor = attributes.borderColor;
        }
    } else {
        // 无边框和下划线
        _borderView.hidden = YES;
    }
}

@end


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
        
        LYBitCellAttributes *attributes1 = [LYBitCellAttributes.alloc init];
        attributes1.editState = LYBitCellStateUnEdit;
        attributes1.cellBackgroundColor = UIColor.blueColor;
        [self addListen:attributes1];
        
        LYBitCellAttributes *attributes2 = [LYBitCellAttributes.alloc init];
        attributes2.editState = LYBitCellStateEditing;
        attributes2.cellBackgroundColor = UIColor.redColor;
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

- (void)addListen:(LYBitCellAttributes *)attributes
{
    CBWeakSelf
    
    if (attributes.editState == LYBitCellStateUnEdit) {
        // 未编辑
    } else if (attributes.editState == LYBitCellStateEditing) {
        // 正在编辑
    } else {
        // 已编辑
    }
    
    attributes.listen = ^(NSString * _Nonnull keypath, id  _Nonnull value) {
        CBStrongSelfElseReturn
        if ([keypath isEqualToString:@"cellSize"]) {
            [self setNeedsLayout];
        }
    };
}

#pragma mark - create field

- (LYBitCell *)cellWithAttributes:(LYBitCellAttributes *)attributes
{
    LYBitCell *cell = [LYBitCell.alloc init];
    cell.attributes = [attributes copy];
    return cell;
}

@end
