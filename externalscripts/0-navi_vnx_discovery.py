#!/usr/bin/env python
#teste

import sys
import json
import argparse
import logging
import logging.handlers
import subprocess

log_level = logging.INFO

def discover_disk():
	with open('/tmp/disk.json','r') as f:
		disks = json.load(f)

	discovered_disk = []
	for disk in disks:
		diskitem = dict()
		diskitem["{#DISKSTATE}"] = disk["DISKSTATE"]
		diskitem["{#DISKID}"] = disk["DISKID"]

		discovered_disk.append(diskitem)

	return discovered_disk


def discover_sp():
	with open('/usr/lib/zabbix/externalscripts/navi/CS1-PROD.json', 'r') as f:
		sps = json.load(f)

	discovered_sps = []
	for spx in sps:
		spitem = dict()
		spitem["{#SPUNIT}"] = spx["SPUNIT"]
		spitem["{#SPIP}"] = spx["SPIP"]

		discovered_sps.append(spitem)

	return discovered_sps
	

def discover_lun():
	with open('/tmp/lun.json','r') as f:
		luns = json.load(f)

	discovered_luns = []
	for lun in luns:
		lunitem = dict()
	        lunitem["{#LUNNAME}"] = lun["Name"]
	        lunitem["{#LUNPOOLNAME}"] = lun["Pool Name"]

		discovered_luns.append(lunitem)

	return discovered_luns

def zabbix_safe_output(data):
    """ Generate JSON output for zabbix from a passed in list of dicts """
    output = json.dumps({"data": data}, indent=4, separators=(',', ': '))

    return output


def main():
	#log_file = '/tmp/VNX_Discovery.log'
	#setup_logging(log_file)

	#logger = logging.getLogger('discovery')
	#logger.debug("Discovery script started")

	parser = argparse.ArgumentParser()
	#parser.add_argument('--lun', '-l', action="store_true", help="Identificacao das Luns", required=True)
	#parser.add_argument('--SPs', '-sp', action="store_true", help="Identificacao das SPs", required=True)
	parser.add_argument('--lun', '-l', action="store_true", help="Identificacao das Luns")
	parser.add_argument('--SPs', '-sp', action="store_true", help="Identificacao das SPs")
	parser.add_argument('--disk', '-d', action="store_true", help="Identificacao dos Discos")
	

	args = parser.parse_args()
	#logger.debug("Arguments parser: $s" % str(args))
	#print args

	result = None
	if args.lun:
		#logger.info("LUN Discovery started")
		result = discover_lun()
	elif args.SPs:
		result = discover_sp()
	elif args.disk:
		result = discover_disk()
		
	print zabbix_safe_output(result)

	#logger.info("Discovery Complete")

if __name__ == "__main__":
    main()
