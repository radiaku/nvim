# Pinned commits

Nearly every plugin spec pins an exact `commit = "..."`. This config favors **reproducibility over latest**.

Key fact: `lazy-lock.json` is **gitignored** (`.gitignore` lists `*.json` and `lazy-lock.json`). So the lockfile is not version-controlled — the inline `commit =` fields in each spec **are the real lockfile**.

Implications:
- When editing a spec, **preserve the pin** unless deliberately bumping it.
- To upgrade a plugin, change its `commit =` and run `:Lazy sync`. → [[verification]]
- Don't rely on `lazy-lock.json` to reconstruct versions; read the specs.

Links: [[plugin-organization]] · [[verification]] · [[index]]

#plugins #core
