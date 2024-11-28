
# Environment Setup
- Install Visual Studio
- Install VS Code
- Install Chocolatey
    - https://chocolatey.org/install
- Install Terraform
    - choco install terraform
- Install Git
    - Make sure core.autocrlf-true
- Set Git Config
``` shell
    $ git config --global user.name "John Doe"
    $ git config --global user.email "johndoe@mailinator.com"
```
- Install nvm (https://github.com/nvm-sh/nvm#install--update-script)
    - Create ``.bash_profile`` file in your home directory (Typcally `C:\Users\YourUserName`)
    - Open Git Bash and run this line: 
        - `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.4/install.sh | bash`
            - If you see an error about bash being not recognized, you may need to add `C:\Program Files\Git\bin` (or whatever your path is) to your emvironment variables.
        - Once install is complete run this line to start using nvm

        -   >export NVM_DIR="$HOME/.nvm"
            >[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
            >[ -s "$NVM_DIR/bash_completion.sh" ] && \. "$NVM_DIR/bash_completion.sh"

        - Verify that nvm is installed by running this command:
            - `nvm -v`
        - Install Node
            - Open Git Bash and run: `nvm install node # "node is an alias for the latest version"`
        - Verify Installation: `node -v`
        - Setup SSH key for Git (optional)
            - https://learn.microsoft.com/en-us/azure/devops/repos/git/use-ssh-keys-to-authenticate?view=azure-devops
        - Docker
            - Make sure virtualization is enabled
                - Task manager > Performance tab > You should see 'Virtualization: Enabled'
            - Install WSL
                - Open PowerShell or Windows Command Prompt in administrator mode and run: `wsl --install` (https://learn.microsoft.com/en-us/windows/wsl/install)
                - Open windows features and enable:
                    - Virtual Machine Platform
                    - Windows Hypervisor Platform
                    - Windows Subsystem for Linux
                - From PowerShell enable WSL-1 by running the following command:
                    - `dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart`
                - Download the Linux Kernel installer from MS (https://learn.microsoft.com/en-us/windows/wsl/install-manual#step-4--download-the-linux-kernel-update-package)
                - Run the Linux Kernel Installer
                - From PowerShell set WSL version to 2:
                    - `wsl --set-default-version 2`
            - Download and run docker desktop for windows (https://docs.docker.com/desktop/install/windows-install/)
            - Add docker-user to your non-admin login (only needed if having a separate admin account to install stuff)
                - Open in PowerShell as admin
                - Run this command:
                    - `net localgroup docker-users "domain\YourUserName" /ADD`
                - Restart your computer.
            - If any UIs need to access Devops Artifacts for internal npm packages you need to setup `vsts-npm-auth`
                -   > npm install -g vsts-npm-auth
                    > vsts-npm-auth -config .npmrc
                - Login prompt should open up and you should login with your credentials.
            - Install Yarn:
                - `npm install -g yarn`
            - Install Azure CLI
                - Can be done by command line or via an installer.
                    - Installer can be found on the Azure CLI website: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-windows?tabs=azure-cli
                - Alternately, Open PowerShell as an Admin and run this:
                    - `$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi; Start-Process msiexec.exe -Wait -ArgumentList '/I AzureCLI.msi /quiet'; Remove-Item .\AzureCLI.msi`
            - Install Azure Functions Core Tools
                - `choco install azure-functions-core-tools -y`
				- After install open Visual Studio and navigate to the Tools > Options > Projects and Solutions > Azure Functions option and click 'Check for updates'

- Git Bash Integration in Visual Studio
  - Add Git Bash to Visual Studio Terminal
    - Open the Tools > Options > Environment > Terminal Menu option and add a new terminal pointing to the git sh.exe cli
      ![./.readme-assets/adding-git-bash-to-visualstudio-terminal.png](Adding)
    - Then select the View > Terminal menu and pick your new Git Bash terminal.
      ![./.readme-assets/using-git-bash-in-visualstudio-terminal.png](Adding)

  - Add Git Bash to Visual Studio External Tools
    - Open the Tools > External Tools Menu option and add a new terminal pointing to the git git-bash.exe cli
      ![./.readme-assets/adding-git-bash-to-visualstudio-external-tools.png](Adding)

