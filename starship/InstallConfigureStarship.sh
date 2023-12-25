cd

echo 'eval "$(starship init bash)"' >> ~/.bashrc
mkdir -p ~/.config && touch ~/.config/starship.toml
curl https://raw.githubusercontent.com/niklasilves/TerminalTheme/main/starship/.starship/starship.toml -o ~/.config/starship.toml

curl -sS https://starship.rs/install.sh | sh
