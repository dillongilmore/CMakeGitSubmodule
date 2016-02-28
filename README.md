# CMakeGitSubmodule

A CMake module taking care of a project's Git Submodules.

## PREREQUISITES

* CMake
* Git

## USAGE

This module doesn't bootstrap itself so you'll need to submodule or subtree this
repo into your sourcetree.

```
$ cd ~/to/the/repo
$ git submodule add https://github.com/dillongilmore/CMakeGitSubmodule .gitvendor/CMakeGitSubmodule # Rename to your desires
```

Include `GitSubmodule.cmake` in your main `CMakeLists.txt` file. Run
the init macro and add your submodules using the provided macro. If
the submodule does not exist then it will run `git submodule add`. Regardless,
the next step is it will checkout the branch/tag/commit you specified. Finally,
if you feed in the 4th parameter it will look for a cmake directory and append
your `CMAKE_MODULE_PATH`. Examples can be found in the provided `CMakeLists.txt`.

```
list (APPEND CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/.gitvendor/CMakeGitSubmodule"
include (GitSubmodule)
git_submodule_init (".gitvendor") # Use whatever vendor dir you want to use
git_add_submodule ("llvm" "https://github.com/llvm-mirror/llvm") # Defaults to use the master branch
git_add_submodule ("llvm" "https://github.com/llvm-mirror/llvm" "release_38")
git_add_submodule ("llvm" "https://github.com/llvm-mirror/llvm" "release_38" "cmake")
git_add_submodule ("llvm" "https://github.com/llvm-mirror/llvm" "release_38" "true") # Will find the "cmake" dir for you
```

Then run CMake as usual.

```
$ cmake ..
```

Don't forget to commit .gitvendor.

```
$ git add .gitvendor
$ git commit -m "Submodules and automation"
```

## LICENSE

Licensed using The MIT License (MIT). In other words "Don't blame me when
things break"!

## TODO

- Add support for removing submodules that aren't listed (opt-in feature)
- Add feature to check for the files that are needed for the project (types?)

## CONTRIBUTING

Scripts here are very simple. Should be easy to add or fix anything. Make a PR!

