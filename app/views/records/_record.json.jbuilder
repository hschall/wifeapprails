json.extract! record, :id, :fecha, :concepto, :importe, :comentario, :created_at, :updated_at
json.url record_url(record, format: :json)
