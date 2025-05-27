for dir in ~/Desktop ~/Music ~/Videos ~/Pictures ~/Download ~/Documents ~/Public ~/Templates; do
    if [ -d "$dir" ]; then
        rmdir "$dir" && echo "removed $dir"
    else
        echo "skipping $dir (doesn't exist)"
    fi
done
