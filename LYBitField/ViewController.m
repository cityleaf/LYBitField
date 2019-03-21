//
//  ViewController.m
//  LYUnitField
//
//  Created by admin on 2019/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "ViewController.h"
#import "LYLinearField/LYBitField.h"
#import "LYLinearField/LYViewFrame.h"

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSArray<NSArray *> *cells;
@property (strong, nonatomic) NSArray *sectionTitles;
@property (weak, nonatomic) LYBitField *field;
@property (weak, nonatomic) UILabel *spaceLabel;
@property (weak, nonatomic) UILabel *cornerLabel;
@property (weak, nonatomic) UILabel *underLineWidthLabel;
@property (weak, nonatomic) UILabel *widthLabel;
@property (weak, nonatomic) UILabel *heightLabel;

@property (weak, nonatomic) UISlider *underLineWidthSlider;

@property (assign, nonatomic) NSInteger unEditStyleSelectedIndex;
@property (assign, nonatomic) NSInteger editingStyleSelectedIndex;
@property (assign, nonatomic) NSInteger editedStyleSelectedIndex;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
    LYBitField *field = [LYBitField.alloc initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.frame), 80)];
    field.cellNumber = 5;
    [self.view addSubview:field];
    self.field = field;
    
    // 调节间距
    UITableViewCell *spaceCell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [spaceCell.contentView addSubview:({
        UISlider *slider = [UISlider.alloc initWithFrame:CGRectMake(0, 0, self.view.width - 80, 40)];
        slider.value = 20;
        slider.minimumValue = 0;
        slider.maximumValue = 50;
        [slider addTarget:self action:@selector(sliderSpace:) forControlEvents:UIControlEventValueChanged];
        
        slider;
    })];
    [spaceCell.contentView addSubview:({
        UILabel *label = [UILabel.alloc initWithFrame:CGRectMake(self.view.width - 80, 0, 80, 40)];
        label.text = @"20";
        label.textAlignment = NSTextAlignmentCenter;
        self.spaceLabel = label;
        
        label;
    })];
    
    // 调节圆角
    UITableViewCell *cornerCell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [cornerCell.contentView addSubview:({
        UISlider *slider = [UISlider.alloc initWithFrame:CGRectMake(0, 0, self.view.width - 80, 40)];
        slider.value = 4;
        slider.minimumValue = 0;
        slider.maximumValue = 30;
        [slider addTarget:self action:@selector(sliderCorner:) forControlEvents:UIControlEventValueChanged];
        
        slider;
    })];
    [cornerCell.contentView addSubview:({
        UILabel *label = [UILabel.alloc initWithFrame:CGRectMake(self.view.width - 80, 0, 80, 40)];
        label.text = @"4";
        label.textAlignment = NSTextAlignmentCenter;
        self.cornerLabel = label;
        
        label;
    })];
    // 调节下边线宽度
    UITableViewCell *underLineWidthCell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [underLineWidthCell.contentView addSubview:({
        UISlider *slider = [UISlider.alloc initWithFrame:CGRectMake(0, 0, self.view.width - 80, 40)];
        slider.value = 40;
        slider.minimumValue = 0;
        slider.maximumValue = 80;
        [slider addTarget:self action:@selector(sliderUnderLineWidthCell:) forControlEvents:UIControlEventValueChanged];
        self.underLineWidthSlider = slider;
        
        slider;
    })];
    [underLineWidthCell.contentView addSubview:({
        UILabel *label = [UILabel.alloc initWithFrame:CGRectMake(self.view.width - 80, 0, 80, 40)];
        label.text = @"30";
        label.textAlignment = NSTextAlignmentCenter;
        self.underLineWidthLabel = label;
        
        label;
    })];
    
    // 调节cell宽
    UITableViewCell *widthCell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [widthCell.contentView addSubview:({
        UISlider *slider = [UISlider.alloc initWithFrame:CGRectMake(0, 0, self.view.width - 80, 40)];
        slider.value = 40;
        slider.minimumValue = 30;
        slider.maximumValue = 60;
        [slider addTarget:self action:@selector(sliderWidth:) forControlEvents:UIControlEventValueChanged];
        
        slider;
    })];
    [widthCell.contentView addSubview:({
        UILabel *label = [UILabel.alloc initWithFrame:CGRectMake(self.view.width - 80, 0, 80, 40)];
        label.text = @"40";
        label.textAlignment = NSTextAlignmentCenter;
        self.widthLabel = label;
        
        label;
    })];
    
    // 调节cell高
    UITableViewCell *heightCell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    [heightCell.contentView addSubview:({
        UISlider *slider = [UISlider.alloc initWithFrame:CGRectMake(0, 0, self.view.width - 80, 40)];
        slider.value = 40;
        slider.minimumValue = 30;
        slider.maximumValue = 60;
        [slider addTarget:self action:@selector(sliderHeight:) forControlEvents:UIControlEventValueChanged];
        
        slider;
    })];
    [heightCell.contentView addSubview:({
        UILabel *label = [UILabel.alloc initWithFrame:CGRectMake(self.view.width - 80, 0, 80, 40)];
        label.text = @"40";
        label.textAlignment = NSTextAlignmentCenter;
        self.heightLabel = label;
        
        label;
    })];
    
    // 未编辑
    UITableViewCell *unEditStyle1Cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    unEditStyle1Cell.textLabel.text = @"LYBitFieldStyleUnderLine";
    unEditStyle1Cell.detailTextLabel.text = @"边框";
    UITableViewCell *unEditStyle2Cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    unEditStyle2Cell.textLabel.text = @"LYBitFieldStyleBorder";
    unEditStyle2Cell.detailTextLabel.text = @"下划线";
    UITableViewCell *unEditStyle3Cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    unEditStyle3Cell.textLabel.text = @"LYBitFieldStyleNoBorderAndUnderLine";
    unEditStyle3Cell.detailTextLabel.text = @"没有样式";
    // 正在编辑
    UITableViewCell *editingStyle1Cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    editingStyle1Cell.textLabel.text = @"LYBitFieldStyleUnderLine";
    editingStyle1Cell.detailTextLabel.text = @"边框";
    UITableViewCell *editingStyle2Cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    editingStyle2Cell.textLabel.text = @"LYBitFieldStyleBorder";
    editingStyle2Cell.detailTextLabel.text = @"下划线";
    UITableViewCell *editingStyle3Cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    editingStyle3Cell.textLabel.text = @"LYBitFieldStyleNoBorderAndUnderLine";
    editingStyle3Cell.detailTextLabel.text = @"没有样式";
    // 已编辑
    UITableViewCell *editedStyle1Cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    editedStyle1Cell.textLabel.text = @"LYBitFieldStyleUnderLine";
    editedStyle1Cell.detailTextLabel.text = @"边框";
    UITableViewCell *editedStyle2Cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    editedStyle2Cell.textLabel.text = @"LYBitFieldStyleBorder";
    editedStyle2Cell.detailTextLabel.text = @"下划线";
    UITableViewCell *editedStyle3Cell = [UITableViewCell.alloc initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    editedStyle3Cell.textLabel.text = @"LYBitFieldStyleNoBorderAndUnderLine";
    editedStyle3Cell.detailTextLabel.text = @"没有样式";
    
    self.cells = @[@[spaceCell]
                   ,@[cornerCell]
                   ,@[underLineWidthCell]
                   ,@[widthCell,heightCell]
                   ,@[unEditStyle1Cell,unEditStyle2Cell,unEditStyle3Cell]
                   ,@[editingStyle1Cell,editingStyle2Cell,editingStyle3Cell]
                   ,@[editedStyle1Cell,editedStyle2Cell,editedStyle3Cell]];
    self.sectionTitles = @[@"cellSpace 间距",@"borderCorner 框圆角",@"underLineWidth 下划线宽度",@"未编辑|正在编辑|已编辑 同宽 同高",@"未编辑 attributes",@"正在编辑 attributes",@"已编辑 attributes"];
    
    UITableView *tableView = [UITableView.alloc initWithFrame:CGRectMake(0, field.bottom + 10, CGRectGetWidth(self.view.frame), self.view.height - field.bottom - 10) style:UITableViewStyleGrouped];
    tableView.rowHeight = 40;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:tableView];
    
}

- (void)sliderSpace:(UISlider *)slider
{
    self.field.cellSpace = slider.value;
    self.spaceLabel.text = [NSString stringWithFormat:@"%.1f",slider.value];
}

- (void)sliderCorner:(UISlider *)slider
{
    self.field.unEditAttributes.borderCorner = slider.value;
    self.field.editingAttributes.borderCorner = slider.value;
    self.field.editingAttributes.borderCorner = slider.value;
    self.cornerLabel.text = [NSString stringWithFormat:@"%.1f",slider.value];
}

- (void)sliderUnderLineWidthCell:(UISlider *)slider
{
    self.field.unEditAttributes.underLineWidth = slider.value;
    self.field.editingAttributes.underLineWidth = slider.value;
    self.field.editingAttributes.underLineWidth = slider.value;
    self.underLineWidthLabel.text = [NSString stringWithFormat:@"%.1f",slider.value];
}

- (void)sliderWidth:(UISlider *)slider
{
    self.field.editingAttributes.cellSize = CGSizeMake(slider.value, self.field.editingAttributes.cellSize.height);
    self.field.unEditAttributes.cellSize = CGSizeMake(slider.value, self.field.unEditAttributes.cellSize.height);
    self.field.editedAttributes.cellSize = CGSizeMake(slider.value, self.field.editedAttributes.cellSize.height);
    self.widthLabel.text = [NSString stringWithFormat:@"%.1f",slider.value];
    
    // 同时更改下边线宽度
    self.underLineWidthSlider.value = slider.value;
    self.field.unEditAttributes.underLineWidth = slider.value;
    self.field.editingAttributes.underLineWidth = slider.value;
    self.field.editingAttributes.underLineWidth = slider.value;
    self.underLineWidthLabel.text = [NSString stringWithFormat:@"%.1f",slider.value];
}

- (void)sliderHeight:(UISlider *)slider
{
    self.field.editingAttributes.cellSize = CGSizeMake(self.field.editingAttributes.cellSize.width, slider.value);
    self.field.unEditAttributes.cellSize = CGSizeMake(self.field.editingAttributes.cellSize.width, slider.value);
    self.field.editedAttributes.cellSize = CGSizeMake(self.field.editingAttributes.cellSize.width, slider.value);
    self.heightLabel.text = [NSString stringWithFormat:@"%.1f",slider.value];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.cells.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cells[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = self.cells[indexPath.section][indexPath.row];
    if (indexPath.section == 4) {
        cell.accessoryType = indexPath.row == self.unEditStyleSelectedIndex ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    if (indexPath.section == 5) {
        cell.accessoryType = indexPath.row == self.editingStyleSelectedIndex ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    if (indexPath.section == 6) {
        cell.accessoryType = indexPath.row == self.editedStyleSelectedIndex ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitles[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 4) {
        // 未编辑
        self.unEditStyleSelectedIndex = indexPath.row;
        self.field.unEditAttributes.style = indexPath.row;
    } else if (indexPath.section == 5) {
        // 正在编辑
        self.editingStyleSelectedIndex = indexPath.row;
        self.field.editingAttributes.style = indexPath.row;
    } else if (indexPath.section == 6) {
        // 已编辑
        self.editedStyleSelectedIndex = indexPath.row;
        self.field.editedAttributes.style = indexPath.row;
    } else {
        
    }
    [tableView reloadData];
}

@end
