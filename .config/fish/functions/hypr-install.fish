function hypr-install
    cd (mktemp -d)

    echo $argv

    git clone --recursive git@github.com:hyprwm/Hyprland.git
    cd Hyprland

    git checkout $argv

    sudo make install
end
