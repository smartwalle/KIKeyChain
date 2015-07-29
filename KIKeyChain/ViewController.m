//
//  ViewController.m
//  KIKeyChain
//
//  Created by apple on 15/7/29.
//  Copyright (c) 2015年 smartwalle. All rights reserved.
//

#import "ViewController.h"
#import "KIKeyChain.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    KIKeyChain *key = [KIKeyChain keyChainWithIdentifier:@"default_user"];
    [key setValue:@"user1" forKey:@"username"];
    [key setValue:@"password1" forKey:@"password"];
    [key write];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    KIKeyChain *key = [KIKeyChain keyChainWithIdentifier:@"default_user"];
    
    NSLog(@"%@==%@", [key valueForKey:@"username"], [key valueForKey:@"password"]);
}

@end
