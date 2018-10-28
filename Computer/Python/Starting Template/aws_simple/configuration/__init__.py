# Import build-in packages
import os
import socket
import configparser

# Import our packages
from definitions import ROOT_DIR

# Environment parameter for configuration table
ENV_TRACE = 'TRACE'

# Module variables
__configuration = None


def get_configuration(logger):
    global __configuration
    if __configuration is None:
        path = os.path.join(ROOT_DIR, 'config.ini')
        __configuration = configparser.ConfigParser()
        __configuration.read(path)
        if logger is not None:
            logger.debug('Configuration loaded from %s', path)
    return __configuration


def unload_configuration():
    global __configuration
    __configuration = None
