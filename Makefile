EXCLUDE_ARCHS += eldk

include $(EPICS_ENV_PATH)/module.Makefile

# USR_DEPENDENCIES = 
MISCS = $(AUTOMISCS)

OPIS = opi
#MISCS += misc/ioc-superv-freia.req
