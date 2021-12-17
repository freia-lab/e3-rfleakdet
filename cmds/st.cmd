# This should be a test or example startup script

epicsEnvSet ("IOCNAME", "ioc10-rfleak")

# Directory name for the autosave files
epicsEnvSet ("IOCDIR", "rfleakdet")

require rfleakdet
require autosave

iocshLoad("$(rfleakdet_DIR)/rfleakdet.iocsh", "ASYN_PORT_NAME=RFLEAKDET")

dbLoadRecords("asynRecord.db","P='$(IOCNAME)',R=:asynRec,PORT='${RFLEAK_PORT}',ADDR='0',IMAX='1024',OMAX='256'")
## Load record instances
dbLoadRecords("rfleakdet-main.db","RFDET_PORT='${RFLEAK_PORT}',PREFIX='Env-RFleakage'")
dbLoadRecords("rfleakdet.db","RFDET_PORT='${RFLEAK_PORT}',PREFIX='Env-RFleakage',NODE=0")
dbLoadRecords("rfleakdet.db","RFDET_PORT='${RFLEAK_PORT}',PREFIX='Env-RFleakage',NODE=1")
dbLoadRecords("rfleakdet.db","RFDET_PORT='${RFLEAK_PORT}',PREFIX='Env-RFleakage',NODE=2")
dbLoadRecords("rfleakdet.db","RFDET_PORT='${RFLEAK_PORT}',PREFIX='Env-RFleakage',NODE=3")

iocshLoad("$(autosave_DIR)/autosave.iocsh", "AS_TOP=/opt/epics/autosave,IOCNAME=$(IOCNAME)")
