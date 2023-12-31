terraform {
  required_version = ">= 0.14"
  # Specify the required version of Terraform
  # Add any backend configuration here if needed
}

variable "github_token" {
  type = string
  # Declare a variable for the GitHub token
}

variable "github_owner" {
  type = string
  # Declare a variable for the GitHub owner
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
  # Configure the GitHub provider with the provided token and owner
}

resource "github_repository" "example" {
  name        = "MatLap"
  description = "Mein tolles Repository erstellt mit Terraform."
  visibility  = "public"
  # Create a GitHub repository with the specified name, description, and visibility
}

locals {
  main_tf_content = file("${path.module}/main.tf")
  gitignore_content = file("${path.module}/.gitignore")
  # Define local variables for the contents of the main.tf and .gitignore files
}

resource "github_repository_file" "main_tf" {
  repository = github_repository.example.name
  file       = "main.tf"
  content    = local.main_tf_content
  # Create a file in the GitHub repository with the contents of the main.tf file
}

resource "github_repository_file" "gitignore" {
  repository = github_repository.example.name
  file       = ".gitignore"
  content = local.gitignore_content
  # Create a file in the GitHub repository with the contents of the .gitignore file
}

# Create a file in the GitHub repository with the specified name, containing the README content
# The README provides instructions for creating the repository and mentions the required Terraform.tfvars file
resource "github_repository_file" "readme" {
  repository = github_repository.example.name
  file       = "README.md"
  content    = <<EOT
  # Mein Tolles Terraform-Repository

  ## Dies ist die README-Datei für mein tolles Repository, das ich mit Terraform erstellt habe. 

  ### Um das Repository zu erstellen, wird zusätzlich eine `Terraform.tfvars` Datei benötigt. 

  **In der `.tfvars` Datei müssen die Variablen `github_token` und `github_owner` eingetragen werden.**

  **Beispiel:**
  ```hcl
  github_token = "beispieltoken"
  github_owner = "Satisfraction"
  ```

  ### Befehle zum Ausführen von Terraform:
  - **init:**
  ```shell
  terraform init
  ```

  - **plan:**
  ```shell
  terraform plan
  ```

  - **apply:**
  ```shell
  terraform apply
  ```

  **Bitte achte darauf, dass die github_token und github_owner Variablen in der .tfvars Datei korrekt eingetragen sind, bevor du die Terraform-Befehle ausführst.**
  EOT
}

resource "github_repository_file" "license" {
  # Define a resource block for creating a file in a GitHub repository.
  # The resource type is "github_repository_file" and the name is "license".

  # Specify the repository name where the file will be created.
  repository = github_repository.example.name

  # Specify the file name as "LICENSE".
  file       = "LICENSE"

  # Specify the content of the file using a heredoc syntax.
  content    = <<EOT
MIT License

Copyright (c) 2023 Satisfraction

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOT
}
