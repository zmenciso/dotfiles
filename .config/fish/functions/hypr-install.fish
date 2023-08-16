function hypr-install
    cd (mktemp -d)

    git clone --recursive git@github.com:hyprwm/Hyprland.git
    cd Hyprland

    if test (count $argv) -eq 0
        git checkout $argv
    end

    sudo make install
end
