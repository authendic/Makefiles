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

## define makmng_check_file_exists
## $(if $(wildcard $(1)),yes,)
## endef
## 
## ifneq ($(call makmng_check_file_exists,$(MAKMNG_INCLUDE)),yes)
## $(info not exists)
## endif


$(MAKMNG_ZIP):
	mkdir -p $(MAKMNG_CACHE_DIR)
	wget -L $(MAKMNG_URL) -O $@

$(MAKMNG_INCLUDE): $(MAKMNG_ZIP)
	cd $(MAKMNG_CACHE_DIR); unzip $(MAKMNG_ZIP)
	touch $@

$(MAKMNG_FILES:%=$(MAKMNG_INCLUDE)/%): $(MAKMNG_INCLUDE)
	@echo expect $@

CLEAN_TARGETS+=$(MAKMNG_CACHE_DIR)/Makefiles-*

ifeq ("x$(CLEAN_TARGETS_DEF)x", "xx")
CLEAN_TARGETS_DEF:=1
CLEAN_TARGETS_JOB:
	rm -Rf $(CLEAN_TARGETS)
endif


clean:CLEAN_TARGETS_JOB

makupdate:
	rm -Rf /tmp/makmng.mak
	wget -L $(MAKMNG_UPDATE_URL) -O /tmp/makmng.mak
	sha256sum $(MAKMNG_SELF) /tmp/makmng.mak > /tmp/makmng.mak.sha256sum
	if [ `awk '{sum[$$1]++}END{print length(sum)}' /tmp/makmng.mak.sha256sum` -eq 2 ];then \
		cp /tmp/makmng.mak $(MAKMNG_SELF); \
		rm -Rf $(MAKMNG_CACHE_DIR); \
	fi
