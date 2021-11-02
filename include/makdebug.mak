makdebug:
	@echo 
	@echo -------------MAKE VARS------------
	@echo MAKECMDGOALS: $(MAKECMDGOALS)
	@echo MAKEFILE_LIST : $(MAKEFILE_LIST)
	@echo 
	@echo -------------makmng VARS------------
	@echo MAKMNG_FILES    :  $(MAKMNG_FILES)
	@echo MAKMNG_URL      :  $(MAKMNG_URL)
	@echo MAKMNG_CACHE_DIR:  $(MAKMNG_CACHE_DIR)
	@echo MAKMNG_ZIP      :  $(MAKMNG_ZIP)
	@echo MAKMNG_INCLUDE  :  $(MAKMNG_INCLUDE)
	@echo 
	@echo -------------conanbuild VARS------------
	@echo CONANB_TMPFILE:  $(CONANB_TMPFILE)
	@echo CONANB_FILE   :  $(CONANB_FILE)
	@echo CONANB_CMD    :  $(CONANB_CMD)
	@echo CONANB_PROFILE:  $(CONANB_PROFILE)

