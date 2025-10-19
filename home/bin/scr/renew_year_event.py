import sys
from zhdate import ZhDate
from datetime import datetime
import re
import os
import hashlib

def quit_with(s: str):
    print("Error:", s)
    exit(1)

def get_file_hash(filename: str):
    hash_sha256 = hashlib.sha256()
    try:
        with open(filename, "rb") as f:
            for chunk in iter(lambda: f.read(4096), b""):
                hash_sha256.update(chunk)
        return hash_sha256.hexdigest()
    except FileNotFoundError:
        return None

if len(sys.argv) < 3:
    quit_with("not enough arguments. Usage: script.py <input_file> <output_file>")

input_file = sys.argv[1]
output_file = sys.argv[2]
if not os.path.exists(input_file):
    quit_with("invalid file path")

now = datetime.now()

DATE_PATTERN = r'^([*-])\s*(.*?)\s*(\d+),(\d+)$'


birth_list: list[tuple[str, datetime]] = []

with open(input_file, encoding='utf-8') as birth_file:
    for line in birth_file:
        match = re.match(DATE_PATTERN, line)
        if not match: continue
        groups = match.groups()
        month = int(groups[2])
        day = int(groups[3])
        if groups[0] == '-':
            time = ZhDate(now.year, month, day).to_datetime()
            if time < now:
                time = ZhDate(now.year + 1, month, day).to_datetime()
        else:
            time = datetime(now.year, month, day)
            if time < now:
                time = datetime(now.year + 1, month, day)
        birth_list.append((groups[1], time))

birth_list.sort(key=lambda x: x[1])
new_content = '\n'.join([ "- [ ] 📅 {}-{:02}-{:02} {}".format(birth.year, birth.month, birth.day, event) for (event, birth) in birth_list ])

new_content_hash = hashlib.sha256(new_content.encode('utf-8')).hexdigest()
old_file_hash = get_file_hash(output_file)

if old_file_hash != new_content_hash:
    with open(output_file, mode = 'w', encoding='utf-8') as of:
        of.write(new_content)
    print("Complete: update success")
else:
    print("Complete: dont need update")
