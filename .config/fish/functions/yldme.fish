function yldme
  for url in $argv
    echo (curl -s --form file="@$url" "https://yld.me/paste?raw=1")
  end
end
