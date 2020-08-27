terraform {
  required_version = ">= 0.12"

  backend "gcs" {
        bucket      = "dishout-terraform-state"
        prefix      = "dishout/jenkins-state"
        credentials = "credential/gcp_credentials.json"
    }
}

provider "google" {
  version = "3.5.0"

  credentials = file("credential/gcp_credentials.json")

  project = "dishout-285810" 
  region  = "us-central1"
  zone    = "us-central1-c"
}