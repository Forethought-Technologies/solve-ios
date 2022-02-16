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

- (IBAction)contactSupportTapped:(id)sender {
    ForethoughtSDK.delegate = self;
    [ForethoughtSDK show];
}

- (void)startChatRequestedWithHandoffData:(ForethoughtHandoffData * _Nonnull)handoffData {
    NSLog(@"Custom Handoff Requested");
}

@end
