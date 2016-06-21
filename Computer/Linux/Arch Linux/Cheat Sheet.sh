# Update package list
pacman -Sy

# Query list of upgradable packages
pacman -Qu

# Update all packages (with confirmation)
pacman -Syu

# Search package
pacman -Ss keyword

# To display extensive information about a given package
pacman -Si package_name

# Install package
pacman -S package_name

# To remove a package and its dependencies which are not required by any other installed package: 
pacman -Rs package_name

# List all packges
pacman -Q

# List all foreign packages
pacman -Qm

# Shows list of files installed by a package
pacman -Ql package_name

# Show list of files to included in a package
pkgfile -l package_name

# Locate .pacnew .pacorig .pacsave files
locate -e --regex "\.pac(new|orig|save)$"

# Check current status of service
systemctl status service_name

# Check if service enabled or not
systemctl is-enabled service_name

# Enable service
sudo systemctl enable service_name

# Start service
sudo systemctl start service_name
