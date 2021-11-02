## mak文件管理及下载
# vim: fdm=marker :


####################################
# 
####################################

makmngtest:
	echo $(MAKMNG_INCLUDE)

MAKMNG_FILES:=conanbuild.mak \
	makdebug.mak 
MAKMNG_URL:=https://github.com/authendic/Makefiles/archive/refs/heads/master.zip
MAKMNG_CACHE_DIR:=$(HOME)/.cache/makmng
MAKMNG_ZIP:=$(MAKMNG_CACHE_DIR)/makmng.zip
MAKMNG_INCLUDE:=$(MAKMNG_CACHE_DIR)/Makefiles-master/include
.INCLUDE_DIRS: $(MAKMNG_INCLUDE)

$(MAKMNG_ZIP):
	mkdir -p $(MAKMNG_CACHE_DIR)
	wget -L $(MAKMNG_URL) -O $@

$(MAKMNG_INCLUDE): $(MAKMNG_ZIP)
	cd $(MAKMNG_CACHE_DIR); unzip $(MAKMNG_ZIP)

$(MAKMNG_FILES): $(MAKMNG_INCLUDE)

CLEAN_TARGETS: $(MAKMNG_CACHE_DIR)/Makefiles-*

ifeq ("x$(CLEAN_TARGETS_DEF)x", "xx")
CLEAN_TARGETS_DEF:=1
CLEAN_TARGETS:
	rm -Rf $^
endif

cleancache:
	rm -Rf $(MAKMNG_CACHE_DIR)

clean:CLEAN_TARGETS
