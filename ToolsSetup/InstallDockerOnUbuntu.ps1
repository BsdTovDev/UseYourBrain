function Ask-User($message) {
    Write-Host $message -ForegroundColor Cyan
    $response = Read-Host "Do you want to proceed? (Y/N)"
    return $response -match '^[Yy]'
}

Write-Host "=== Docker Engine Installation Script for Ubuntu 24.04 ===" -ForegroundColor Yellow

# Step 1: Update package index
if (Ask-User "Step 1: Update package index with apt-get update?") {
    sudo apt-get update
    Write-Host "Package index updated." -ForegroundColor Green
} else {
    Write-Host "Skipped package update." -ForegroundColor Yellow
}

# Step 2: Install prerequisites
if (Ask-User "Step 2: Install prerequisites (ca-certificates, curl, gnupg, lsb-release)?") {
    sudo apt-get install -y ca-certificates curl gnupg lsb-release
    Write-Host "Prerequisites installed." -ForegroundColor Green
} else {
    Write-Host "Skipped prerequisites installation." -ForegroundColor Yellow
}

# Step 3: Add Docker’s official GPG key
if (Ask-User "Step 3: Add Docker’s official GPG key?") {
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    Write-Host "Docker GPG key added." -ForegroundColor Green
} else {
    Write-Host "Skipped adding GPG key." -ForegroundColor Yellow
}

# Step 4: Add Docker repository
if (Ask-User "Step 4: Add Docker repository to apt sources?") {
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    Write-Host "Docker repository added." -ForegroundColor Green
} else {
    Write-Host "Skipped adding repository." -ForegroundColor Yellow
}

# Step 5: Update package index again
if (Ask-User "Step 5: Update package index again after adding Docker repo?") {
    sudo apt-get update
    Write-Host "Package index updated." -ForegroundColor Green
} else {
    Write-Host "Skipped second package update." -ForegroundColor Yellow
}

# Step 6: Install Docker Engine and tools
if (Ask-User "Step 6: Install Docker Engine, CLI, containerd, Buildx, and Compose plugin?") {
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    Write-Host "Docker Engine and tools installed." -ForegroundColor Green
} else {
    Write-Host "Skipped Docker installation." -ForegroundColor Yellow
}

# Step 7: Enable and start Docker service
if (Ask-User "Step 7: Enable and start Docker service?") {
    sudo systemctl enable docker
    sudo systemctl start docker
    Write-Host "Docker service enabled and started." -ForegroundColor Green
} else {
    Write-Host "Skipped enabling Docker service." -ForegroundColor Yellow
}

# Step 8: Add current user to docker group
if (Ask-User "Step 8: Add your user to the docker group (to run docker without sudo)?") {
    sudo usermod -aG docker $USER
    Write-Host "User added to docker group. Log out and back in to apply changes." -ForegroundColor Green
} else {
    Write-Host "Skipped adding user to docker group." -ForegroundColor Yellow
}

# Step 9: Verify Docker installation
if (Ask-User "Step 9: Verify Docker installation now?") {
    Write-Host "Checking Docker version..." -ForegroundColor Cyan
    docker --version
    Write-Host "Running hello-world container..." -ForegroundColor Cyan
    docker run hello-world
    Write-Host "Verification complete. Docker is working if you saw the hello-world message." -ForegroundColor Green
} else {
    Write-Host "Skipped Docker verification." -ForegroundColor Yellow
}

Write-Host "`n=== Docker Installation Script Complete ===" -ForegroundColor Yellow
Write-Host "You can verify manually with: docker --version and docker run hello-world" -ForegroundColor Magenta
