function yldme-link
    for url in $argv
        echo (curl -s -X POST -d "$url" "https://yld.me/url")
    end
end
