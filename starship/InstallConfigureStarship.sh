curl -sS https://starship.rs/install.sh | sh

eval "$(starship init bash)"

mkdir -p ~/.config && touch ~/.config/starship.toml

vi .config/starship.toml