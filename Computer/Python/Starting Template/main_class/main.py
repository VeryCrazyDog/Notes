import sys
import os
import socket
import configparser
import logging
import json
import logging.config

class Main(object):
    """Main class"""

    def __init__(self):
        # Find application paths
        self._bin_dir = os.path.dirname(os.path.realpath(__file__))
        self._config_dir = os.path.join(self._bin_dir, 'config')
        self._host_config_dir = os.path.join(self._config_dir, socket.gethostname().lower())
        self._local_config_dir = os.path.join(self._config_dir, 'local')
        # Init logging
        self._logger = logging.getLogger()
        self._init_logging()
        # Init and read configuration
        self._config = configparser.ConfigParser()
        self._read_config()

    def _get_effective_path(self, filename):
        result = os.path.join(self._local_config_dir, filename)
        if not os.path.isfile(result):
            result = os.path.join(self._host_config_dir, filename)
        if not os.path.isfile(result):
            result = os.path.join(self._config_dir, filename)
        if not os.path.isfile(result):
            result = None
        return result
    
    def _init_logging(self):
        log_config_path = self._get_effective_path('logging.json')
        if log_config_path is not None:
            with open(log_config_path, 'r') as f:
                log_config = json.load(f)
            # Create log directory
            KEY_HANDLERS = 'handlers'
            KEY_FILENAME = 'filename'
            log_path = ''
            if KEY_HANDLERS in log_config:
                for handle_name, handle_config in log_config[KEY_HANDLERS].items():
                    if KEY_FILENAME in handle_config:
                        log_path = handle_config[KEY_FILENAME]
                        if not os.path.isabs(log_path):
                            log_path = os.path.join(self._bin_dir, log_path)
                            log_config[KEY_HANDLERS][handle_name][KEY_FILENAME] = log_path
                        log_dir_path = os.path.dirname(log_path)
                        if not os.path.isdir(log_dir_path):
                            os.makedirs(log_dir_path)
            # Enable logging
            logging.config.dictConfig(log_config)
            # Print out the log configuration location
            self._logger.info('Using logging configuration at ' + log_config_path)
        else:
            # Use default logging
            self._logger.addHandler(logging.StreamHandler())
            self._logger.setLevel(logging.DEBUG)
            
    def _read_config(self):
        config_path = self._get_effective_path('config.ini')
        if config_path is not None:
            self._logger.info('Reading configuration at ' + config_path)
            self._config.read(config_path)

    def main(self):
        self._logger.info('Hello World!')
        self._logger.info(self._config.get('default', 'message'))
        return 0

if __name__ == '__main__':
    main = Main()
    try:
        main_return_code = main.main()
    except Exception as e:
        main_return_code = 1
        print(e)
    if main_return_code != 0:
        sys.exit(main_return_code)
