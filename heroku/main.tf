terraform {
  required_providers {
    heroku = {
      source  = "heroku/heroku"
      version = "~> 5.0"
    }
  }
}

# Create a new application
resource "heroku_app" "mnh-backend" {
	name = "my-new-homie-backend"  
	region="eu"
}

resource "heroku_app" "mnh-frontend" {
	name="mynewhomie"
	region="eu"
}
