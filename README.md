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
| lang | enum | 否 | NTESVerifyCodeLangCN | 设置验证码语言类型<br>NTESVerifyCodeLangCN 表示中文<br> NTESVerifyCodeLangEN 表示英文<br> NTESVerifyCodeLangTW 表示繁体<br> NTESVerifyCodeLangJP 表示日文<br> NTESVerifyCodeLangKR 表示韩文<br> NTESVerifyCodeLangTL 表示泰文<br> NTESVerifyCodeLangVT 表示越南语<br> NTESVerifyCodeLangFRA 表示法语<br> NTESVerifyCodeLangRUS 表示俄语<br> NTESVerifyCodeLangKSA 表示阿拉伯语 <br> NTESVerifyCodeLangDE 表示德语<br> NTESVerifyCodeLangIT 表示意大利语<br> NTESVerifyCodeLangHE 表示希伯来语<br> NTESVerifyCodeLangHI 表示印地语<br> NTESVerifyCodeLangID 表示印尼语<br> NTESVerifyCodeLangMY 表示缅甸语<br> NTESVerifyCodeLangLO 表示老挝语<br> NTESVerifyCodeLangMS 表示马来语<br> NTESVerifyCodeLangPL 表示波兰语<br> NTESVerifyCodeLangPT 表示葡萄牙语<br> NTESVerifyCodeLangES 表示西班牙语<br> NTESVerifyCodeLangTR 表示土耳其语 <br> NTESVerifyCodeLangNL 表示荷兰语<br> NTESVerifyCodeLangUG 表示维吾尔语 <br> NTESVerifyCodeLangMN 表示蒙古语 <br> NTESVerifyCodeLangMAI 表示迈蒂利语 <br> NTESVerifyCodeLangAS 表示阿萨姆语 <br> NTESVerifyCodeLangPA 表示旁遮普语 <br> NTESVerifyCodeLangOR 表示欧里亚语 <br> NTESVerifyCodeLangML 表示马来亚拉姆语 <br> NTESVerifyCodeLangKN 表示卡纳达语 <br> NTESVerifyCodeLangGU 表示古吉拉特语 <br> NTESVerifyCodeLangTA 表示泰米尔语 <br> NTESVerifyCodeLangMR 表示马拉地语 <br> NTESVerifyCodeLangTE 表示泰卢固语 <br> NTESVerifyCodeLangAM 表示阿姆哈拉语 <br> NTESVerifyCodeLangMI 表示毛利语 <br> NTESVerifyCodeLangSW 表示斯瓦西里语 <br> NTESVerifyCodeLangNE 表示尼泊尔语  <br> NTESVerifyCodeLangJV 表示爪哇语 <br> NTESVerifyCodeLangFIL 表示菲律宾语  <br> NTESVerifyCodeLangBN 表示孟加拉语 <br> NTESVerifyCodeLangKK 表示哈萨克语（西里尔文） <br> NTESVerifyCodeLangBE 表示白俄罗斯语 <br> NTESVerifyCodeLangBO 表示藏语 <br> NTESVerifyCodeLangUR 表示乌尔都语 <br> NTESVerifyCodeLangSI 表示僧伽罗语  <br> NTESVerifyCodeLangKM 表示高棉语 <br> NTESVerifyCodeLangUZ 表示乌兹别克语 <br> NTESVerifyCodeLangAZ 表示阿塞拜疆语 <br> NTESVerifyCodeLangKA 表示格鲁吉亚语 <br> NTESVerifyCodeLangEU 表示巴斯克语 <br> NTESVerifyCodeLangGL 表示加利西亚语 <br> NTESVerifyCodeLangCA 表示加泰罗尼亚语<br> NTESVerifyCodeLangFA 表示波斯语 <br> NTESVerifyCodeLangUK 表示乌克兰语 <br> NTESVerifyCodeLangHR 表示克罗地亚语 <br> NTESVerifyCodeLangSL 表示斯洛文尼亚语 <br> NTESVerifyCodeLangLT 表示立陶宛语 <br> NTESVerifyCodeLangLV 表示拉脱维亚语 <br> NTESVerifyCodeLangET 爱沙尼亚语 <br> NTESVerifyCodeLangFI 表示芬兰语 <br> NTESVerifyCodeLangBG 表示保加利亚语 <br> NTESVerifyCodeLangMK 表示马其顿语 <br> NTESVerifyCodeLangBS 表示波斯尼亚语 <br> NTESVerifyCodeLangSR 表示塞尔维亚语（拉丁文）<br> NTESVerifyCodeLangEL 表示希腊语 <br> NTESVerifyCodeLangRO 表示罗马尼亚语 <br> NTESVerifyCodeLangSK 表示斯洛伐克语 <br> NTESVerifyCodeLangHU 表示匈牙利语 <br> NTESVerifyCodeLangCS 表示捷克语 <br> NTESVerifyCodeLangDA 表示丹麦语 <br> NTESVerifyCodeLangNN 表示挪威语 <br> NTESVerifyCodeLangSV 表示瑞典语 <br> NTESVerifyCodeLangPTBR 表示巴西葡语 <br> NTESVerifyCodeLangESLA 表示拉美西语|
| extraData | NSString | 否 | 无 |extraData透传业务数据|
| deviceOrientation | enum | 否 | 无 |NTESDeviceOrientationUnknown 方向未知 <br> NTESDeviceOrientationPortrait 固定竖屏，验证码不会跟随设备旋转而旋转  <br> NTESDeviceOrientationLandscape 固定横屏，验证码不会跟随设备旋转而旋转 |

### 4 弹出验证码

#### 代码说明：

```
[self.manager openVerifyCodeView:nil];
```
 * 入参说明：

    |类型|是否必填|默认值|描述|
    |----|--------|------|----|
    |UIView|否|无|在指定的视图上展示验证码视图，如果传递值为nil,则使用默认值:[[[UIApplication sharedApplication] delegate] window]|

### 5 弹出验证码、自定义加载页和错误页

#### 代码说明：

```
[[self.manager openVerifyCodeView:nil customLoading:YES customErrorPage:YES];];
```
 * 入参说明：

    |类型|是否必填|默认值|描述|
    |----|--------|------|----|
    |UIView|否|无|在指定的视图上展示验证码视图，如果传递值为nil,则使用默认值:[[[UIApplication sharedApplication] delegate] window]|
    |customLoading|否|NO|传YES,自行设置加载页，在 verifyCodeInitFinish 方法里面隐藏加载页。NO,显示易盾加载页|
    |customErrorPage|否|NO|传YES,自行设置错误页，在verifyCodeInitFailed 里显示错误页。NO,显示易盾加载页|

### 6 弹出无感知验证码、自定义加载页和错误页

#### 代码说明：

```
[[self.manager openVerifyCodeView:nil loadingView nil customLoading:YES customErrorPage:YES];];
```
 * 入参说明：

    |类型|是否必填|默认值|描述|
    |----|--------|------|----|
    |UIView|否|无|在指定的视图上展示验证码视图，如果传递值为nil,则使用默认值:[[[UIApplication sharedApplication] delegate] window]|
    |loadingView|否|无|如果是智能无感知验证码，并且是自定义loading页面，loadingView必传|
    |customLoading|否|NO|传YES,自行设置加载页，在 verifyCodeInitFinish 方法里面隐藏加载页。NO,显示易盾加载页|
    |customErrorPage|否|NO|传YES,自行设置错误页，在verifyCodeInitFailed 里显示错误页。NO,显示易盾加载页|
    
### 7 关闭验证码

#### 代码说明：

```
[self.manager closeVerifyCodeView];
```
### 8 SDK 日志打印

#### 代码说明：

```
[self.manager enableLog:];
```

 * 入参说明：

    |类型|是否必填|默认值|描述|
    |----|--------|------|----|
    |BOOL|否|NO|是否开启 SDK 日志打印,YES 表示开启;NO 表示不开启。默认为 NO|
    
### 9 验证码 SDK 版本号

#### 代码说明：

```
NSString  *version = [self.manager getSDKVersion];
```

 * 返回值说明：

    |类型|描述|
    |----|----|
    |NSString|当前 SDK 的版本号|
    
### 10 验证码协议方法

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
## 错误码

| code | 含义 |
|------|------|
| 200  | 校验未通过，是因为业务错误，包含超限 |
| 300  | 校验未通过，包含轨迹错误等|
| 432  | 非法业务ID，包含业务到期等|
| 501  | 请求失败，包括网络原因等 |
| 502  | 请求脚本资源失败 |
| 503  | 请求图片资源失败 |
| 505  | 请求音频资源失败 |
| 1000 | 未知错误 |
| 1004  |初始化失败，接口超时 |
|-1 | 未知的错误|
|-999| 请求被取消|
|-1000| 请求的URL错误，无法启动请求|
|-1001| 请求超时|
| -1002|不支持的URL Scheme|
|-1003/-1006|URL的host名称无法解析，即DNS有问题|
|-1004|连接host失败|
|-1005|连接过程中被中断|
|-1007|重定向次数超过限制|
|-1008|无法获取所请求的资源|
|-1009|断网状态|
|-1010|重定向到一个不存在的位置|
|-1011|服务器返回数据有误|
|-1012|身份验证请求被用户取消|
|-1013|访问资源需要身份验证|
|-1014|服务器报告URL数据不为空，却未返回任何数据|
|-1015|响应数据无法解码为已知内容编码|
|-1016|请求数据存在未知内容编码|
|-1017|响应数据无法解析|
|-1018|漫游时请求数据，但是漫游开关已关闭|
|-1019|EDGE、GPRS等网络不支持电话和流量同时进行，当正在通话过程中，请求失败错误码|
|-1020|手机网络不允许连接|
|-1021|请求的body流被耗尽|
|-1100|请求的文件路径上文件不存在|
|-1101|请求的文件只是一个目录，而非文件|
|-1102|缺少权限无法读取文件|
|-1103|资源数据大小超过最大限制|
|-1200|安全连接失败|
|-1201|服务器证书过期|
|-1202|不受信任的根服务器签名证书|
|-1203|服务器证书没有任何根服务器签名|
|-1204|服务器证书还未生效|
|-1205|服务器证书被拒绝|
|-1206|需要客户端证书来验证SSL连接|
|-2000|请求只能加载缓存中的数据，无法加载网络数据|
|-3000|下载操作无法创建文件|
|-3001|下载操作无法打开文件|
|-3002|下载操作无法关闭文件|
|-3003|下载操作无法写文件|
|-3004|下载操作无法删除文件|
|-3005|下载操作无法移动文件|
|-3006|下载操作在下载过程中，对编码文件进行解码时失败|
|-3007|下载操作在下载完成后，对编码文件进行解码时失败|

