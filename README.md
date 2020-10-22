# iOS

## 运行环境
SDK 兼容系统版本 iOS 8.0+

## SDK集成

### CocoaPods集成方式
 1.更新Podfile文件

	在工程的 Podfile 里对应的 Target 中添加以下代码
	
		pod 'NTESVerifyCode'
		
 2.集成SDK
	
	在工程的当前目录下, 运行 `pod install` 或者 `pod update`
	
 3.工程设置
	
	在工程target目录内，需将Build Settings —> other link flags设置为-ObjC。
	
	__备注:__
	
	(1). 命令行下执行`pod search NTESVerifyCode`,如显示的`NTESVerifyCode`版本不是最新的，则先执行`pod update`操作更新本地repo的内容

	(2). 如果想使用最新版本的SDK，则执行`pod update`
	
	(3). 如果你的工程设置的"Deplyment Target"低于 9.0，则在Podfile文件的前面加上以下语句
platform :ios, '9.0'

### 手动集成方式

 1.下载VerifyCode SDK包

  **原生Demo下载：** [https://github.com/yidun/captcha-ios-demo](https://github.com/yidun/captcha-ios-demo)
	 
	 **RN Demo下载：** [React Native Demo](https://nos.netease.com/cloud-website-bucket/6903d3dcb564b09f3971351bf039e848.rar)
     
 2.导入 `VerifyCode.framework` 到XCode工程：
   
	 拖拽`VerifyCode.framework`文件到Xcode工程内(请勾选Copy items if needed选项)
  
 3.导入`NTESVerifyCodeResources.bundle`到工程中：
   
	 进入`Build Phase`，在`Copy Bundle Resources`选项中，添加`NTESVerifyCodeResources.bundle`文件(请勾选Copy items if needed选项) 。
 
 4.添加依赖库
  
	`SystemConfiguration.framework` `JavaScriptCore.framework`、`WebKit.framework`
  
 5.工程设置
	
	在工程target目录内，需将Build Settings —> other link flags设置为-ObjC。
  
   __备注:__  
   (1)如果已存在上述的系统framework，则忽略
   
   (2)SDK 最低兼容系统版本 iOS 9.0

  
### SDK 使用

#### Object-C 工程

1.在项目需要使用SDK的文件中引入VerifyCode SDK头文件，如下：

		#import <VerifyCode/NTESVerifyCodeManager.h>
		
2.在页面初始化的地方初始化 SDK，SDK同时支持无感知验证码和常规验证码，需在官网申请不同的captchaID，如下：

		- (void)viewDidLoad {
    		[super viewDidLoad];  
				
    		// sdk调用
    		self.manager = [NTESVerifyCodeManager getInstance];
    		self.manager.delegate = self;
    		
    		// 设置透明度
        	self.manager.alpha = 0.7;
        
        	// 设置frame
        	self.manager.frame = CGRectNull;
    
     		// captchaId从网易申请，比如@"a05f036b70ab447b87cc788af9a60974"
     		
			// 常规验证码（滑块拼图、图中点选、短信上行）
			// NSString *captchaid = @"deecf3951a614b71b4b1502c072be1c1";
			// self.manager.mode = NTESVerifyCodeNormal;
        
	        // 智能无感知验证码
	        NSString *captchaid = @"6a5cab86b0eb4c309ccb61073c4ab672";
	        self.manager.mode = NTESVerifyCodeBind;
		}
		
3.在需要验证码验证的地方，调用SDK的openVerifyCodeView接口，如下:

   		[self.manager openVerifyCodeView:nil];
   		
4.如果需要处理VerifyCode SDK的回调信息，则实现NTESVerifyCodeManagerDelegate即可
		
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
 		* @param error 错误信息，建议直接打印错误码，便于排查问题
 		*/
		- (void)verifyCodeInitFailed:(NSArray *)error{
    		// App添加自己的处理逻辑
		}
	
(3) 验证结果回调
		
		/**
 		* 完成验证之后的回调
 		* @param result 验证结果 BOOL:YES/NO
 		* @param validate 二次校验数据，如果验证结果为false，validate返回空
 		* @param message 结果描述信息
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
		- (void)verifyCodeCloseWindow:(NTESVerifyCodeClose)close {
    		//App添加自己的处理逻辑
		}  

### Swift 工程

1.在项目对应的 bridging-header.h 中引入头文件，如下：

		#import <VerifyCode/NTESVerifyCodeManager.h>
	
 
 __备注:__  Swift 调用 Objective-C 需要一个名为 `<工程名>-Bridging-Header.h` 的桥接头文件。文件的作用为 Swift 调用 Objective-C 对象提供桥接。


2.其他调用同上

## SDK 接口

1.枚举

		/**
 		* @abstract    设置验证码语言类型
 		*/
		typedef NS_ENUM(NSInteger, NTESVerifyCodeLang) {
		    // 中文
		    NTESVerifyCodeLangCN = 1,
		    // 英文
		    NTESVerifyCodeLangEN,
		    // 繁体
		    NTESVerifyCodeLangTW,
		    // 日文
		    NTESVerifyCodeLangJP,
		    // 韩文
		    NTESVerifyCodeLangKR,
		    // 泰文
		    NTESVerifyCodeLangTL,
		    // 越南语
		    NTESVerifyCodeLangVT,
		    // 法语
		    NTESVerifyCodeLangFRA,
		    // 俄语
		    NTESVerifyCodeLangRUS,
		    // 阿拉伯语
		    NTESVerifyCodeLangKSA,
		    // 德语
		    NTESVerifyCodeLangDE,
		    // 意大利语
		    NTESVerifyCodeLangIT,
		    // 希伯来语
		    NTESVerifyCodeLangHE,
		    // 印地语
		    NTESVerifyCodeLangHI,
		    // 印尼语
		    NTESVerifyCodeLangID,
		    // 缅甸语
		    NTESVerifyCodeLangMY,
		    // 老挝语
		    NTESVerifyCodeLangLO,
		    // 马来语
		    NTESVerifyCodeLangMS,
		    // 波兰语
		    NTESVerifyCodeLangPL,
		    // 葡萄牙语
		    NTESVerifyCodeLangPT,
		    // 西班牙语
		    NTESVerifyCodeLangES,
		    // 土耳其语
		    NTESVerifyCodeLangTR,
		};
		
		/**
 		* @abstract    设置验证码类型
 		*/
		typedef NS_ENUM(NSInteger, NTESVerifyCodeMode) {
		    // 普通验证码
		    NTESVerifyCodeNormal = 1,
		    // 无感知验证码
		    NTESVerifyCodeBind,
		};
        
        /**
        * @abstract    验证码关闭的类型
        */
        typedef NS_ENUM(NSInteger, NTESVerifyCodeClose) {
            // 手动关闭
            NTESVerifyCodeCloseManual = 1,
            // 验证完毕后自动关闭
            NTESVerifyCodeCloseAuto,
        };


2.属性
		
		/**
 		* @abstract    验证码图片显示的frame
 		* @说明         验证码控件显示的位置,可以不传递。
 		*              (1)如果不传递或者传递为CGRectNull(CGRectZero),则使用默认值:topView的居中显示,宽度为屏幕宽度的4/5,高度:view宽度/2.0 + 65
 		*              (2)如果传递,则frame的宽度至少为270;高度至少为:宽度/2.0 + 65.
 		*/
		@property(nonatomic) CGRect            frame;

- 



		/**
	 	* @abstract    验证码图片背景的透明度
 		* @说明         范围:0~1，0表示全透明，1表示不透明。默认值:0.8
 		*/
		@property(nonatomic) CGFloat           alpha;
		
-


		/**
		 * @abstract    验证码图片背景的颜色
		 * @说明         默认值:黑色
		 */
		@property(nonatomic) UIColor           *color;

- 



		/**
 		 * @abstract    验证码语言选项
		 * @说明         验证码枚举类型NTESVerifyCodeLang，NTESVerifyCodeLangCN表示中文，NTESVerifyCodeLangEN表示英文
 		 *              不传默认中文。
 		 */
		 @property(nonatomic) NTESVerifyCodeLang    lang;
		 
- 
	 
		
        
        /**
 		* @abstract    验证码滑块icon url，不传则使用易盾默认滑块显示。
 		*/
		@property(nonatomic) NSString *slideIconURL;

- 

		
        
        /**
		 * @abstract    验证码验证成功的滑块icon url，不传则使用易盾默认滑块显示。
		 */
		@property(nonatomic) NSString *slideIconSuccessURL;		

-

		/**
		 * @abstract    验证码验证失败的滑块icon url，不传则使用易盾默认滑块显示。
		 */
		@property(nonatomic) NSString *slideIconErrorURL;
		
- 

		
        
        /**
		 * @abstract    设置验证码类型
		 * @说明         验证码枚举类型NTESVerifyCodeMode，可选类型见枚举定义
		 *              不传默认常规验证码（滑块拼图、图中点选、短信上行）。
		 */
		@property(nonatomic) NTESVerifyCodeMode mode;		
		
- 

	    
        
        /**
		 * @abstract    设置极端情况下，当验证码服务不可用时，是否开启降级方案。
		 *              默认开启，当触发降级开关时，将直接通过验证，进入下一步。
		 */
		@property(nonatomic) BOOL openFallBack;
		
- 	


		  /**
	 	  * @abstract    设置发生第fallBackCount次错误时，将触发降级。取值范围 >=1
		   *            默认设置为3次，第三次服务器发生错误时，触发降级，直接通过验证。
		   */
		 @property(nonatomic) NSUInteger fallBackCount;	
		
-

		/**
		* @abstract    是否隐藏关闭按钮
		*              默认不隐藏，设置为YES隐藏，NO不隐藏
		*/
		@property(nonatomic) BOOL closeButtonHidden;	


 - 
 
 
 
       /**
       * @abstract    点击背景是否可以关闭验证码视图
       *              默认可以关闭，设置为YES可以关闭，NO不可以关闭
       */
       @property(nonatomic) BOOL shouldCloseByTouchBackground;	
       
 -        
       
       
        /**
 		* @abstract   验证码ipv6配置。
 		*             默认为 no，传 yes 表示支持ipv6网络。
 		*/
		@property(nonatomic) BOOL ipv6;


-   


 3.初始化
	
		/**
 		* @abstract 	初始化方法
 		* @return 		返回NTESVerifyCodeManager对象
 		*/
		+ (NTESVerifyCodeManager *)getInstance;

 4.配置参数

		/**
		 *  @abstract   配置参数
		 *  @param      captcha_id      验证码id
		 *  @param      timeoutInterval 加载验证码的超时时间,最长12s。这个时间尽量设置长一些，比如7秒以上(7-12s)
		 */
		- (void)configureVerifyCode:(NSString *)captcha_id
                    timeout:(NSTimeInterval)timeoutInterval;

 5.弹出验证码

		/**
 		*  @abstract 展示验证码视图
 		*  @说明      展示位置:[[[UIApplication sharedApplication] delegate] window];全屏居中显示,宽度为屏幕宽度的4/5,高度:view宽度/2.0 + 65.
 		*/
		- (void)openVerifyCodeView;

		/**
 		*  @abstract   在指定的视图上展示验证码视图
 		*  @param      topView         加载验证码控件的父视图,可以为nil。
 		*                              (1)如果传递值为nil,则使用默认值:[[[UIApplication sharedApplication] delegate] window]
 		*                              (2)如果传递值不为nil，则注意topView的宽高值，宽度至少为270;高度至少为:宽度/2.0 + 65.
	 	*/
		- (void)openVerifyCodeView:(UIView *)topView;


 6.log打印
		
		/**
 		*  @abstract	是否开启sdk日志打印
 		*  @param 		enabled 		YES:开启;NO:不开启
 		*  @说明 		   默认为NO,只打印workflow;设为YES后，Release下只会打印workflow和BGRLogLevelError
 		*/
		- (void)enableLog:(BOOL)enabled;
 7.获取验证码SDK版本号

	
		/**
		* @abstract    验证码SDK版本号
		*/
		- (NSString *)getSDKVersion;


8.自定义loading文案
 
    /**
     *  @abstract   自定义loading文案
     *
     *  @param      loadingText  加载中的文案
     *
     */
    - (void)configLoadingText:(NSString * _Nullable)loadingText;

9.自定义loading图片， 支持gif、 png 、 jpg等格式。

    /**
     *  @abstract  自定义loading图片， 支持gif、 png 、 jpg等格式。
     *
     *  @说明      自定义 loading图片的参数配置。
     *            (1) 图片格式为 gif 只需要传gifData 即可， animationImage传空。
     *            (2) 图片格式为 png、 jpg时，需要配置animationImage ,gitData传空。
     *
     *  @param      animationImage  单张图片 ，
     *  @param      gifData 图片格式为gif的二进制数据
     */
	- (void)configLoadingImage:(UIImage *_Nullable)animationImage
                   gifData:(NSData *_Nullable)gifData;
		
## 错误码定义

SDK会在回调方法`verifyCodeInitFailed:`和`verifyCodeNetError:`中抛出错误码，错误码说明如下：

| 错误码 | 说明 |
| -------| -----|
| 501 | get请求失败 |
| 502 | js资源加载超时 |
| 503 | 图片加载超时 |
| 1004 | 初始化失败 |
| -1005 | 无网络连接 |
		
## 效果演示

 1.初始化
	<img src="https://github.com/yidun/captcha-ios-demo/raw/master/screenshots/init.jpg" width="50%" height="50%">
	
	
 2.滑块验证
	<img src="https://nos.netease.com/cloud-website-bucket/b981f3b08f1967f0aceab48ea3d6621a.png" width="50%" height="50%">
	
	
 3.点选验证	
	<img src="https://nos.netease.com/cloud-website-bucket/85ef8f718f6fd7774c27859938843343.png" width="50%" height="50%">
	
 4.短信验证	
	<img src="https://nos.netease.com/cloud-website-bucket/b81b5f6cfd25e813de76eef0cee29d9e.png" width="50%" height="50%">

