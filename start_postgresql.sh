docker container run --name image_hub_postgresql -p 5432:5432 \
  --network image-hub-network \
  -v image-hub-postgres:/var/lib/postgresql/data \
  --rm -e POSTGRES_PASSWORD=postgres -d postgres
