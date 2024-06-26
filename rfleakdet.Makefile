# Copyright (C) 2021  FREIA Laboratory

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.


# The following lines are required
where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(E3_REQUIRE_CONFIG)/DECOUPLE_FLAGS

# Most modules only need to be built for x86_64
ARCH_FILTER += linux-x86_64

# If your module has dependencies, you will generate want to include them like
#
#     REQUIRED += asyn
#     ifneq ($(strip $(ASYN_DEP_VERSION)),)
#       asyn_VERSION=$(ASYN_DEP_VERSION)
#     endif
# 
# with $(ASYN_DEP_VERSION) defined in `configure/CONFIG_MODULE`

REQUIRED += stream
ifneq ($(strip $(STREAM_DEP_VERSION)),)
stream_VERSION=$(STREAM_DEP_VERSION)
endif

# Since this file (rfleakdet.Makefile) is copied into
# the module directory at build-time, these paths have to be relative
# to that path
APP := .
APPDB := $(APP)/Db
APPSRC := $(APP)/src

# If you have files to include, you will generally want to include these, e.g.
#
#     SOURCES += $(APPSRC)/rfleakdetMain.cpp
#     SOURCES += $(APPSRC)/library.c
#     HEADERS += $(APPSRC)/library.h
#     USR_INCLUDES += -I$(where_am_I)$(APPSRC)

TEMPLATES += $(wildcard $(APPDB)/*.db)
TEMPLATES += $(wildcard $(APPDB)/*.proto)
TEMPLATES += $(wildcard $(APPDB)/*.template)

SCRIPTS += $(wildcard ../iocsh/*.iocsh)

SUBS = $(wildcard $(APPDB)/*.substitutions)
TMPS = $(wildcard $(APPDB)/*.template)

USR_DBFLAGS += -I . -I ..
USR_DBFLAGS += -I $(EPICS_BASE)/db
USR_DBFLAGS += -I $(APPDB)

.PHONY: db
db: $(SUBS) $(TMPS)

.PHONY: $(SUBS)
$(SUBS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@ > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@

.PHONY: $(TMPS)
$(TMPS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db $@ > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db $@

.PHONY: vlibs
vlibs:
