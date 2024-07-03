#!/usr/bin/env bash

# curl https://keys.tckr.sh/install.sh | bash
# Make sure you use httpS!

set -euo pipefail

echo 'UNTESTED' && exit 1

# Setup a temporary directory

tmp_dir="$( mktemp -d -t 'keys.tckr.sh/install.sh' )"

# Run cleanup when execution stops

clean_up() {
  test -d "$tmp_dir" && rm -fr "$tmp_dir"
}
trap "clean_up $tmp_dir" EXIT

# The files we will modify

expired="${tmp_dir}/tuckershea.auth.keys.expired"
keys="${tmp_dir}/tuckershea.auth.keys"
temporary="${tmp_dir}/authorized_keys"

existing="${HOME}/.ssh/authorized_keys"

# Make sure none of our files are less secure than authorized_keys

tmp_files=("${expired}" "${keys}" "${temporary}")
for f in "${files[@]}"
do
    touch "${f}"
    chmod --reference="${existing}" "${f}"
    chown --reference="${existing}" "${f}"
done

# Get our reference files

curl 'https://keys.tckr.sh/auth.keys.expired' -o "${expired}"
curl 'https://keys.tckr.sh/auth.keys' -o "${keys}"

# Remove expired keys, while telling the user what we are doing

echo 'Removing expired SSH keys:'
awk 'NR==FNR{a[$0];next} ($0 in a)' "${expired}" "${existing}"

awk 'NR==FNR{a[$0];next} !($0 in a)' "${expired}" "${existing}" > "${temporary}"

# Add new keys

echo 'Adding new SSH keys:'
awk 'NR==FNR{a[$0];next} !($0 in a)' "${keys}" "${existing}"

awk 'NR==FNR{a[$0];next} !($0 in a)' "${keys}" "${existing}" >> "${temporary}"

# Write the new file

mv "${temporary}" "${existing}"

# Temp directory automatically cleaned up

