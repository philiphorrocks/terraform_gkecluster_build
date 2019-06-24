// Configure the Google Cloud provider
provider "google" {
 credentials = "${file("gcpserviceaccount.json")}"
 project     = "terraform-243812"
 region      = "europe-west1"
}
