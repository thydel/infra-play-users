#!/usr/local/bin/jq -nrSf

def union: add | unique;
def union(o): map(.) | union;
def inter: reduce .[1:][] as $i (.[0]; . -= (. - $i));

def humans: { adm, dev, sudo };
def groups: humans + { ssh };

def devs_in_ssh:
  if .dev == [] then empty else { node, users: [.ssh, (humans | union(.))] | inter | sort } end;

def users_in_ssh: if $ARGS.named.group == "dev" then devs_in_ssh else { node, users: .ssh | sort } end;

def get_nodes(groups; extract):
  def have_hohai_etc: map({ ansible_hostname, ohai_etc } | select(.ohai_etc != null));
  def have_groups(groups): map(select([(groups | keys)[] as $group | .ohai_etc.group | has($group)] | all));
  def get_groups(groups):
    def members(groups): groups | map_values(.members);
    map({ node: .ansible_hostname } + { all: .ohai_etc.passwd | keys } + (.ohai_etc.group | members(groups)));
  have_hohai_etc | have_groups(groups) | get_groups(groups) | map(extract);

def by_nodes(groups; extract): get_nodes(groups; extract) | map({ (.node): .users }) | add;
def all_users(groups; extract): by_nodes(groups; extract) | { all_nodes: union(.) };

def invert: to_entries | map(.key as $k | .value[] as $v | { $k, $v }) | reduce .[] as $i ({}; .[$i.v] += [$i.k]);
def by_users(groups; extract): by_nodes(groups; extract) | invert;

def all_users_in_ssh: by_nodes(groups; users_in_ssh) + all_users(groups; users_in_ssh);
def able_users_in_ssh: all_users_in_ssh | { able: [ .all_nodes, .super1 ] | inter };
                                                                                
def md(head; items):
  def sep: " | ";
  def title(head): "\n# By " + head[0] + "\n";
  def head(head): head | ., map("---") | join(sep);
  def lines(items): items | to_entries | sort_by(.key)[] | .key + sep + (.value | join(" "));
  title(head), head(head), lines(items);

def show(head; items): if $ARGS.named.show == "md" then md(head; items) else . end;

def users_in_ssh_group:
    [ "nodes", "users" ] as $head
  | [ { head: $head, items: (all_users_in_ssh + able_users_in_ssh) },
      { head: $head | reverse, items: by_users(groups; users_in_ssh) } ][]
  | show(.head; .items);

[inputs] | users_in_ssh_group

# Local Variables:
# indent-tabs-mode: nil
# End:
