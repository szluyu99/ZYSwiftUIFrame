Gitee 地址：[https://gitee.com/szluyu99/ZYSwiftUIFrame](https://gitee.com/szluyu99/ZYSwiftUIFrame)

Github 地址：[https://github.com/szluyu99/ZYSwiftUIFrame](https://github.com/szluyu99/ZYSwiftUIFrame)

本项目主要维护 Github 地址，同时会同步将其推送到 Gitee 地址（相当于镜像）

## 前言

我并不是专业的 IOS 开发人员，之前也没有接触过 IOS，但是因为某些原因，团队需要开发一个 IOS App，然后我便接触到了 Swift 和 SwiftUI，当然，我并没有学 OC 和 UIKit。该项目中几乎没有用到 UIKit 相关的东西（有也是谷歌搜索到了代码直接复制一下），基本上完全使用 SwiftUI 进行开发。

总觉得以后应该不会再和 IOS 有太多交集，但是好歹也是钻研了这么一段时间的技术，总希望能留下点什么东西，因此就诞生了这个项目。我试图将我开发 IOS 时学习和积累到的知识点和技术尽可能的集成到这个项目中，该框架也许会不停的迭代（如果我还有机会接触 IOS 的话）。

再次申明，**我并不是专业的 IOS 开发人员**，很多代码风格和思维，也许都是其他项目的开发经验，欢迎探讨。

希望我的项目能为 SwiftUI 带来一丝丝微弱的光芒。

## 主要特色

从我这么一个对 IOS 完全零基础的人的角度来看，我之前查询过很多项目，但是很多项目的功能性都是比较偏向某面，大多都是着力于视图层或其他功能性，很少能遇到比较完整的项目（可能我的看法并不专业）。而且 SwiftUI 开发中必然会遇到一些拦路虎如：下拉刷新、上拉加载、显示网络图片等，主要原因是因为 SwiftUI 目前还不是特别成熟，但是它作为未来的趋势是必然的。

该 SwiftUI 项目包含完整的：**网络请求、下拉刷新、上拉加载更多、数据增删改查、图片上传、图片预览**等功能（后续还会继续更新），代码中抽取成了框架体系：例如通用 ViewModel 等，很适合进行快速开发。

项目特色：

* **拥有服务端项目**，为了模拟实际的项目场景，我使用 Go 开发的
* 包含**网络请求部分**，结合上面服务端，实现了对数据库数据的增删改查
* 即使不运行服务端，项目也有**单机 Demo**，供你快速了解其主要功能
* 封装了**丝滑的上拉刷新、下拉加载更多**（基于 BBSwiftUIKit），也可以模仿我的代码自行封装
* **代码优雅**、风格整洁，注释比较详细
* 待更新...

## 项目技术

IOS 技术栈：基于 Swift 语言

* SwiftUI

服务端技术栈：基于 Go 语言

* Web 框架：Gin
* ORM 框架：GORM

## 项目预览

![](https://img-blog.csdnimg.cn/img_convert/e252d7cc96b135c753e246991cfa8691.png)

### 1. 不需要开启服务端

不需要开启服务端，功能是下面 “需要开启服务端” 功能的简化版，仅用于本地演示，并且不涉及到数据请求。

#### 1.1 用户列表

下拉刷新、上拉加载更多：

![](https://img-blog.csdnimg.cn/img_convert/03e3ffbbd9fdce04a05309bd8830dae3.gif)

新增、删除、修改：

![](https://img-blog.csdnimg.cn/img_convert/5d05aac8252709be10257c9173dc8e97.gif)


帮助、搜索：

![](https://img-blog.csdnimg.cn/img_convert/63b7e4d967321cb254bda5ac418408df.gif)

### 2. 需要开启服务端

开启服务端的数据，模拟真实的请求后台，实现对数据库的操作。

#### 2.1 消息列表

上拉、下拉、删除：

![](https://img-blog.csdnimg.cn/img_convert/e9bebd97d19257d014da9ccae62fb2c7.gif)



#### 2.2 会议列表

显示帮助、删除、下拉刷新、搜索：

![](https://img-blog.csdnimg.cn/img_convert/96080cbef5b6483f98917b8108b6a99d.gif)

更新、新增：

![](https://img-blog.csdnimg.cn/img_convert/3e50cf14f2941307a5c3130be70b403d.gif)

图片上传、预览、删除、保存：

![](https://img-blog.csdnimg.cn/img_convert/e0bdc66530fcabea91e058101b0f246a.gif)





## 运行教程

### 运行 IOS 项目

这个应该不用多说了，项目拉下来，用 Xcode 打开 `ZYSwiftUIFrame.xcodeproj` 文件。

运行前需要修改签名等操作。

---

项目跑起来后，**不需要服务端的界面是可以直接查看的**，需要服务端的界面，还需要运行起服务端。

当服务端跑起来后，将 `Api/NetworkManager.swift` 中的 `NetworkAPIBaseURL` 修改为你当前的局域网 IP。

（端口默认是 8080，不需要修改）

> 保证你的真机和运行起服务端的电脑在同一个局域网下，或者直接使用模拟器运行项目。

查看电脑当前 IP 的方法：在网络偏好设置查看。

![](https://img-blog.csdnimg.cn/img_convert/057ea9fa3f18e93d54d8474936713096.png)

### 运行服务端项目

> 需要有 Go 语言的环境。

项目我已经打包好了，就是 go_api_server 目录下的 `main` 文件，终端中 `./main` 即可运行。

运行前记得修改 `config` 目录中的配置文件，修改成自己的数据库名、用户名、密码。

#### 数据库相关

我本地数据库用的 MySQL 8。

**Golang 的数据库框架有自动迁移功能**，在连接上数据库的基础上，直接运行起项目会自动建表。

我也在代码中初始化生成了一些测试数据，因此只要数据库连接正常，项目运行起来，就有数据了。

> 当然，我也提供了 SQL 语句（结构 + 数据），在项目的 `sql` 文件中。

#### 文件上传目录

文件上传到本地，目前写死是 `uploads/file` 目录。

#### 后台接口文档

该接口文档由 ApiPost 生成：

[https://console-docs.apipost.cn/cover.html?url=36557b241534caed&salt=6015c9b386e133e0](https://console-docs.apipost.cn/cover.html?url=36557b241534caed&salt=6015c9b386e133e0)
