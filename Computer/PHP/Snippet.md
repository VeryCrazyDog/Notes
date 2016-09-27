# Text

Convert file size to human readable format

```php
function human_filesize($size, $precision = 2) {
	$units = ['byte', 'KB', 'MB', 'GB', 'TB', 'PB', 'EB', 'ZB', 'YB'];
	for ($i = 0; ($size / 1024) > 0.9; $i++) {
		$size /= 1024;
	}
	return round($size, $precision) . ' ' . $units[$i] . (($i === 0 && $size !== 1) ? 's' : '');
}
```
