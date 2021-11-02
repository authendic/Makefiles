## mak文件管理及下载
# vim: fdm=marker :


####################################
# 
####################################

MAKMNG_FILES:=conanbuild.mak \
	makdebug.mak 
MAKMNG_URL:=https://github.com/authendic/Makefiles/archive/refs/heads/master.zip
MAKMNG_UPDATE_URL:=https://raw.githubusercontent.com/authendic/Makefiles/master/include/makmng.mak
MAKMNG_CACHE_DIR:=$(HOME)/.cache/makmng
MAKMNG_ZIP:=$(MAKMNG_CACHE_DIR)/makmng.zip
MAKMNG_INCLUDE:=$(MAKMNG_CACHE_DIR)/Makefiles-master/include
MAKMNG_SELF:=$(lastword $(MAKEFILE_LIST))

cleancache:
	rm -Rf $(MAKMNG_CACHE_DIR)

## 除了clean job，需要进行依赖解析
ifneq ($(MAKECMDGOALS),clean)
$(MAKMNG_ZIP):
	mkdir -p $(MAKMNG_CACHE_DIR)
	wget -L $(MAKMNG_URL) -O $@

$(MAKMNG_INCLUDE): $(MAKMNG_ZIP)
	echo $@
	cd $(MAKMNG_CACHE_DIR); unzip $(MAKMNG_ZIP)

$(MAKMNG_FILES:%=$(MAKMNG_INCLUDE)/%): $(MAKMNG_INCLUDE)
	echo $@
endif

CLEAN_TARGETS+=$(MAKMNG_CACHE_DIR)/Makefiles-*

ifeq ("x$(CLEAN_TARGETS_DEF)x", "xx")
CLEAN_TARGETS_DEF:=1
CLEAN_TARGETS_JOB:
	rm -Rf $(CLEAN_TARGETS)
endif


clean:CLEAN_TARGETS_JOB

makupdate:
	wget -L $(MAKMNG_UPDATE_URL) -O /tmp/makmng.mak
	sha256sum $(MAKMNG_SELF) /tmp/makmng.mak > /tmp/makmng.mak.sha256sum
	if [ `awk '{sum[$$1]++}END{print length(sum)}' /tmp/makmng.mak.sha256sum` -eq 2 ];then \
		echo cp /tmp/makmng.mak $(MAKMNG_SELF); \
	fi
