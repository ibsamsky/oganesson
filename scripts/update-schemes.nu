use std

# recursively render yaml as nix and strip `#` prefixes from color values
def to-nix [v, depth: int = 0] {
    if ($v | describe) == "string" {
        let s = if ($v | str starts-with "#") {
            ($v | str trim -lc "#" | str upcase)
        } else {
            $v
        }
        $"\"($s)\""
    } else {
        let pad = "  " | std repeat $depth | str join ""

        $v
        | transpose key value
        | sort-by key
        | each {|r|
        $"  ($r.key) = (to-nix $r.value ($depth + 1));"
      }
        | prepend "{"
        | append "}"
        | str join $"\n($pad)"
    }
}

let top = git rev-parse --show-toplevel | str trim
let outdir = $top | path join "data" "themes"
mkdir $outdir
# drop stale themes (upstream may rename/remove schemes)
ls $outdir | where type == file | where {|f| $f.name | str ends-with ".nix" } | each {|f| rm $f.name }

glob (["@base16_schemes@" "share" "themes" "*.yaml"] | path join)
| sort
| each {|f|
    let stem = $f | path parse | get stem
    (to-nix (open $f)) + "\n" | save -f ($outdir | path join ($stem + ".nix"))
    '  "' + $stem + '" = import ./themes/' + $stem + '.nix;'
  }
| prepend "{"
| append "}\n"
| str join "\n"
| save -f ($top | path join "data" "themes.nix")
