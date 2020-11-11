#!/bin/env python

import sys
import json
import pywbem
import argparse
import logging
import logging.handlers
import pystorage

log_level = logging.DEBUG


def ecom_connect(ecom_ip, ecom_user, ecom_pass, default_namespace="root/emc",no_verification=True):
    """ returns a connection to the ecom server """
    #ecom_url = "https://%s:5989" % ecom_ip
    ecom_url = "https://172.16.1.171:5989"

    logger = logging.getLogger('discovery')
    logger.info("Building WBEM Connection to %s" % ecom_url)

    return pywbem.WBEMConnection(ecom_url, (ecom_user, ecom_pass),
                                 #default_namespace="interop",no_verification=True)
                                 default_namespace="root/emc",no_verification=True)

def discover_array_volumes(ecom_conn, array_serial):
    array = get_array_instancename(array_serial, ecom_conn)

    # Locate all volumes associated with the array
    logger = logging.getLogger('discovery')
    logger.debug("Started volume info collection from ECOM")
    volumes = ecom_conn.Associators(array, ResultClass="CIM_StorageVolume")
    logger.debug("Completed volume info collection ECOM")

    logger.debug("Generating discovery objects")
    discovered_volumes = []
    for volume in volumes:

        diskitem = dict()
        diskitem["{#VOLDEVICEID}"] = volume["DeviceID"]
        diskitem["{#VOLALIAS}"] = volume["ElementName"]
        diskitem["{#VOLPERFDEVICEID}"] = volume["EMCBSPInstanceID"]
        diskitem["{#ARRAYSERIAL}"] = array_serial

        discovered_volumes.append(diskitem)
        logger.debug(str(diskitem))

    return discovered_volumes

def zabbix_safe_output(data):
    """ Generate JSON output for zabbix from a passed in list of dicts """
    logger = logging.getLogger('discovery')
    logger.info("Generating output")
    output = json.dumps({"data": data}, indent=4, separators=(',', ': '))

    logger.debug(json.dumps({"data": data}))

    return output

def log_exception_handler(type, value, tb):
    logger = logging.getLogger('discovery')
    logger.exception("Uncaught exception: {0}".format(str(value)))

def setup_logging(log_file):
    """ Sets up our file logging with rotation """
    my_logger = logging.getLogger('discovery')
    my_logger.setLevel(log_level)

    handler = logging.handlers.RotatingFileHandler(
                          log_file, maxBytes=5120000, backupCount=5)

    formatter = logging.Formatter(
        '%(asctime)s %(levelname)s %(process)d %(message)s')
    handler.setFormatter(formatter)

    my_logger.addHandler(handler)

    sys.excepthook = log_exception_handler
 
    return


def main():

    log_file = '/tmp/emc_vnx_discovery.log'
    setup_logging(log_file)

    logger = logging.getLogger('discovery')
    logger.debug("Discovery script started")

    parser = argparse.ArgumentParser()

    parser.add_argument('--serial', '-s', action="store",
                        help="Array Serial Number", required=True)
    parser.add_argument('--ecom_ip', '-i', action="store",
                        help="IP Address of ECOM server", required=True)

    parser.add_argument('--ecom_user', action="store",
                        help="ECOM Username", default="admin")
    parser.add_argument('--ecom_pass', action="store",
                        help="ECOM Password", default="#1Password")

    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('--disks', '-d', action="store_true",
                       help="Discover Physical Disks")
    group.add_argument('--volumes', '-v', action="store_true",
                       help="Discover Volumes/LUNs")
    group.add_argument('--procs', '-p', action="store_true",
                       help="Discover Storage Processors")
    group.add_argument('--pools', '-o', action="store_true",
                       help="Discover Physical Disks")
    group.add_argument('--array', '-a', action="store_true",
                       help="Discover Array devices and enclosures")

    args = parser.parse_args()

    logger.debug("Arguments parsed: %s" % str(args))

    ecom_conn = ecom_connect(args.ecom_ip, args.ecom_user, args.ecom_pass)

    result = None
    if args.disks:
        logger.info("Disk discovery started")
        result = discover_array_disks(ecom_conn, args.serial)
    elif args.volumes:
        logger.info("Volume discovery started")
        result = discover_array_volumes(ecom_conn, args.serial)
    elif args.procs:
        logger.info("Storage Processor discovery started")
        result = discover_array_SPs(ecom_conn, args.serial)
    elif args.pools:
        logger.info("Pool discovery started")
        result = discover_array_pools(ecom_conn, args.serial)
    elif args.array:
        logger.info("Array hardware discovery started")
        result = discover_array_devices(ecom_conn, args.serial)

    print zabbix_safe_output(result)

    logger.info("Discovery Complete")

if __name__ == "__main__":
    main()
