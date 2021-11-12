#!/usr/local/bin/jq -nrf

def inventory: "inventory='" + join(":") + "'";
def md: "md='" + (map("`" + . + "`") | join(", ") + "'");
def yml: "yml='" + "[" + join(", ") + "]'";

[inputs] | map(gsub("\\s+"; "")) | (inventory, md, yml)
