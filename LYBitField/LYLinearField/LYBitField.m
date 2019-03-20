//
//  LYBitField.m
//  LYBitField
//
//  Created by 刘宇 on 2019/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "LYBitField.h"
#import <objc/runtime.h>

@implementation LYBitCellAttributes
{
    NSArray *_propertyLists;
}

- (void)dealloc
{
    [self removeOberver];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _propertyLists = [self allPropertyNames];
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
    NSMutableArray *_fieldArray;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _fieldArray = [NSMutableArray array];
        
        LYBitCellAttributes *attributes1 = [LYBitCellAttributes.alloc init];
        attributes1.style = LYBitFieldStyleUnderLine;
        attributes1.borderWidth = 2;
        attributes1.borderColor = UIColor.grayColor;
        attributes1.underLineWidth = 50;
        attributes1.textFont = [UIFont systemFontOfSize:16];
        attributes1.textColor = CBColorRGB(244, 67, 54);
        
        LYBitCellAttributes *attributes2 = [LYBitCellAttributes.alloc init];
        attributes2.style = LYBitFieldStyleUnderLine;
        attributes2.borderWidth = 2;
        attributes2.borderColor = UIColor.grayColor;
        attributes2.underLineWidth = 50;
        attributes2.textFont = [UIFont systemFontOfSize:16];
        attributes2.textColor = CBColorRGB(244, 67, 54);
        
        LYBitCellAttributes *attributes3 = [LYBitCellAttributes.alloc init];
        attributes3.style = LYBitFieldStyleUnderLine;
        attributes3.borderWidth = 2;
        attributes3.borderColor = UIColor.grayColor;
        attributes3.underLineWidth = 50;
        attributes3.textFont = [UIFont systemFontOfSize:16];
        attributes3.textColor = CBColorRGB(244, 67, 54);
        
        _unEditAttributes = attributes1;
        _editingAttributes = attributes2;
        _editedAttributes = attributes3;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}

- (void)setCellNumber:(NSInteger)cellNumber
{
    if (_cellNumber == cellNumber) {
        for (int i = 0; i < cellNumber; i++) {
            if (i == 0) {
                LYBitCell *cell = [self cellWithAttributes:self.editedAttributes];
                [_fieldArray addObject:cell];
            } else {
                LYBitCell *cell = [self cellWithAttributes:self.unEditAttributes];
                [_fieldArray addObject:cell];
            }
        }
    }
    _cellNumber = cellNumber;
}

#pragma mark - create field

- (LYBitCell *)cellWithAttributes:(LYBitCellAttributes *)attributes
{
    LYBitCell *cell = [LYBitCell.alloc init];
    cell.attributes = [attributes copy];
    return cell;
}

@end
