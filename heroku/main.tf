terraform {
  required_providers {
     heroku = {
      source  = "heroku/heroku"
      version = "~> 5.0"
    }
     herokux = {
      source = "davidji99/herokux"
     }
  }
}

# Create a new application
resource "heroku_app" "mnh_backend_prod" {
  name   = "my-new-homie-backend"
  region = "eu"
  buildpacks = [
    "heroku/gradle",
  ]

  stack           = "heroku-22"

}

resource "heroku_config" "mnh_backend_prod_config" {
    vars = {
      SPRING_PROFILE = "prod"
      test = "test"
    }
}

resource "heroku_app_config_association" "mnh_backend_prod_config_association" {
  app_id = heroku_app.mnh_backend_prod.id

  vars = heroku_config.mnh_backend_prod_config.vars
}

# resource "heroku_app" "mnh_backend_dev" {
# 	name = "my-new-homie-backend"  
# 	region="eu"

#   config_vars = {
#     FOOBAR = "baz"
#     SPRING_PROFILE = "prod"
#   }
# }


# resource "heroku_build" "mnh_backend_prod_build" {
#   app_id     = heroku_app.mnh_backend_prod.id
#   #buildpacks = ["https://github.com/mars/create-react-app-buildpack"]

#   source {
#     # This app uses a community buildpack, set it in `buildpacks` above.
#     url = "https://github.com/daszkiewiczk/MyNewHomie-backend"
#   }
# }

# resource "heroku_formation" "mnh_backend_prod_formation" {
#   app_id     = heroku_app.mnh_backend_prod.id
#   type       = "web"
#   quantity   = 1
#   size       = "Basic"
#     depends_on = [ heroku_build.mnh_backend_prod_build ]
# }


resource "heroku_addon" "mnh_database" {
  app_id = heroku_app.mnh_backend_prod.id
  plan   = "heroku-postgresql:mini"
}



# Create a Heroku pipeline
resource "heroku_pipeline" "mnh_backend_pipeline" {
  name = "my-new-homie-backend-pipeline"

  # owner {
  #     id   = "f85fd1e2-7aa9-48e6-a426-f7fec8681cc8" # $(heroku authorizations)
  #     type = "user"
  # }
}

# Couple apps to different pipeline stages
# resource "heroku_pipeline_coupling" "dev" {
#   app_id   = heroku_app.mnh_backend_dev.id
#   pipeline = heroku_pipeline.mnh_backend_pipeline.id
#   stage    = "dev"
# }

resource "heroku_pipeline_coupling" "prod" {
  app_id   = heroku_app.mnh_backend_prod.id
  pipeline = heroku_pipeline.mnh_backend_pipeline.id
  stage    = "production"
}

// Add the GitHub repository integration with the pipeline.
resource "herokux_pipeline_github_integration" "foobar" {
  pipeline_id = heroku_pipeline.mnh_backend_pipeline.id
  org_repo = "daszkiewiczk/MyNewHomie-backend"
}

// Add Heroku app GitHub integration.
resource "herokux_app_github_integration" "foobar" {
  app_id = heroku_app.mnh_backend_prod.uuid
  branch = "main"
  auto_deploy = true
  # wait_for_ci = true

  # Tells Terraform that this resource must be created/updated
  # only after the `herokux_pipeline_github_integration` has been successfully applied.
  depends_on = [herokux_pipeline_github_integration.foobar]
}

# resource "heroku_app" "mnh_frontend" {
# 	name="mynewhomie"
# 	region="eu"
# }
