//
//  ViewController.m
//  LYUnitField
//
//  Created by admin on 2019/3/19.
//  Copyright © 2019 admin. All rights reserved.
//

#import "ViewController.h"
#import "LYLinearField/LYBitField.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LYBitCellAttributes *attributes = [LYBitCellAttributes.alloc init];
    [attributes printPropertiesLog];
    
    CBWeakSelf
    attributes.listen = ^(NSString * _Nonnull key, id  _Nonnull value) {
        CBStrongSelfElseReturn
    };
    
    attributes.editState = LYBitCellStateEdited;
    attributes.borderWidth = 30;
    attributes.style = LYBitFieldStyleBorder;
    attributes.borderColor = UIColor.redColor;
    attributes.borderImage = [UIImage imageNamed:@"Default-568h@2x"];
    attributes.number = @(3333);
}


@end
