package main

import (
	"path/filepath"
	"log"
	"os"
	"os/exec"
	"strings"
)

// Commit built site and push to GitHub pages.
//
// Preconditions: worktree is clean, site has been freshly built
func main() {
	err := deploy()
	if err != nil {
		log.Fatalf("%v", err)
	}
}

func deploy() error {
	const targetBranch = "gh-pages"

	siteDir, err := filepath.Abs("blog/public")
	if err != nil {
		return err
	}

	commitHash, err := getCurrentCommitHash()
	if err != nil {
		return err
	}

	tempdir, err := os.MkdirTemp(os.TempDir(), "blog_deploy")
	if err != nil {
		return err
	}
	defer func() {
		err := os.RemoveAll(tempdir)
		if err != nil {
			log.Printf("cleanup error: %v", err)
		}
	}()

	err = runCmd("git", "worktree", "add", "--no-checkout", tempdir, "gh-pages")
	if err != nil {
		return err
	}
	defer func() {
		err := runCmd("git", "worktree", "remove", "-f", tempdir)
		if err != nil {
			log.Printf("cleanup error: %v", err)
		}
	}()

	err = runCmd("git", "-C", tempdir, "--work-tree", siteDir, "add", "-A")
	if err != nil {
		return err
	}

	err = runCmd("git", "-C", tempdir, "--work-tree", siteDir, "commit", "-m", "deploy "+commitHash)
	if err != nil {
		return err
	}

	err = runCmd("git", "-C", tempdir, "push")
	if err != nil {
		return err
	}

	return nil
}

func runCmd(arg0 string, args ...string) error {
	cmd := exec.Command(arg0, args...)
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	log.Printf("running %v %v", arg0, args)
	return cmd.Run()
}

func getCurrentCommitHash() (string, error) {
	rawHash, err := exec.Command("git", "rev-parse", "HEAD").Output()
	if err != nil {
		return "", err
	}

	return strings.TrimSpace(string(rawHash)), nil
}
