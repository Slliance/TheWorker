//
//  EmpGoOutViewController.m
//  TheWorker
//
//  Created by 苏晓凯 on 2017/8/21.
//  Copyright © 2017年 huying. All rights reserved.
//

#import "EmpGoOutViewController.h"

@interface EmpGoOutViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *goOutWebView;

@end

@implementation EmpGoOutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *urlStr = [self replaceUnicode:self.url];
    NSString *str = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:str];
    [self.goOutWebView loadRequest:[NSURLRequest requestWithURL:url]];
    self.goOutWebView.scalesPageToFit = YES;
    self.goOutWebView.dataDetectorTypes = UIDataDetectorTypeAll;
    
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)backAction:(id)sender {
    [self backBtnAction:sender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    - (NSString*) replaceUnicode:(NSString*)TransformUnicodeString
    
    {
        
        NSString*tepStr1 = [TransformUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
        
        NSString*tepStr2 = [tepStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
        
        NSString*tepStr3 = [[@"\""  stringByAppendingString:tepStr2]stringByAppendingString:@"\""];
        
        NSData*tepData = [tepStr3  dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString*axiba = [NSPropertyListSerialization    propertyListWithData:tepData options:NSPropertyListMutableContainers
                          
                                                                       format:NULL error:NULL];
        
        return  [axiba    stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
        
    }
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
