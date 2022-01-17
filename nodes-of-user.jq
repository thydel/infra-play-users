#!/usr/local/bin/jq -nrf

def inventory: "inventory='" + join(":") + "'";
def md: "md='" + (map("`" + . + "`") | join(", ") + "'");
def yml: "yml='" + "[" + join(", ") + "]'";
def sh: "sh=(" + join(" ") + ")";
def txt: join("\n");

[inputs]
  | map({ ansible_hostname, ohai_etc })
  | map(select(.ohai_etc != null))
  | map({ (.ansible_hostname): .ohai_etc.passwd | keys | map(select(index($user))) })
  | add | with_entries(select(.value != [])) | keys
  | if $ARGS.named.fmt == "txt" then txt else (inventory, md, yml, sh) end
