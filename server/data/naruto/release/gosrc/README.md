## Golang开发相关

1. 使用 go module方式组织相关依赖和环境，go version >= 1.11

2. 目录结构已经给定，gosrc - tjgame - login 这样

3. 代码中import需要有tjgame前缀，如tjgame/server_framework/tj/csv

4. 通过 go mod指令或者修改go.mod文件更新和增加依赖

5. 私有的库已经通过git submodule包含到当前git中，开箱即用

6. 直接进入相关app目录进行go build，如login目录下

7. 也可以通过build/build_all.py来执行，py脚本完成工作更为复杂些，比如csv和orm生成

8. 其他使用请熟悉go mod命令
