# 行为式验证码
全新人机验证方式，高效拦截机器行为，业务安全第一道防线。搭载风险感知引擎，智能切换验证难度，安全性高，极致用户体验。读屏软件深度适配，视障群体也可轻松使用，符合工信部无障碍适配要求

## 平台支持（兼容性）

| 条目        | 说明                                                         |
| ----------- | ------------------------------------------------------------ |
| 适配版本    | iOS8以上                                                     |
| 开发环境    | Xcode 11.4                                                    |

## 环境准备

[ CocoaPods 安装教程](https://guides.cocoapods.org/using/getting-started.html)

## 资源引入/集成

### 通过 CocoaPods 自动集成

podfile 里面添加以下代码：

```ruby
 source 'https://github.com/CocoaPods/Specs.git' // 指定下载源
 
# 以下两种版本选择方式示例

# 集成最新版SDK:
pod 'NTESVerifyCode'

# 集成指定SDK，具体版本号可先执行 pod search NTESVerifyCode，根据返回的版本信息自行决定:
pod 'NTESVerifyCode', '~> 3.3.3'
```

* 保存并执行 pod install 即可，若未执行 pod repo update，请执行pod install --repo-update

### 手动集成
* 1、添加易盾SDK,将压缩包中所有资源添加到工程中(请勾选Copy items if needed选项)
* 2、添加依赖库，在项目设置target -> 选项卡General ->Linked Frameworks and Libraries添加如下依赖库，如果已存在如下的系统framework，则忽略： 
    * `SystemConfiguration.framework`
    * `JavaScriptCore.framework`
    * `WebKit.framework`

## 项目开发配置

* 1、在Xcode中找到`TARGETS-->Build Setting-->Linking-->Other Linker Flags`在这个选项中需要添加 `-ObjC`

## 调用示例

```

// 在项目需要使用SDK的文件中引入 #import <VerifyCode/NTESVerifyCodeManager.h>

@property(nonatomic, strong) NTESVerifyCodeManager *manager;

/// 获取验证码管理对象
self.manager = [NTESVerifyCodeManager getInstance];

// sdk 调用
 self.manager.mode = NTESVerifyCodeNormal;
        
[self.manager configureVerifyCode:请输入易盾业务ID timeout:超时时间];
  
// 显示验证码
[self.manager openVerifyCodeView:nil];
```
更多使用场景请参考 [demo](https://github.com/yidun/captcha-ios-demo)
  
## SDK 方法说明

### 1 获取 NTESVerifyCodeManager 实例化对象

在项目需要使用 SDK 的文件中先引入#import <VerifyCode/NTESVerifyCodeManager.h> 然后再初始化的 SDK，如下：

#### 代码说明：
```
self.manager = [NTESVerifyCodeManager getInstance];
```        
#### 返回值说明：

|类型|描述|
|----|----|
|NSObject|验证码实例化对象|
        
### 2 初始化

#### 代码说明：

```
[self.manager configureVerifyCode:请输入易盾业务ID timeout:超时时间];
```   

 * 入参说明：

    |参数|类型|是否必填|默认值|描述|
    |----|----|--------|------|----|
    | businessId |NSString|是|无|易盾分配的业务id|
    | timeout |NSString|是|无|加载验证码的超时时间,最长12秒。这个时间尽量设置长一些，比如7秒以上(7-12秒)|
    
### 3 验证码元素配置
配置项可以通过 self.manager 点语法配置 例如 self.manager.mode = NTESVerifyCodeNormal。

| 配置项 |类型|是否必填|默认值|描述|
|----|----|--------|------|----|
| frame | CGRect | 否 | NTESVerifyCodeNormal |验证码控件显示的位置,可以不传递。<br>(1)如果不传递或者传递为CGRectNull(CGRectZero),则使用默认值:topView的居中显示,宽度为屏幕宽度的4/5,高度:view宽度/2.0 + 65。 <br>(2)如果传递,则frame的宽度至少为270;高度至少为:宽度/2.0 + 65。|
| mode | enum | 否 | NTESVerifyCodeNormal | NTESVerifyCodeNormal 表示传统验证码<br> NTESVerifyCodeBind 表示无感知验证码|
| protocol | enum | 否 |NTESVerifyCodeProtocolHttps | NTESVerifyCodeProtocolHttps 表示 HTTPS 协议<br> NTESVerifyCodeProtocolHttp 表示 HTTP 协议|
| alpha | CGFloat | 否 |0.3 |验证码遮罩的透明度<br>范围:0~1，0表示全透明，1表示不透明。默认值:0.3|
| color | UIColor | 否 |blackColor |验证码遮罩的颜色，默认值：黑色|
| fallBackCount | NSUInteger | 否 | 3 | 设置发生第fallBackCount次错误时，将触发降级，取值范围 >=1。默认设置为3次，第三次服务器发生错误时，触发降级，直接通过验证。|
| openFallBack | BOOL | 否 | YES | 设置极端情况下，当验证码服务不可用时，是否开启降级方案。默认开启，当触发降级开关时，将直接通过验证，进入下一步。|
| closeButtonHidden | BOOL | 否 | NO |是否隐藏关闭按钮。默认不隐藏，设置为 YES 隐藏，NO 不隐藏|
| shouldCloseByTouchBackground | BOOL | 否 | YES |点击背景是否可以关闭验证码视图，默认可以关闭。|
| slideIconURL | NSString | 否 | 无 |验证码滑块 icon url，不传则使用易盾默认滑块显示。|
| delegate | id <NTESVerifyCodeManagerDelegate> | 否 | 无 |遵守协议 self.manager.delegate = self|
| lang | enum | 否 | NTESVerifyCodeLangCN | 设置验证码语言类型<br>NTESVerifyCodeLangCN 表示中文<br> NTESVerifyCodeLangEN 表示英文<br> NTESVerifyCodeLangTW 表示繁体<br> NTESVerifyCodeLangJP 表示日文<br> NTESVerifyCodeLangKR 表示韩文<br> NTESVerifyCodeLangTL 表示泰文<br> NTESVerifyCodeLangVT 表示越南语<br> NTESVerifyCodeLangFRA 表示法语<br> NTESVerifyCodeLangRUS 表示俄语<br> NTESVerifyCodeLangKSA 表示阿拉伯语 <br> NTESVerifyCodeLangDE 表示德语<br> NTESVerifyCodeLangIT 表示意大利语<br> NTESVerifyCodeLangHE 表示希伯来语<br> NTESVerifyCodeLangHI 表示印地语<br> NTESVerifyCodeLangID 表示印尼语<br> NTESVerifyCodeLangMY 表示缅甸语<br> NTESVerifyCodeLangLO 表示老挝语<br> NTESVerifyCodeLangMS 表示马来语<br> NTESVerifyCodeLangPL 表示波兰语<br> NTESVerifyCodeLangPT 表示葡萄牙语<br> NTESVerifyCodeLangES 表示西班牙语<br> NTESVerifyCodeLangTR 表示土耳其语|
| extraData | NSString | 否 | 无 |extraData透传业务数据|

### 4 弹出验证码

#### 代码说明：

```
[self.manager openVerifyCodeView:nil];
```
 * 入参说明：

    |类型|是否必填|默认值|描述|
    |----|--------|------|----|
    |UIView|否|无|在指定的视图上展示验证码视图，如果传递值为nil,则使用默认值:[[[UIApplication sharedApplication] delegate] window]|
    
### 5 关闭验证码

#### 代码说明：

```
[self.manager closeVerifyCodeView];
```
### 6 SDK 日志打印

#### 代码说明：

```
[self.manager enableLog:];
```

 * 入参说明：

    |类型|是否必填|默认值|描述|
    |----|--------|------|----|
    |BOOL|否|NO|是否开启 SDK 日志打印,YES 表示开启;NO 表示不开启。默认为 NO|
    
### 7 验证码 SDK 版本号

#### 代码说明：

```
NSString  *version = [self.manager getSDKVersion];
```

 * 返回值说明：

    |类型|描述|
    |----|----|
    |NSString|当前 SDK 的版本号|
    
### 8 验证码协议方法

#### 代码说明：

```
/**
 * 验证码组件初始化完成
 */
- (void)verifyCodeInitFinish;

/**
 * 验证码组件初始化出错
 *
 * @param error 错误信息
 */
- (void)verifyCodeInitFailed:(NSArray *)error;

/**
 * 完成验证之后的回调
 *
 * @param result 验证结果 BOOL:YES/NO
 * @param validate 二次校验数据，如果验证结果为false，validate返回空
 * @param message 结果描述信息
 *
 */
- (void)verifyCodeValidateFinish:(BOOL)result validate:(NSString *)validate message:(NSString *)message;

/**
 * 关闭验证码窗口后的回调
 *
 * @param close 关闭的类型
 */
- (void)verifyCodeCloseWindow:(NTESVerifyCodeClose)close;

```

