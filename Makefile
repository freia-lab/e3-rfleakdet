EXCLUDE_ARCHS += eldk

include $(EPICS_ENV_PATH)/module.Makefile

#USR_DEPENDENCIES += autosave

MISCS = $(AUTOMISCS)
MISCS += misc/rfleakdet-freia.req

OPIS = opi
#MISCS += misc/ioc-superv-freia.req
