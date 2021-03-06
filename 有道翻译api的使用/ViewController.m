//
//  ViewController.m
//  有道翻译api的使用
//
//  Created by CK_chan on 15/11/21.
//  Copyright © 2015年 CK_chan. All rights reserved.
//

#import "ViewController.h"


//使用API key 时，请求频率限制为每小时1000次，超过限制会被封禁。
//这两个参数是要自己去申请的，涉及到版权问题。

#define YOUDAO_keyfrom          @"funchat"
#define YOUDAO_key              @"509654697"


@interface ViewController (){
    UITextField *inputTF;
    UILabel *showLabel;
    UITextView *showTV;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //view的宽高
    CGFloat WIDTH = self.view.frame.size.width;
    CGFloat HIGH = self.view.frame.size.height;
    
    //输入框
    inputTF = [[UITextField alloc]initWithFrame:CGRectMake(16, 30, WIDTH-32, 35)];
    inputTF.borderStyle = UITextBorderStyleRoundedRect;
    inputTF.backgroundColor = [UIColor groupTableViewBackgroundColor];
    inputTF.textColor = [UIColor purpleColor];
    inputTF.placeholder = @"请输入需要翻译的文字";
    [self.view addSubview:inputTF];
    
    //翻译按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(16, 80, WIDTH-32, 40)];
    [btn.layer setCornerRadius:5];
    [btn.layer setMasksToBounds:YES];
    [btn setBackgroundColor:[UIColor purpleColor]];
    [btn setTitle:@"翻 译" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //显示翻译结果
    showLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 140, WIDTH-32, 20)];
    showLabel.textColor = [UIColor purpleColor];
    showLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:showLabel];
    
    //下载地址  用\n换行了
    UILabel *download = [[UILabel alloc]initWithFrame:CGRectMake(10, 170, self.view.frame.size.width-20, 80)];
    download.text = @"demo下载地址：\nhttps://github.com/cjq002\n/youdao-openapi-iOSwithJson.git";
    download.textAlignment = NSTextAlignmentCenter;
    download.numberOfLines = 0;
    [self.view addSubview:download];
    
    //显示所有返回json数据
    showTV = [[UITextView alloc]initWithFrame:CGRectMake(16, 270, WIDTH-32, HIGH-286)];
    showTV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    showTV.textColor = [UIColor brownColor];
    showTV.font = [UIFont systemFontOfSize:16];
    showTV.editable = NO;
    [self.view addSubview:showTV];
}

//按钮响应事件
- (void)btnClick{
    if (inputTF.text.length > 0) {
        //调用翻译
        NSString *getString = [self translateText:inputTF.text];
        showLabel.text = [NSString stringWithFormat:@"翻译结果：%@",getString];
    }else{
        NSLog(@"输入内容不能为空");
    }
}

//翻译方法，传入和返回都是NSString类型
- (NSString *)translateText:(NSString *)string{
    
    NSString *strURL = [NSString stringWithFormat:@"http://fanyi.youdao.com/openapi.do?keyfrom=%@&key=%@&type=data&doctype=json&version=1.1&q=%@",YOUDAO_keyfrom,YOUDAO_key,[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
    
    NSError *err = nil;
    NSArray *strResult;
    if(strURL!=nil) {
        NSURL *url = [NSURL URLWithString:strURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&err];
        showTV.text = [NSString stringWithFormat:@"%@",dictionary];
        strResult = [dictionary objectForKey:@"translation"];
    }
    if(err){
        return [NSString stringWithFormat:@"error=%@", [err description]];
    }else {
        return [NSString stringWithFormat:@"%@", strResult[0]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
