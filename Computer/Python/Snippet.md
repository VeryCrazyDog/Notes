# Text

Text file encoding detection

```python
def detect_encoding(path, default_encoding = 'utf-8'):
    result = default_encoding
    with io.open(path, 'rb') as f:
        raw = f.read(4)
    for enc, boms in \
        ('utf-8-sig', (codecs.BOM_UTF8,)),\
        ('utf-16', (codecs.BOM_UTF16_LE, codecs.BOM_UTF16_BE)),\
        ('utf-32', (codecs.BOM_UTF32_LE, codecs.BOM_UTF32_BE)):
        if any(raw.startswith(bom) for bom in boms): result = enc
    return result
```
