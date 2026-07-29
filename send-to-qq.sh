#!/bin/bash

# 无论从哪里运行，都先进入当前脚本所在目录
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

REPORT="./dailyreport/${1:?Usage: $0 YYYY-MM-DD}.md"

python3 - "$REPORT" <<'PY' |
import re
import sys

path = sys.argv[1]
limit = 3499

with open(path, "r", encoding="utf-8") as f:
    text = f.read().strip()

# 按一个或多个空行拆成段落
paragraphs = re.split(r"\n[ \t]*\n+", text)

chunks = []
current = ""

for paragraph in paragraphs:
    # 单个段落过长时，直接硬切
    while len(paragraph) > limit:
        if current:
            chunks.append(current)
            current = ""

        chunks.append(paragraph[:limit])
        paragraph = paragraph[limit:]

    candidate = paragraph if not current else current + "\n\n" + paragraph

    if len(candidate) < 3500:
        current = candidate
    else:
        if current:
            chunks.append(current)
        current = paragraph

if current:
    chunks.append(current)

# 使用 NUL 分隔，避免换行影响 shell 读取
for chunk in chunks:
    sys.stdout.write(chunk)
    sys.stdout.write("\0")
PY
  while IFS= read -r -d '' chunk; do
    hermes send --to qqbot "$chunk"
  done
