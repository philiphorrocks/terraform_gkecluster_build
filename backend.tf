terraform {
   backend "gcs" {
   bucket  = "terraform-243812"
   prefix  = "terraform-243812"
   credentials = "gcpserviceaccount.json"
 }
}
