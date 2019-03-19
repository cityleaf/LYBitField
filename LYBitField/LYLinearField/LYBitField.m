//
//  LYBitField.m
//  LYBitField
//
//  Created by 刘宇 on 2019/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "LYBitField.h"

@implementation LYBitCell
{
    __weak UITextField *_textfield;
    __weak UIImageView *_borderView;
}

- (void)dealloc
{
    [self removeOberver];
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
    if (_attributes) {
        [self removeOberver];
    }
    
    [self addObserver];
    
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

- (void)addObserver
{
    [self addObserver:self forKeyPath:@"attributes.style" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"attributes.borderWidth" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"attributes.underLineWidth" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"attributes.textFont" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"attributes.textColor" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"attributes.borderColor" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"attributes.borderImage" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"attributes.underLineImage" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"attributes.editState" options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeOberver
{
    [self removeObserver:self forKeyPath:@"attributes.style" context:NULL];
    [self removeObserver:self forKeyPath:@"attributes.borderWidth" context:NULL];
    [self removeObserver:self forKeyPath:@"attributes.underLineWidth" context:NULL];
    [self removeObserver:self forKeyPath:@"attributes.textFont" context:NULL];
    [self removeObserver:self forKeyPath:@"attributes.textColor" context:NULL];
    [self removeObserver:self forKeyPath:@"attributes.borderColor" context:NULL];
    [self removeObserver:self forKeyPath:@"attributes.borderImage" context:NULL];
    [self removeObserver:self forKeyPath:@"attributes.underLineImage" context:NULL];
    [self removeObserver:self forKeyPath:@"attributes.editState" context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"attributes.style"]) {
        
    } else if ([keyPath isEqualToString:@"attributes.borderWidth"]){
        
    } else if ([keyPath isEqualToString:@"attributes.underLineWidth"]){
        
    } else if ([keyPath isEqualToString:@"attributes.textFont"]){
        
    } else if ([keyPath isEqualToString:@"attributes.textColor"]){
        
    } else if ([keyPath isEqualToString:@"attributes.borderColor"]){
        
    } else if ([keyPath isEqualToString:@"attributes.borderImage"]){
        
    } else if ([keyPath isEqualToString:@"attributes.underLineImage"]){
        
    } else if ([keyPath isEqualToString:@"attributes.editState"]){
        
    } else {
        
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
        
        self.unEditAttributes = attributes1;
        self.editingAttributes = attributes2;
        self.editedAttributes = attributes3;
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
