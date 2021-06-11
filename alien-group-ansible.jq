def title: ", " as $s | "Adds \(.value | join($s)) to \(.key) on {{ inventory_hostname }}";
def tasks: { name: title, user: { name: "{{ item }}", groups: .key, append: true }, loop: .value };
def play: { hosts: .key, gather_facts: false, become: true, tasks: (.value | to_entries | map(tasks)) };
def struct: reduce .[] as { $node, $group, $user, $done } ({}; .[$node | split(".")[0]][$group] += if $done == false then [$user] else [] end);
struct | to_entries | map(play)
