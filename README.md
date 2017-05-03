VerifyCode iOS SDK 接入指南
===

### 一、SDK集成

#### 手动集成方式

* 1、获取VerifyCode SDK包。

* 2、导入 `VerifyCode.framework` 到XCode工程：
  * 拖拽`VerifyCode.framework`文件到Xcode工程内(请勾选Copy items if needed选项)
  
  * 添加依赖库
  `SystemConfiguration.framework` `JavaScriptCore.framework`、`WebKit.framework`
  
   __备注:__  
   (1)如果已存在上述的系统framework，则忽略
   
   (2)SDK 最低兼容系统版本 iOS 7.0

  
### 二、SDK 使用

#### 2.1 Object-C 工程

* 1、在项目需要使用SDK的文件中引入VerifyCode SDK头文件，如下：

		#import <VerifyCode/NTESVerifyCodeManager.h>
		
* 2、在页面初始化的地方初始化 SDK，如下：

		- (void)viewDidLoad {
    		[super viewDidLoad];
    
    
    		// sdk调用
    		self.manager = [NTESVerifyCodeManager sharedInstance];
    		self.manager.delegate = self;
    		// 设置背景透明度
    		manager.alpha = 0.7;
    
    		NSString *captchaId = @"ede087b9bdb0447e8ef64655785aab49";
    		[self.manager configureVerifyCode:captchaId timeout:5.0];
		}
		
* 3、在需要验证码验证的地方，调用SDK的openVerifyCodeView接口，如下:

   		[manager openVerifyCodeView:nil];
   		
* 4、如果需要处理VerifyCode SDK的回调信息，则实现NTESVerifyCodeManagerDelegate即可
		

	(1) 初始化完成
		
		/**
 		* 验证码组件初始化完成
 		*/
		- (void)verifyCodeInitFinish{
    		// App添加自己的处理逻辑 
		}

    (2) 初始化出错
		
		/**
 		* 验证码组件初始化出错
 		*
 		* @param message 错误信息
 		*/
		- (void)verifyCodeInitFailed:(NSString *)message{
    		// App添加自己的处理逻辑
		}
	
	(3) 验证结果回调
		
		/**
 		* 完成验证之后的回调
 		*
 		* @param result 验证结果 BOOL:YES/NO
 		* @param validate 二次校验数据，如果验证结果为false，validate返回空
 		* @param message 结果描述信息
 		*
 		*/
		- (void)verifyCodeValidateFinish:(BOOL)result 
									validate:(NSString *)validate 
									message:(NSString *)message{
			// App添加自己的处理逻辑
    	}

	(4) 关闭验证码窗口的回调
		
		/**
 		* 关闭验证码窗口后的回调
 		*/
		- (void)verifyCodeCloseWindow{
    		//App添加自己的处理逻辑
		}

    (5) 网络错误
		
		/**
 		* 网络错误
 		*
 		* @param error 网络错误信息
 		*/
		- (void)verifyCodeNetError:(NSError *)error{
    		//App添加自己的处理逻辑
		}

       
       __备注:__  如果不需要处理VerifyCode SDK的回调信息，也可不实现

#### 2.2 Swift 工程

* 1、在项目对应的 bridging-header.h 中引入头文件，如下：

		#import <VerifyCode/NTESVerifyCodeManager.h>
	
 
 __备注:__  Swift 调用 Objective-C 需要一个名为 `<工程名>-Bridging-Header.h` 的桥接头文件。文件的作用为 Swift 调用 Objective-C 对象提供桥接。

* 2、其他调用同上

### 三、SDK 接口

* 1、属性
		
		/**
 		* @abstract    delegate,见NTESVerifyCodeManagerDelegate
 		*/
		@property(nonatomic, weak) id<NTESVerifyCodeManagerDelegate>delegate;

		/**
 		* @abstract    验证码图片显示的frame
 		*
 		* @说明         验证码控件显示的位置,可以不传递。如果不传递或者传递为CGRectNull(CGRectZero),则使用默认值:topView的居中显示,宽度为屏幕宽度的4/5,高度为宽度的5/9
 		*/
		@property(nonatomic) CGRect            frame;

		/**
	 	* @abstract    验证码图片背景的透明度
 		*
 		* @说明         范围:0~1，0表示全透明，1表示不透明。默认值:0.8
 		*/
		@property(nonatomic) CGFloat           alpha;

* 2、单例
	
		/**
 		*  @abstract 	单例
 		*
 		*  @return 		返回NTESVerifyCodeManager对象
 		*/
		+ (NTESVerifyCodeManager *)sharedInstance;

* 3、初始化

		/**
 		*  @abstract 	配置参数
 		*
 		* @param 		captcha_id 			验证码id
 		* @param 		timeoutInterval 	加载验证码的超时时间,最长10s。这个时间尽量设置长一些，比如5秒以上(5-10s)
 		*
 		*/
		- (void)configureVerifyCode:(NSString *)captcha_id
                    timeout:(NSTimeInterval)timeoutInterval;

* 4、弹出验证码

		/**
 		*  @abstract 展示验证码视图
 		*
 		*  @说明      展示位置:[[[UIApplication sharedApplication] delegate] window];全屏居中显示,宽度为屏幕宽度的4/5,高度为宽度的5/9.
 		*/
		- (void)openVerifyCodeView;
- 


		/**
 		*  @abstract   在指定的视图上展示验证码视图
 		*
 		*  @param      topView         加载验证码控件的父视图,可以为nil。如果传递为nil,则使用默认值:[[[UIApplication sharedApplication] delegate] window]
 		*
 		*/
		- (void)openVerifyCodeView:(UIView *)topView;


* 5、log打印
		
		/**
 		*  @abstract	是否开启sdk日志打印
 		*
 		*  @param 		enabled 		YES:开启;NO:不开启
 		*
 		*  @说明 		   默认为NO,只打印workflow;设为YES后，Release下只会打印workflow和BGRLogLevelError
 		*/

		
### 四、注意事项

* 1、验证码视图为什么没有显示？
	 
	 没有显示的原因是topView获取的方式在不同的条件下，需要修改。
	 它的实现代码在`NTESVCController.m`文件里，对应的方法为: `- (UIView *)getTopView`
	 
	    - (UIView *)getTopView{
    
           UIView *topView = [[[UIApplication sharedApplication] delegate] window];

           return topView;
        }
        
     这段代码的意思是，在多个UIWindow存在的情况下，获取正在使用的UIWindow作为topView。
     不同的产品可以根据自己的需求修改这段代码，比如直接使用keyWindow或者任意自定义的UIWindow作为topView，或者以UIWindow的subviews的最前面的视图作为topView，例如:
     
     
        - (UIView *)getTopView{
    
           UIView *topView = nil;
    
           UIApplication *app = [UIApplication sharedApplication];
           if (app) {
               UIWindow *topWindow = [[[UIApplication sharedApplication].windows  sortedArrayUsingComparator:^NSComparisonResult(UIWindow *win1, UIWindow *win2) {
                 return win1.windowLevel - win2.windowLevel;
               }] lastObject];
               topView = [[topWindow subviews] lastObject];
          }
    
          return topView;
        }