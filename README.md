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
    
    		NSString *captchaId = @"ede087b9bdb0447e8ef64655785aab49";
    		[self.manager configureVerifyCode:captchaId timeout:5.0];
		}
		
* 3、在需要验证码验证的地方，调用SDK的openVerifyCodeView接口，如下:

   		[self.manager openVerifyCodeView];
   		
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

* 1、单例
	
		/**
 		*  @abstract 单例
 		*
 		*  @return 返回NTESVerifyCodeManager对象
 		*/
		+ (NTESVerifyCodeManager *)sharedInstance;

* 2、初始化

		/**
 		*  @abstract 配置参数
 		*
 		* @param captcha_id 验证码id
 		* @param timeoutInterval 加载验证码的超时时间,最长10s。这个时间尽量设置长一些，比如5秒以上(5-10s)
 		*
 		*/
		- (void)configureVerifyCode:(NSString *)captcha_id
                    timeout:(NSTimeInterval)timeoutInterval;

* 3、弹出验证码

		/**
 		*  @abstract 展示验证码视图
 		*
 		*/
		- (void)openVerifyCodeView;

* 4、log打印
		
		/**
 		*  是否开启sdk日志打印
 		*
 		*  @param enabled YES:开启;NO:不开启
 		*
 		*  @说明 默认为NO,只打印workflow;设为YES后，Release下只会打印workflow和BGRLogLevelError
 		*/
		- (void)enableLog:(BOOL)enabled;