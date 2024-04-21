# AutoSettingsDMZ
这个项目是为了解决中国移动光猫重启时不能自动设置DMZ和虚拟主机，或相关设置失效的BUG，目前主要测试型号为HX3-4sProLite，重启5分钟后可以自动设置

## 使用要件  
必须获取CMCCAdmin账户权限，目前北京移动可以直接打10086进行申请，一定要坚定的告诉他你有业务需要进入后台设置  
如果没有公网IP，那这个项目对你没有帮助.目前北京移动是每个月20元可以使用公网IP。  
至少有一台可以运行LINUX的主机，即使是树莓派也可以，我使用的是3B+.  

##  快速开始
下载AutoSettingsMDZ.sh放到指定的目录。  
增加执行权限 chmod +x AutoSettingsMDZ.sh  
安装 expect    apt-get install expect  
修改AutoSettingsMDZ.sh 相关参数并测试执行  
自动执行任务 /etc/crontab   添加一行 */5 *   * * * root /root/AutoSettingsMDZ.sh  

## 相关原理
查阅相关资料其实目前遇到这个问题主要是iptables 相关设置没有被加载，移动光猫使用了一个数据库，不知道是没有解析成iptables能够识别的格式还是怎么样，反正相关配置没有被加载，但是界面上是读取数据库显示已经配置成功，如果手动DMZ设置重新提交一次，虚拟主机设置修改一下并保存，也可以成功设置。  
目前解决方案就是使用一台低配的LINUX，连接telnet ，并设置iptables参数。里边虚拟主机只添加了两个端口的TCP/UDP大家可以进行修改。  
目前就我使用的体验是，北京移动还比较稳定，在光猫不重启的情况下，IP不会变动，当IP变动时必然是光猫重启了，则执行此脚本。  
第一次写linux shell 还有不完善的地方请大家指正。


