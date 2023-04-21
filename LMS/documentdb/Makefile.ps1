# Set arguments
$ACTION=$args[1]
$ENV=$args[2]

# Define functions

function Confirm-Environment {
    echo "[INFO] Checking environment..."
    if (-not (Test-Path -Path "environments/$ENV"))
    {
        echo "[ERROR] Environment directory doesn't exist"
        Exit
    }
}

function Confirm-Success {
    if ($LastExitCode -ne 0)
      {
        echo "[ERROR] Command failed"
        exit
      }
}

function Invoke-Init {
    echo "[INFO]: Performing terraform init"
    $result=terraform init -reconfigure
    echo $result
}

function Invoke-Plan {
    echo "[INFO]: Performing terraform plan"
    terraform plan -refresh=true
    echo "Done!"
}

function Invoke-Apply {
    echo "[INFO]: Performing terraform plan"
    terraform apply -refresh=true
    echo "Done!"
}

function Invoke-Destroy {
    echo "[INFO]: Performing terraform plan"
    terraform destroy -refresh=true
    echo "Done!"
}

function Invoke-Fmt {
    echo "[INFO] Performing terraform fmt recursively."
    terraform fmt -recursive
    echo "Done!"
}

# Perform actions

switch  ($ACTION)
{
    "init" {
        Confirm-Environment
        chdir "environments/$ENV"
        Invoke-Init
    }

    "plan" {
        Confirm-Environment
        chdir "environments/$ENV"
        Invoke-Init
        Confirm-Success
        Invoke-Plan
        Confirm-Success
    }

    "apply" {
        Confirm-Environment
        chdir "environments/$ENV"
        Invoke-Init
        Confirm-Success
        Invoke-Apply
        Confirm-Success
    }

    "destroy" {
        Confirm-Environment
        chdir "environments/$ENV"
        Invoke-Init
        Confirm-Success
        Invoke-Destroy
        Confirm-Success
    }

    "fmt" {
        Invoke-Fmt
    }
}
