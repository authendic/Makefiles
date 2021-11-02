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


####################################
# 如果遇到需要指定conan profile的场景
#    conan profile new --detect myprofile
#    conan profile update settings.compiler.libcxx=libstdc++11 myprofile
#    conan profile show myprofile
#    make clean
#    make CONAN_PROFILE=myprofile
####################################


# 本文件定义的变量都带CONANB_前缀
conanbuild_do_nothing:
	@echo ""

CONANB_TMPFILE=conanbuildinfo.mak conanbuildinfo.txt conaninfo.txt conan.lock graph_info.json
CONANB_FILE=$(shell ls conanfile.txt conanfile.py 2>/dev/null|head -1)
CONANB_CMD:=$(shell which conan)
CONANB_PROFILE:=$(if $(CONAN_PROFILE),--profile $(CONAN_PROFILE),)

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
	$(CONANB_CMD) install . $(CONANB_PROFILE)
# 2}}}
endif

endif
# 1}}}

CLEAN_TARGETS: $(CONANB_TMPFILE)

ifeq ("x$(CLEAN_TARGETS_DEF)x", "xx")
CLEAN_TARGETS_DEF:=1
CLEAN_TARGETS:
	rm -Rf $^
endif


clean:CLEAN_TARGETS
