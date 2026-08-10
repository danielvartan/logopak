# Flathub Submission

This directory holds the files that go into the [Flathub](https://flathub.org) repository for `com.danielvartan.logopak`. They are kept here so that the submitted manifest is versioned together with the packaging files it uses.

| File | Goes to |
| --- | --- |
| `com.danielvartan.logopak.yaml` | root of the Flathub repository |
| `flathub.json` | root of the Flathub repository |

Nothing else is copied. The submitted manifest fetches the build script, launcher, desktop files, icons, MIME definitions, metadata and licenses from a tagged commit of this repository, so those files have a single copy.

## Difference from `flatpak/com.danielvartan.logopak.yaml`

The two manifests run the same build (`flatpak/build.sh`) and declare the same permissions. They differ only in where the packaging files come from:

- `flatpak/com.danielvartan.logopak.yaml` takes them from the working tree, so a change can be built and tested before it is committed.
- `flathub/com.danielvartan.logopak.yaml` takes them from a tag of this repository, because Flathub builds have no access to a working tree.

Keep the two in sync when either one changes.

## Before Submitting or Updating

1. Tag and push the release in this repository (for example `v1.0.0`).
2. Point the `git` source in `com.danielvartan.logopak.yaml` at that tag and at the commit it resolves to:

  ```bash
  git rev-parse v1.0.0^{commit}
  ```

3. Build and test with the submitted manifest itself:

  ```bash
  flatpak install -y flathub org.flatpak.Builder
  flatpak run org.flatpak.Builder --force-clean --sandbox --user \
    --install-deps-from=flathub --ccache \
    --compose-url-policy=full \
    --mirror-screenshots-url=https://dl.flathub.org/media \
    --repo=repo build-dir flathub/com.danielvartan.logopak.yaml
  ```

   `--compose-url-policy=full` is what turns the screenshot and icon URLs
   absolute. Without it the linter reports `appstream-external-screenshot-url`
   and `appstream-remote-icon-not-mirrored`.

   If the build stops at `cannot use bare repository`, `safe.bareRepository` is
   set to `explicit` in the local Git configuration and Flatpak Builder cannot
   make the mirror clone it needs for the `git` source. Flathub's builders do
   not set it. Pass it through for the run:

  ```bash
  flatpak run --env=GIT_CONFIG_COUNT=1 \
    --env=GIT_CONFIG_KEY_0=safe.bareRepository \
    --env=GIT_CONFIG_VALUE_0=all \
    org.flatpak.Builder --force-clean --sandbox --user \
    --install-deps-from=flathub --ccache \
    --compose-url-policy=full \
    --mirror-screenshots-url=https://dl.flathub.org/media \
    --repo=repo build-dir flathub/com.danielvartan.logopak.yaml
  ```

4. Run the linter. Both warnings and errors are fatal on Flathub:

  ```bash
  flatpak run --command=flatpak-builder-lint org.flatpak.Builder \
    manifest flathub/com.danielvartan.logopak.yaml
  ```

  ```bash
  flatpak run --command=flatpak-builder-lint org.flatpak.Builder repo repo
  ```

`finish-args-home-filesystem-access` is expected and needs an exception from the reviewers. See the justification in the manifest comments.

## Opening the Submission Pull Request

Change `<logopak>` to the path of this repository, and `<flathub-fork>` to the fork of `flathub/flathub`:

```bash
git clone --branch=new-pr git@github.com:<flathub-fork>/flathub.git
cd flathub
git checkout -b com.danielvartan.logopak
cp <logopak>/flathub/com.danielvartan.logopak.yaml .
cp <logopak>/flathub/flathub.json .
git add com.danielvartan.logopak.yaml flathub.json
git commit -m "Add com.danielvartan.logopak"
git push origin com.danielvartan.logopak
```

Open the pull request against the `new-pr` branch of [flathub/flathub](https://github.com/flathub/flathub), titled `Add com.danielvartan.logopak`, and comment `bot, build` to request a test build. Do not close the pull request to address review comments.

Reference: <https://docs.flathub.org/docs/for-app-authors/submission>.
