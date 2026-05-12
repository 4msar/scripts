#!/bin/bash

#
# Change default editor
#
function set-editor() {
    # Get your editor id by this
    # osascript -e 'id of app "Visual Studio Code"'

    EDITOR_ID="dev.zed.Zed"

    # List of file extensions relevant to software engineers
    EXTENSIONS=(
        "c" "cpp" "cc" "h" "hpp"
        "java" "class"
        "js" "jsx" "ts" "tsx"
        "py" "pyw"
        "rb"
        "sh" "bash"
        "bat" "cmd"
        "go"
        "php"
        "swift"
        "cs"
        "pl" "pm"
        "lua"
        "kt" "kts"
        "scala"
        "rs"
        "r"
        "dart"
        "xml" "json" "yml" "yaml"
        "css" "scss" "sass" "less"
        "md"
        "sql"
        "asm" "s"
        "m" "mm"
        "ex" "exs"
        "erl"
        "hs"
        "lisp" "cl"
        "groovy"
        "fs" "fsi" "fsx"
        "vue"
        "coffee"
        "ini" "conf" "cfg" "toml" "env"
        "dockerfile" "dockerignore"
        "gemspec" "gradle" "pom.xml"
        "lock" "package" "yarn.lock"
        "pbxproj" "xcworkspace" "xcodeproj"
        "sln" "csproj" "vbproj"
        "make" "mak" "mk"
        "gitignore" "gitattributes"
        "proto"
        "f90" "f" "for"
        "pas"
        "adb" "ads"
        "matlab"
        "ps1"
        "hbs"
        "jade" "pug"
        "ejs"
        "tpl"
    )

    # Associate each extension with Zed using duti
    for ext in "${EXTENSIONS[@]}"; do
        duti -s "$EDITOR_ID" .$ext all
    done

    echo "All specified code file extensions are now set to open with Zed."
}