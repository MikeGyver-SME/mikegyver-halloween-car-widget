"""Create a stored IPA; avoid compressed Info.plist input to Sideloadly 0.70.

This verifies archive contents, not the later Apple-account signing process.
"""
from pathlib import Path
import hashlib
import os
import struct
import sys
import zipfile


def verify(ipa):
    with zipfile.ZipFile(ipa) as archive, open(ipa, 'rb') as raw:
        assert archive.testzip() is None, 'IPA CRC check failed'
        for item in archive.infolist():
            assert item.compress_type == zipfile.ZIP_STORED, item.filename
            if item.filename.endswith('/Info.plist'):
                raw.seek(item.header_offset)
                header = raw.read(30)
                name_length, extra_length = struct.unpack('<HH', header[26:30])
                raw.seek(item.header_offset + 30 + name_length + extra_length)
                stored = raw.read(item.compress_size)
                decoded = archive.read(item)
                assert hashlib.sha256(stored).digest() == hashlib.sha256(decoded).digest(), item.filename
                print(f'Validated uncompressed signing input: {item.filename}')


def package(root, output):
    root, output = Path(root), Path(output)
    assert (root / 'Payload').is_dir(), 'Missing Payload directory'
    with zipfile.ZipFile(output, 'w', compression=zipfile.ZIP_STORED) as archive:
        for path in sorted((root / 'Payload').rglob('*')):
            relative = path.relative_to(root).as_posix()
            if path.is_symlink():
                info = zipfile.ZipInfo(relative)
                info.create_system = 3
                info.external_attr = path.lstat().st_mode << 16
                archive.writestr(info, os.readlink(path).encode())
            elif path.is_file():
                archive.write(path, relative)
    verify(output)
    print(f'Created {output} ({output.stat().st_size} bytes)')


if __name__ == '__main__':
    package(sys.argv[1], sys.argv[2])
