//
//  LoginViewController.m
//  PinZhiApp
//
//  Created by MingMing on 16/12/10.
//  Copyright © 2016年 Luxshare. All rights reserved.
//

#import "LoginViewController.h"
#import <SDAutoLayout.h>
#import "RequestTool.h"
#import "ViewController.h"
#import "Public.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField*_tfName,*_tfPsw;
}

@end

@implementation LoginViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    [self creatLoginView];
    
    NSString*name = [[NSUserDefaults standardUserDefaults] objectForKey:@"tfName"];
    NSString*psw = [[NSUserDefaults standardUserDefaults] objectForKey:@"tfPsw"];
    _tfName.text = name;
    _tfPsw.text = psw;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
}
//添加视图
-(void)creatLoginView{
    
    UILabel *lab = [[UILabel alloc]init];
    lab.frame = CGRectMake(0, 30, self.view.frame.size.width, 39);
    lab.textColor = [UIColor blackColor];
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:[Public fontWithDevice:16]];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"用户登录";
    [self.view addSubview:lab];
    
    
    UIImageView *imageLogin = [[UIImageView alloc]initWithFrame:CGRectMake(10, 70,self.view.frame.size.width-20, self.view.frame.size.height/6)];
    imageLogin.image = [UIImage imageNamed:@"logol"];
    [self.view addSubview:imageLogin];
    
    _tfName = [[UITextField alloc]init];
    _tfName.placeholder = @" 请输入用户名";
    _tfName.borderStyle = UITextBorderStyleLine;
    _tfName.layer.borderWidth = .2;
    _tfName.tag = 10;
    _tfName.layer.borderColor = [UIColor blackColor].CGColor;
    _tfName.clearButtonMode = UITextFieldViewModeUnlessEditing;
    _tfName.delegate = self;
    _tfName.font = [UIFont systemFontOfSize:[Public fontWithDevice:14]];
    [self.view addSubview:_tfName];
    _tfName.sd_layout
    .leftSpaceToView(self.view,30)
    .rightSpaceToView(self.view,30)
    .topSpaceToView(imageLogin,self.view.bounds.size.height/20)
    .heightIs(self.view.bounds.size.height/11);
    
    _tfPsw = [[UITextField alloc]init];
    _tfPsw.placeholder = @" 请输入密码";
    _tfPsw.borderStyle = UITextBorderStyleLine;
    _tfPsw.layer.borderWidth = .2;
    _tfPsw.tag = 20;
    _tfPsw.font = [UIFont systemFontOfSize:[Public fontWithDevice:14]];
    _tfPsw.delegate = self;
    _tfPsw.secureTextEntry = YES;
    _tfPsw.clearButtonMode = UITextFieldViewModeUnlessEditing;
    _tfPsw.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:_tfPsw];
    _tfPsw.sd_layout
    .leftSpaceToView(self.view,30)
    .rightSpaceToView(self.view,30)
    .topSpaceToView(_tfName,self.view.bounds.size.height/20)
    .heightIs(self.view.bounds.size.height/11);

    
    UIButton *button = [[UIButton alloc]init];
    [button setBackgroundColor:[UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1]];
    button.titleLabel.font = [UIFont systemFontOfSize:[Public fontWithDevice:15]];
    [button setTitle:@"登录" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    [self.view addSubview:button];
    button.sd_layout
    .leftSpaceToView(self.view,30)
    .rightSpaceToView(self.view,30)
    .topSpaceToView(_tfPsw,70)
    .heightIs(self.view.bounds.size.height/12);
    
}
-(void)buttonClick{
    
    NSString *newString = [_tfName.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *newStringPsw = [_tfPsw.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    // 判断输入的字符串中是否含有最特殊字符 进行处理
    NSString *str1 =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str1];
    if (![emailTest evaluateWithObject:newString]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请检查输入是否正确！不要还有特殊符号" message:nil preferredStyle:UIAlertControllerStyleAlert]; UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }else{
    unichar c = [newString characterAtIndex:0];
    if (c >=0x4E00 && c <=0x9FFF)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请输入正确的工号" message:nil preferredStyle:UIAlertControllerStyleAlert]; UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            return ;
        }];
        [alert addAction:sure];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }else{
        
            
        //将账号密码存储在本地
        [[NSUserDefaults standardUserDefaults]setObject:[[newString capitalizedString] stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"tfName"];
        [[NSUserDefaults standardUserDefaults]setObject:[newStringPsw stringByReplacingOccurrencesOfString:@" " withString:@""] forKey:@"tfPsw"];
         [[NSUserDefaults standardUserDefaults]setObject:@"key" forKey:@"key"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        ViewController *view = [[ViewController alloc]init];
        view.through = 20;
        [self.navigationController pushViewController:view animated:YES];
    }
 }
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_tfName resignFirstResponder];
    [_tfPsw resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 10) {
        [_tfName  resignFirstResponder];
        [_tfPsw becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
