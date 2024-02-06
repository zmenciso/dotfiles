function hypr-install
    set TEMP_DIR (mktemp -d)
    cd $TEMP_DIR

    git clone --recursive git@github.com:hyprwm/Hyprland.git
    cd Hyprland

    if test (count $argv) -eq 0
        git checkout $argv
    end

    sudo make install

    cd ~
    rm -rf $TEMP_DIR
end
