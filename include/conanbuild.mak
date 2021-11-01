## 生成并导入conan make模块
# vim: fdm=marker :

####################################
###### conanfile.txt example ######
# [requires]
# protobuf/3.6.1@bincrafters/stable
# 
# [generators]
# make
####################################


# 本文件定义的变量都带CONANB_前缀
conanbuild_do_nothing:
	@echo ""

CONANB_TMPFILE=conanbuildinfo.mak conanbuildinfo.txt conaninfo.txt conan.lock graph_info.json
CONANB_FILE=$(shell ls conanfile.txt conanfile.py 2>/dev/null|head -1)
CONANB_CMD:=$(shell which conan)

# 如果conanfile.txt或conanfile.py存在
# 则生成并导入conanbuildinfo.mak 
ifneq ("x$(CONANB_FILE)x", "xx")
# {{{1

# 如果不存在则生成
-include conanbuildinfo.mak
# $(call CONAN_BASIC_SETUP)

ifeq ($(MAKECMDGOALS),clean)
# {{{2
# conanbuildinfo.mak生成, 当目录为clean时不必生成
conanbuildinfo.mak:$(CONANB_FILE)
	@echo "Clean. Do not need conan install"
# 2}}}
else
# {{{2

ifeq ("x$(CONANB_CMD)x", "xx")
$(info conan not exists, download it...)
CONANB_CMD_DOWN_STDOUT:=$(shell pip3 install conan 1>&2)
CONANB_CMD=$(shell which conan)
ifeq ("x$(CONANB_CMD)x", "xx")
$(error conan install fail )
endif
endif

## 设置conan flag到编译FLAGS
CXXFLAGS+=$(CONAN_CXXFLAGS) $(patsubst %,-I%,$(CONAN_INCLUDE_DIRS))
CFLAGS+=$(CONAN_CFLAGS) $(patsubst %,-I%,$(CONAN_INCLUDE_DIRS))
LDLIBS+=$(patsubst %,-l%,$(CONAN_LIBS) $(CONAN_SYSTEM_LIBS))
LDFLAGS+=$(patsubst %,-L%,$(CONAN_LIB_DIRS)) $(LDLIBS)


conanbuildinfo.mak: $(CONANB_FILE)
	$(CONANB_CMD) install .
# 2}}}
endif

endif
# 1}}}

_conan_clean:
	rm -rf $(CONANB_TMPFILE)

clean:_conan_clean
