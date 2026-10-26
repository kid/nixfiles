import base64
import re
import urllib.request
from pathlib import Path

package = Path("pkgs/by-name/dagger/package.nix")
text = package.read_text()
version = re.search(r'version = "([^"]+)";', text).group(1)
url = f"https://dl.dagger.io/dagger/releases/{version}/checksums.txt"
with urllib.request.urlopen(url) as response:
    checksums = {
        name: digest
        for digest, name in (line.split() for line in response.read().decode().splitlines())
    }


def replace_hash(match):
    filename = f"dagger_v{version}_{match[2]}.tar.gz"
    digest = bytes.fromhex(checksums[filename])
    value = "sha256-" + base64.b64encode(digest).decode()
    return match[1] + value + match[4]


updated, count = re.subn(
    r'(platform = "([^"]+)";\s+hash = ")([^"]+)(";)', replace_hash, text
)
if count == 0:
    raise RuntimeError("No platform hashes found in Dagger package")
package.write_text(updated)
print(f"Updated Dagger {version} hashes for {count} platforms")
