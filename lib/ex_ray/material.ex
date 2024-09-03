defprotocol ExRay.Material do
  def scatter(self, ray, hit_record)
end
