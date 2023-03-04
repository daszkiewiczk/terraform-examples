output "mnh_backend_prod_url" {
  value = "https://${heroku_app.mnh_backend_prod.name}.herokuapp.com"
}

# output "mnh_frontend_url" {
#   value = "https://${heroku_app.mnh_frontend.name}.herokuapp.com"
# }