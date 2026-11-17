package content

import (
	"bytes"
	"io/fs"
	"os"
	"path/filepath"
	"testing"
)

// The TUI embeds a copy of the Flutter app's assets (sync_assets.sh). This
// guard fails when a catalog or path is added/changed in the app but the copy
// was not refreshed, so both editions always ship byte-identical content.
func TestEmbeddedContentMatchesTheFlutterAssets(t *testing.T) {
	for _, dir := range []string{"snippets", "learning_paths"} {
		srcDir := filepath.Join("..", "..", "..", "assets", "content", dir)
		entries, err := os.ReadDir(srcDir)
		if err != nil {
			t.Fatal(err)
		}
		seen := 0
		for _, e := range entries {
			if e.IsDir() || filepath.Ext(e.Name()) != ".json" {
				continue
			}
			seen++
			want, err := os.ReadFile(filepath.Join(srcDir, e.Name()))
			if err != nil {
				t.Fatal(err)
			}
			got, err := fs.ReadFile(assets, "assets/"+dir+"/"+e.Name())
			if err != nil {
				t.Errorf("%s/%s is missing from the embedded assets: %v", dir, e.Name(), err)
				continue
			}
			if !bytes.Equal(got, want) {
				t.Errorf("%s/%s is stale — run ./sync_assets.sh", dir, e.Name())
			}
		}
		if seen == 0 {
			t.Fatalf("no JSON files found under %s", srcDir)
		}
	}
}

func TestEveryCatalogLanguageHasADisplayName(t *testing.T) {
	c, err := Load()
	if err != nil {
		t.Fatal(err)
	}
	for _, lang := range c.Languages() {
		if LanguageName(lang) == lang {
			t.Errorf("language %q has no display name in langNames", lang)
		}
	}
}
