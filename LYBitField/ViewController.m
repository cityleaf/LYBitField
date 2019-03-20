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
@property (weak, nonatomic) UILabel *widthLabel;
@property (weak, nonatomic) UILabel *heightLabel;
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
    
    self.cells = @[@[spaceCell],@[widthCell,heightCell]];
    self.sectionTitles = @[@"cellSpace 间距",@"未编辑|正在编辑|已编辑 同宽 同高",@"未编辑 attributes",@"正在编辑 attributes",@"已编辑 attributes"];
    
    UITableView *tableView = [UITableView.alloc initWithFrame:CGRectMake(0, field.bottom + 10, CGRectGetWidth(self.view.frame), self.view.height - field.height - 10) style:UITableViewStyleGrouped];
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

- (void)sliderWidth:(UISlider *)slider
{
    self.field.editingAttributes.cellSize = CGSizeMake(slider.value, self.field.editingAttributes.cellSize.height);
    self.field.unEditAttributes.cellSize = CGSizeMake(slider.value, self.field.unEditAttributes.cellSize.height);
    self.field.editedAttributes.cellSize = CGSizeMake(slider.value, self.field.editedAttributes.cellSize.height);
    self.widthLabel.text = [NSString stringWithFormat:@"%.1f",slider.value];
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
    return self.cells[indexPath.section][indexPath.row];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return self.sectionTitles[section];
}

@end
