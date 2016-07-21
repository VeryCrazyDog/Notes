# Template

Main class implementation
```python
import sys
import os
import socket
import configparser
import logging
import json
import logging.config

class Main(object):
    """Main class"""

    _logger = logging.getLogger()
    _config = configparser.ConfigParser()

    def __init__(self):
        # Find application root path
        bin_dir = os.path.dirname(os.path.realpath(__file__))
        config_dir = os.path.join(bin_dir, 'config', socket.gethostname().lower())
        # Init logging
        self.init_logging(bin_dir, config_dir)
        # Read configuration
        config_path = os.path.join(config_dir, 'config.ini')
        if os.path.isfile(config_path):
            self._logger.info('Reading configuration at ' + config_path)
            self._config.read(config_path)

    def init_logging(self, bin_dir, config_dir):
        log_config_path = os.path.join(config_dir, 'logging.json')
        if os.path.isfile(log_config_path):
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
                            log_path = os.path.join(bin_dir, log_path)
                            log_config[KEY_HANDLERS][handle_name][KEY_FILENAME] = log_path
                        log_dir_path = os.path.dirname(log_path)
                        if not os.path.isdir(log_dir_path):
                            os.makedirs(log_dir_path)
            # Enable logging
            logging.config.dictConfig(log_config)
        else:
            # Set default logging
            self._logger.addHandler(logging.StreamHandler())
            self._logger.setLevel(logging.DEBUG)
            
    def main(self):
        self._logger.info('Hello World!')
        return 0

if __name__ == '__main__':
    main = Main()
    try:
        main_return_code = main.main()
    except Exception as e:
        main_return_code = 1
    if main_return_code != 0:
        sys.exit(main_return_code)
```

Log configuration
```json
{
	"version":1,
	"disable_existing_loggers":false,
	"formatters":{
		"simple":{
			"format":"%(asctime)s %(levelname)s %(message)s"
		}
	},
	"handlers":{
		"console":{
			"class":"logging.StreamHandler",
			"formatter":"simple",
			"stream":"ext://sys.stdout"
		},
		"timed_rotating_file_handler":{
			"class":"logging.handlers.TimedRotatingFileHandler",
			"formatter":"simple",
			"filename":"log\\log.log",
			"when":"midnight",
			"backupCount":365,
			"encoding":"utf8"
		}
	},
	"root":{
		"level":"DEBUG",
		"handlers":[
			"console",
			"timed_rotating_file_handler"
		]
	}
}
```
