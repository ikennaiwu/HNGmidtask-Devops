# DevOpsFetch

`devopsfetch` is a tool designed for retrieving and monitoring server information. It collects and displays data on active ports, Docker images and containers, Nginx configurations, user login information, and activities within specified time ranges. This tool is useful for DevOps professionals to efficiently gather system details and manage server resources.

## Features

- **Ports**: Display all active ports and services or detailed information about a specific port.
- **Docker**: List all Docker images and containers or provide details about a specific container.
- **Nginx**: Show all Nginx domains and their ports or detailed configuration for a specific domain.
- **Users**: List all users and their last login times or provide details about a specific user.
- **Time Range**: Display activities within a specified time range.

## Installation

### Prerequisites

Ensure you have the following installed on your system:
- `net-tools`
- `docker.io`
- `nginx`
- `systemd`

### Installation Script

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/devopsfetch.git
    cd devopsfetch
    ```

2. Make the installation script executable and run it:
    ```bash
    chmod +x install.sh
    sudo ./install.sh
    ```

### Manual Installation

If you prefer to install manually, follow these steps:

1. **Copy the `devopsfetch` script:**
    ```bash
    sudo cp devopsfetch /usr/local/bin/devopsfetch
    sudo chmod +x /usr/local/bin/devopsfetch
    ```

2. **Create a systemd service file:**
    ```bash
    sudo tee /etc/systemd/system/devopsfetch.service <<EOF
    [Unit]
    Description=DevOpsFetch Service

    [Service]
    ExecStart=/usr/local/bin/devopsfetch --time '00:00:00' '23:59:59'
    Restart=always
    User=root

    [Install]
    WantedBy=multi-user.target
    EOF
    ```

3. **Reload systemd, enable, and start the service:**
    ```bash
    sudo systemctl daemon-reload
    sudo systemctl enable devopsfetch.service
    sudo systemctl start devopsfetch.service
    ```

## Usage

Run `devopsfetch` with the desired options:

```bash
devopsfetch [OPTION] [ARGUMENT]
./devopsfetchsh -p 80
./devopsfetch.sh -d
./devopsfetch.sh -n
./devopsfetch.sh -u
./devopsfetch.sh -t '08:00:00' '17:00:00'
```

## Logging and MOnitoring

4. **devopsfetch can be run as a systemd service for continuous monitoring. Logs are managed by systemd and can be viewed using:**

```bash
sudo journalctl -u devopsfetch.service
```
## Contribution

Contributions are welcome! Please fork the repository and submit a pull request with your changes. For any issues or feature requests, please open an issue on GitHub.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

