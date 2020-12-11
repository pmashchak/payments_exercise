class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |exception|
    render json: {}, status: :not_found
  end

  # def get_object_serializer(object, serializer)
  #   ActiveModelSerializers::SerializableResource.new(
  #     object,
  #     serializer: serializer,
  #     include: params.fetch(:include, "")
  #   )
  # end

  # def get_array_serializer(relation, serializer)
  #   ActiveModelSerializers::CollectionSerializer.new(
  #     relation,
  #     each_serializer: serializer,
  #     include: params.fetch(:include, "")
  #   )
  # end
end
