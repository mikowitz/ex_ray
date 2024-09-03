defprotocol ExRay.Hittable do
  def hit(this, ray, interval)
end
