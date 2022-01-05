//
//  ViewController.m
//  Demo-ObjC
//
//  Created by Matthew Knippen on 12/27/21.
//

#import "ViewController.h"
@import Forethought;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)contactSupportTapped:(id)sender {
    NSString *key = @"__YOUR_KEY_HERE__";
    NSDictionary *dataParameters = @{@"language":@"EN", @"tracking-email":@"test@ft.ai"};
        
    ForethoughtViewController *vc = [[ForethoughtViewController alloc] initWithAPI_KEY:key configParameters:NULL dataParameters:dataParameters];
    
    [self presentViewController:vc animated:true completion:nil];
}

@end
