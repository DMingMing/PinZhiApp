//
//  ViewController.m
//  PinZhiApp
//
//  Created by MingMing on 16/12/10.
//  Copyright © 2016年 Luxshare. All rights reserved.
//

#import "ViewController.h"
#import "LoginViewController.h"
#import <SDAutoLayout.h>
#import "Public.h"
#import <ZBarSDK.h>
#import <AVFoundation/AVFoundation.h>
#import "ScanningViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "Base64.h"
@interface ViewController ()<UIWebViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
   
    UITextField*tf;
    UIWebView*web;
    NSString*strNumber;
}
@end

@implementation ViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *bigView = [[UIView alloc]init];
    bigView.frame = CGRectMake(0, 20,self.view.frame.size.width, self.view.frame.size.height/10);
    bigView.backgroundColor = [UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1];
    [self.view addSubview:bigView];
    
    UILabel *lab = [[UILabel alloc]init];
    lab.textColor = [UIColor whiteColor];
    lab.frame = CGRectMake(0, 0,self.view.frame.size.width, bigView.bounds.size.height);
    lab.userInteractionEnabled = YES;
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:[Public fontWithDevice:20]];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.text = @"测试";
    lab.userInteractionEnabled = YES;
    [bigView addSubview:lab];

    
    UIButton* buttonPerson = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonPerson setTitle:@"注销" forState:UIControlStateNormal];
    [buttonPerson setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buttonPerson.titleLabel.font = [UIFont systemFontOfSize:[Public fontWithDevice:15]];
    [buttonPerson addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [lab addSubview:buttonPerson];
    buttonPerson.sd_layout
    .rightSpaceToView(lab,20)
    .topSpaceToView(lab,10)
    .heightIs(self.view.frame.size.height/10-20)
    .widthEqualToHeight();
    
    
    
    //添加功能输入框和扫描按钮
    UILabel*lab1 = [[UILabel alloc]init];
    lab1.text = @"流程卡号";
    lab1.numberOfLines = 0;
    lab1.font = [UIFont boldSystemFontOfSize:[Public fontWithDevice:15]];
    lab1.textColor = [UIColor colorWithRed:31.0/255.0 green:120.0/255.0 blue:189.0/255.0 alpha:1];
    [self.view addSubview:lab1];
    CGSize size = [lab1.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:[Public fontWithDevice:15]],NSFontAttributeName, nil]];
    CGRect rect = [lab1.text boundingRectWithSize:CGSizeMake(size.width/2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:[Public fontWithDevice:15]],NSFontAttributeName, nil] context:nil];
    lab1.sd_layout
    .leftSpaceToView(self.view,10)
    .topSpaceToView(bigView,self.view.frame.size.height/30)
    .heightIs(self.view.frame.size.height/12)
    .widthIs(rect.size.width+5);
    
    tf = [[UITextField alloc]init];
    tf.placeholder = @"请输入流程卡号";
    tf.font = [UIFont systemFontOfSize:[Public fontWithDevice:15]];
    tf.borderStyle = UITextBorderStyleLine;
    [self.view addSubview:tf];
    tf.sd_layout
    .leftSpaceToView(lab1,5)
    .topEqualToView(lab1)
    .heightIs(self.view.frame.size.height/12)
    .widthIs(self.view.bounds.size.width-size.width-10-self.view.frame.size.width*0.1);
    
    UIButton* buttonScn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonScn setBackgroundImage:[UIImage imageNamed:@"comm-saoyisao"] forState:UIControlStateNormal];
    [buttonScn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonScn];
    buttonScn.sd_layout
    .leftSpaceToView(tf,self.view.bounds.size.width*0.03)
    .topSpaceToView(bigView,self.view.frame.size.height/30+tf.bounds.size.height/2-tf.bounds.size.height/1.3/2)
    .heightIs(tf.bounds.size.height/1.3)
    .widthEqualToHeight();
    
   
    //创建一个网页加载页面  默认加载也页面
    web = [[UIWebView alloc]init];
    web.scrollView.bounces=NO;
    web.delegate = self;
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://dcs.luxshare-ict.com:8001/IPQCReport/IPQCProcess/Schedule?EmpCode=%@",@"C059872"]]]];
    [self.view addSubview:web];
    
    web.sd_layout
    .leftSpaceToView(self.view,10)
    .rightSpaceToView(self.view,10)
    .topSpaceToView(tf,20)
    .bottomEqualToView(self.view);
    
     //接收扫描的二维码信息 进行页面内容的更换
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getCode:) name:@"scanCode" object:nil];
    

}
//获取到扫描结果后
-(void)getCode:(NSNotification*)notify{
    NSString *codeString = [notify.userInfo objectForKey:@"code"];
    NSString*name = [[NSUserDefaults standardUserDefaults] objectForKey:@"tfName"];
    tf.text = codeString;
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://dcs.luxshare-ict.com:8001/IPQCReport/IPQCProcess/Index?Moid=%@&EmpCode=%@",codeString,name]]]];
}

#pragma mark----------------------点击扫描按钮
-(void)scanBtnClick{
    //点击扫描按钮 进行跳转到扫描页面
    ScanningViewController*scan = [[ScanningViewController alloc]init];
    [self presentViewController:scan animated:YES completion:nil];
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}
//页面加载完成
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    
    ViewController*view = self;
    //获取js对象
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    //js调用oc的方法  js中有这样一个方法 找到这个方法
    context[@"showToast"] = ^(){
        // 遍历出这个方法的参数
        NSArray *args = [JSContext currentArguments];
        for (id obj in args) {
            strNumber = obj;
            NSLog(@"------%@",obj);
        }
        // 开启主线程 进行拍照
        dispatch_async(dispatch_get_main_queue(), ^{
            [view addPicEvent];
        });

        
    
    };
    
   
}
#pragma mark----------------------添加拍照功能
-(void)addPicEvent{

    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = sourceType;
    [self presentViewController:picker animated:YES completion:nil];
   
}
#pragma mark----------------------对图片进行缩放
-(UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize,image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height *scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
#pragma mark----------------------拍照结束
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    //图片压缩，因为原图都是很大的，不必要传原图
    //将图片转换为JPG格式的二进制数据
    NSData *data= UIImageJPEGRepresentation(image, 0.3f);
    NSString*str = [data base64EncodedString];
    //调用js的方法 传参数 js中有这样的方法 需要传递两个参数
    [web stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"savePic('%@','%@')",str,strNumber]];

    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark----------------------点击拍照取消
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark----------------------注销登陆按钮
-(void)rightBtnClick:(UIButton*)button{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要注销登录吗" message:nil preferredStyle:UIAlertControllerStyleAlert];
   
        UIAlertAction*action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
        return ;
    }];
    [alert addAction:action1];
    
    UIAlertAction*action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"key"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [alert dismissViewControllerAnimated:YES completion:nil];
        if (self.through == 10) {
            LoginViewController*login = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:login animated:YES];
        }else if(self.through == 20){
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    [alert addAction:action2];
    
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
// 页面注销的时候移除通知 防止内存泄漏
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
