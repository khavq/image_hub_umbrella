docker run --name image_hub_app \
  --network image-hub-network \
  -e SECRET_KEY_BASE=RYV68wKP+wsKHfHn1MTt0VDd9NettGZKVU8Udi91cbJk4v1kp1ypy/r+k5lRDacU \
  -e APP_HOSTNAME=localhost \
  -e DB_USER=postgres \
  -e DB_PASSWORD=postgres \
  -e DB_NAME=image_hub_prod \
  -e DB_HOST=image_hub_postgresql \
  -e APP_PORT=4000 --rm image-hub-app
