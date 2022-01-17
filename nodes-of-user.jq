#!/usr/local/bin/jq -nrf

def inventory: "inventory='" + join(":") + "'";
def md: "md='" + (map("`" + . + "`") | join(", ") + "'");
def yml: "yml='" + "[" + join(", ") + "]'";
def sh: "sh=(" + join(" ") + ")";

[inputs]
  | map({ ansible_hostname, ohai_etc })
  | map(select(.ohai_etc != null))
  | map({ (.ansible_hostname): .ohai_etc.passwd | keys | map(select(index($user))) })
  | add | with_entries(select(.value != [])) | keys
  | (inventory, md, yml, sh)
