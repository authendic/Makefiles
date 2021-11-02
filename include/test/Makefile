## 引入mak管理 ##
MAK_URL:=https://raw.githubusercontent.com/authendic/Makefiles/master/include/makmng.mak
include $(shell wget -L $(MAK_URL) -O makmng.mak; echo "makmng.mak")


## 引入mak 其他文件 ##
include $(MAKMNG_INCLUDE)/makdebug.mak

# ...

## 结束mak ##
include $(MAKMNG_INCLUDE)/makend.mak
